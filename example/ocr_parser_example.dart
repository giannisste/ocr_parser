import 'dart:convert';
import 'dart:io';

import 'package:ocr_parser/ocr_parser.dart';
import 'package:ocr_parser/src/core/core_types/core_2d/point/point.dart'
    show Point;
import 'package:ocr_parser/src/google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_block/ocr_block.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document_mapper_provider.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import 'package:ocr_parser/src/ocr_usecase/ocr_usecase_provider.dart';

void main() async {
  final file = File('./example/dei7.json');
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
    ocrDocument: ocrDocument,
  );  
  final googleVisionOcrData2 = GoogleVisionOcrData(
    text: text,
    ocrDocument: normalizedOcrDocument,
  );
  
  // final preprocessUsecase = PreprocessOcrUsecase(getTargetBoxesUsecase: GetTargetBoxesUsecase(googleVisionOcrData));
  // final newData = await preprocessUsecase.execute((googleVisionOcrData2, DocumentFormat.dei(DeiDocumentFormat())));

  // print(newData.ocrDocument.first.blocks.length);
  // for (final page in newData.ocrDocument) {
  //   for (final block in page.blocks) {
  //     print(block.paragraphs.length);
  //     print(
  //       block.paragraphs
  //           .map((paragraph) => paragraph.toParagraph().trim())
  //           .toList(),
  //     );
  //   }
  // }

  final ocrUsecase = provideOcrUsecase(googleVisionOcrData);
  final documentResponse = await ocrUsecase.execute(googleVisionOcrData2);

  print(
    documentResponse.fold(
      (documentData) => documentData.fold(
        (deiDocument) => 'Dei(${deiDocument.address}, ${deiDocument.paymentAmount}, ${deiDocument.rfCode})',
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
