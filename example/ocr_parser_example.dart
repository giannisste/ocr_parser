import 'dart:convert';
import 'dart:io';

import 'package:ocr_parser/ocr_parser.dart';
import 'package:ocr_parser/src/bounding_box_method_features/bounding_box_map/bounding_box_to_word_mapper.dart';
import 'package:ocr_parser/src/documents_features/cosmote/cosmote_document_from_json_mapper.dart';
import 'package:ocr_parser/src/documents_features/cosmote/get_cosmote_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/documents_features/dei/get_dei_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/core/core_types/core_2d/point/point.dart' show Point;
import 'package:ocr_parser/src/documents_features/dei/dei_document_from_json_mapper.dart';
import 'package:ocr_parser/src/documents_features/document_data/document_data_from_json_mapper.dart';
import 'package:ocr_parser/src/documents_features/document_data/get_document_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/documents_features/document_format/find_document_format_usecase.dart';
import 'package:ocr_parser/src/documents_features/document_response/document_response.dart';
import 'package:ocr_parser/src/documents_features/eydap/eydap_document_from_json_mapper.dart';
import 'package:ocr_parser/src/documents_features/eydap/get_eydap_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/documents_features/nova/get_nova_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/documents_features/nova/nova_document_from_json_mapper.dart';
import 'package:ocr_parser/src/documents_features/ocr_parsed_document/ocr_parsed_document.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_block/ocr_block.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document_mapper_provider.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';

void main() async {
  final file = File('./example/nova1.json');
  final content = await file.readAsString();
  final jsonContent = jsonDecode(content);
  final responsesContent =
      (jsonContent['responses'] as List).cast<Map<String, dynamic>>()[0];
  final fullTextAnnotationContent =
      responsesContent['fullTextAnnotation'] as Map<String, dynamic>;
  final pages =
      (fullTextAnnotationContent['pages'] as List).cast<Map<String, dynamic>>();
  final text = (fullTextAnnotationContent['text'] as String);

  final ocrDocument = provideDocumentMapper(()).map(pages);
  final normalizedOcrDocument = normalizeOcrDocument(ocrDocument);

  final googleVisionOcrData = GoogleVisionOcrData(
    text: text,
    ocrDocument: normalizedOcrDocument,
  );

  final findDocumentFormat = FindDocumentFormatUsecase();
  final documentFormatResponse = await findDocumentFormat.execute(
    googleVisionOcrData,
  );

  print(documentFormatResponse.fold((documentFormat) => documentFormat.either4, (_) => 'Error'));

  final documentResponse = await documentFormatResponse.fold(
    (documentFormat) async {
      final getDocumentBoundingBoxMapUsecase = GetDocumentBoundingBoxMapUsecase(
        getDeiBoundingBoxMapUsecase: GetDeiBoundingBoxMapUsecase(),
        getEydapBoundingBoxMapUsecase: GetEydapBoundingBoxMapUsecase(),
        getCosmoteBoundingBoxMapUsecase: GetCosmoteBoundingBoxMapUsecase(),
        getNovaBoundingBoxMapUsecase: GetNovaBoundingBoxMapUsecase(),
      );
      final properDocumentBoundingBoxes = await getDocumentBoundingBoxMapUsecase
          .execute(documentFormat);

      final BoundingBoxToWordMapper boundingBoxMapper = BoundingBoxToWordMapper(
        boundingBoxMapper: LambdaMapper(
          normalizedOcrDocument.first.findClosestParagraph,
        ),
      );
      final documentDataMap = boundingBoxMapper.map(
        properDocumentBoundingBoxes,
      );
      final ocrParsedDocument = OcrParsedDocument(
        documentFormat: documentFormat,
        paragraphMap: documentDataMap,
      );

      final documentDataMapper = DocumentDataFromJsonMapper(
        deiMapper: DeiDocumentFromJsonMapper(AmountMapper()),
        eydapMapper: EydapDocumentFromJsonMapper(AmountMapper()),
        cosmoteMapper: CosmoteDocumentFromJsonMapper(AmountMapper()),
        novaMapper: NovaDocumentFromJsonMapper(AmountMapper()),
      );

      final documentData = documentDataMapper.map(ocrParsedDocument);
      return DocumentResponse.left(documentData);
    },
    (unknownDocumentFormat) {
      
      return Future.value(DocumentResponse.right('Unknown bill provider'));
    },
  );

  print(
    documentResponse.fold(
      (documentData) => documentData.fold(
        (deiDocument) => 'Dei',
        (eydap) => 'Eydap',
        (cosmote) => 'Cosmote',
        (nova) => 'Nova',
        (generic) => 'Generic',
      ),
      (error) => error,
    ),
  );
}

Point<double> normalizeCoordinate(Point<double> point, (double, double) size) {
  return Point(x: point.x / size.$1, y: point.y / size.$2);
}

OcrBoundingBox normalizeBoundingBox(OcrBoundingBox box, (double, double) size) {
  return OcrBoundingBox(
    upperLeft: normalizeCoordinate(box.upperLeft, size),
    upperRight: normalizeCoordinate(box.upperRight, size),
    bottomLeft: normalizeCoordinate(box.bottomLeft, size),
    bottomRight: normalizeCoordinate(box.bottomRight, size),
  );
}

OcrDocument normalizeOcrDocument(OcrDocument document) {
  return document
      .map(
        (page) => OcrPage(
          size: page.size,
          confidence: page.confidence,
          languageConfidences: page.languageConfidences,
          blocks:
              page.blocks
                  .map(
                    (block) => OcrBlock(
                      boundingBox: normalizeBoundingBox(
                        block.boundingBox,
                        page.size,
                      ),
                      paragraphs:
                          block.paragraphs
                              .map(
                                (paragraph) =>
                                    normalizeOcrParagraph(paragraph, page.size),
                              )
                              .toList(),
                      blockType: block.blockType,
                      confidence: block.confidence,
                    ),
                  )
                  .toList(),
        ),
      )
      .toList();
}

OcrParagraph normalizeOcrParagraph(
  OcrParagraph paragraph,
  (double, double) size,
) => OcrParagraph(
  boundingBox: normalizeBoundingBox(paragraph.boundingBox, size),
  words:
      paragraph.words
          .map(
            (word) => word.map(
              (boundingBox) => normalizeBoundingBox(boundingBox, size),
              (symbols) =>
                  symbols
                      .map(
                        (symbol) => symbol.mapBoundingBox(
                          (boundingBox) =>
                              normalizeBoundingBox(boundingBox, size),
                        ),
                      )
                      .toList(),
              (confidence) => confidence,
            ),
          )
          .toList(),
  confidence: paragraph.confidence,
);
