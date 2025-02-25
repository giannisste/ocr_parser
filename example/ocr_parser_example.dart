import 'dart:convert';
import 'dart:io';

import 'package:ocr_parser/src/bounding_box_method_features/find_bounding_boxes_usecase.dart';
import 'package:ocr_parser/src/core/core_types/core_2d/point/point.dart'
    show Point;
import 'package:ocr_parser/src/documents_features/document_format/document_format.dart';
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

  final preprocessUsecase = PreprocessOcrUsecase(getTargetBoxesUsecase: GetTargetBoxesUsecase(googleVisionOcrData.ocrDocument.first.size));
  final newData = await preprocessUsecase.execute((googleVisionOcrData, DocumentFormat.nova(NovaDocumentFormat())));

  print(newData.ocrDocument.first.blocks.length);
  for (final page in newData.ocrDocument) {
    for (final block in page.blocks) {
      print('Block');
      print(block.paragraphs.length);
      print(
        block.paragraphs
            .map((paragraph) => paragraph.toParagraph().trim())
            .toList(),
      );
    }
  }

  // final ocrUsecase = provideOcrUsecase(googleVisionOcrData.ocrDocument.first.size);
  // final documentResponse = await ocrUsecase.execute(googleVisionOcrData);

  // print(
  //   documentResponse.fold(
  //     (documentData) => documentData.fold(
  //       (deiDocument) => 'Dei',
  //       (eydap) => 'Eydap',
  //       (cosmote) => 'Cosmote',
  //       (nova) => 'Nova',
  //       (generic) => 'Generic',
  //     ),
  //     (error) => error,
  //   ),
  // );
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
