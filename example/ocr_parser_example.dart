import 'dart:convert';
import 'dart:io';

import 'package:ocr_parser/ocr_parser.dart';
import 'package:ocr_parser/src/bounding_box_method_features/bounding_box_map/bounding_box_to_word_mapper.dart';
import 'package:ocr_parser/src/bounding_box_method_features/bounding_box_map/get_dei_bounding_box_map_usecase.dart';
import 'package:ocr_parser/src/core_types/core_2d/point/point.dart';
import 'package:ocr_parser/src/core_types/predicates/and_predicate.dart';
import 'package:ocr_parser/src/core_types/predicates/starts_with_predicate.dart';
import 'package:ocr_parser/src/core_types/predicates/substring_predicate.dart';
import 'package:ocr_parser/src/documents_features/dei/dei_document_from_json_mapper.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_block/ocr_block.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_document/ocr_document_mapper_provider.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_symbol/ocr_symbol.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_word/ocr_word.dart';

void main() async {
  final file = File('./example/dei7.json');
  final content = await file.readAsString();
  final jsonContent = jsonDecode(content);
  final responsesContent = (jsonContent['responses'] as List).cast<Map<String, dynamic>>()[0];
  final fullTextAnnotationContent = responsesContent['fullTextAnnotation'] as Map<String, dynamic>;
  final pages = (fullTextAnnotationContent['pages'] as List).cast<Map<String, dynamic>>();

  final ocrDocument = provideDocumentMapper(()).map(pages);
  final normalizedOcrDocument = normalizeOcrDocument(ocrDocument);
  // for (final page in normalizedOcrDocument) {
  //   for (final block in page.blocks) {
  //     for (final paragraph in block.paragraphs) {
  //       final paragraphText = paragraph.toParagraph().trim();
  //       if (paragraphText.contains('05/10/2020')) {
  //         print(paragraph.toParagraph());
  //         print(paragraph.boundingBox);
  //       }
  //     }
  //   }
  // }

  var properDocumentBoundingBoxes = await GetDeiBoundingBoxMapUsecase().execute(null);
  final actualWord = normalizedOcrDocument.first.findByPredicate(
    BothPredicate(
      firstPredicate: SubstringPredicate(substring: '€'),
      secondPredicate: StartsWithPredicate(start: '*'),
    ),
  );
  if (actualWord != null) {
    final offset = actualWord.boundingBox.distanceVector(
      properDocumentBoundingBoxes['totalAmount']!.boundingBox,
    );
    properDocumentBoundingBoxes = await GetDeiBoundingBoxMapUsecase().execute(offset);
  }
  final BoundingBoxToWordMapper deiMapper = BoundingBoxToWordMapper(
    boundingBoxMapper: LambdaMapper(normalizedOcrDocument.first.findClosestParagraph),
  );

  final deiBillJson = deiMapper.map(properDocumentBoundingBoxes);
  final deiDocument = DeiDocumentFromJsonMapper(AmountMapper()).map(deiBillJson);
  print(deiDocument.rfCode);
  print(deiDocument.paymentAmount);
  print(deiDocument.address);
  print(deiDocument.dueDate);
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
                      boundingBox: normalizeBoundingBox(block.boundingBox, page.size),
                      paragraphs:
                          block.paragraphs
                              .map(
                                (paragraph) => OcrParagraph(
                                  boundingBox: normalizeBoundingBox(
                                    paragraph.boundingBox,
                                    page.size,
                                  ),
                                  words:
                                      paragraph.words
                                          .map(
                                            (word) => OcrWord(
                                              boundingBox: normalizeBoundingBox(
                                                word.boundingBox,
                                                page.size,
                                              ),
                                              symbols:
                                                  word.symbols
                                                      .map(
                                                        (symbol) => OcrSymbol(
                                                          boundingBox: normalizeBoundingBox(
                                                            symbol.boundingBox,
                                                            page.size,
                                                          ),
                                                          character: symbol.character,
                                                          confidence: symbol.confidence,
                                                        ),
                                                      )
                                                      .toList(),
                                              confidence: word.confidence,
                                            ),
                                          )
                                          .toList(),
                                  confidence: paragraph.confidence,
                                ),
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
