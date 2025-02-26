import 'package:ocr_parser/src/core/core_types/either/either.dart';
import 'package:ocr_parser/src/core/core_types/usecases/usecase.dart';
import 'package:ocr_parser/src/core/extensions/record_map_extension.dart';
import 'package:ocr_parser/src/google_vision_ocr_features/ocr_page/ocr_page.dart';

import '../core/core_types/core_2d/point/point.dart';
import '../core/core_types/predicates/lambda_predicate.dart';
import '../core/core_types/predicates/predicate.dart';
import '../core/core_types/predicates/substring_predicate.dart';
import '../core/mappers/lambda_mapper.dart';
import '../core/mappers/mapper.dart';
import '../documents_features/document_data/document_data.dart';
import '../documents_features/document_format/document_format.dart';
import '../documents_features/document_response/document_response.dart';
import '../documents_features/ocr_parsed_document/ocr_parsed_document.dart';
import '../google_vision_ocr_features/google_vision_ocr_data/google_vision_ocr_data.dart';
import '../google_vision_ocr_features/ocr_block/ocr_block.dart';
import '../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import '../google_vision_ocr_features/ocr_paragraph/ocr_paragraph.dart';
import 'bounding_box_map/bounding_box_map.dart';
import 'bounding_box_map/bounding_box_to_word_mapper.dart';

class FindBoundingBoxesUsecase
    implements Usecase<DocumentResponse, GoogleVisionOcrData> {
  FindBoundingBoxesUsecase({
    required this.preprocessDocumentUsecase,
    required this.getBoundingBoxMapsUsecase,
    required this.documentDataMapper,
    required this.findDocumentFormatUsecase,
  });

  final Usecase<BoundingBoxMap, DocumentFormat> getBoundingBoxMapsUsecase;
  final Mapper<OcrParsedDocument, DocumentData> documentDataMapper;
  final Usecase<DocumentFormatResponse, GoogleVisionOcrData>
  findDocumentFormatUsecase;

  final Usecase<GoogleVisionOcrData, (GoogleVisionOcrData, DocumentFormat)>
  preprocessDocumentUsecase;

  @override
  Future<DocumentResponse> execute(GoogleVisionOcrData event) async {
    try {
      final documentFormatResponse = await findDocumentFormatUsecase.execute(
        event,
      );
      return await documentFormatResponse.fold(
        (documentFormat) async {
          final resultOcrData = await preprocessDocumentUsecase.execute((
            event,
            documentFormat,
          ));
          final boundingBoxToWordMapper = BoundingBoxToWordMapper(
            boundingBoxMapper: LambdaMapper(
              resultOcrData.ocrDocument.first.findClosestParagraph,
            ),
          );
          final result = await getBoundingBoxMapsUsecase.execute(
            documentFormat,
          );
          final foundWordsDictionary = boundingBoxToWordMapper.map(result);
          final ocrParsedDocument = OcrParsedDocument(
            documentFormat: documentFormat,
            paragraphMap: foundWordsDictionary,
          );
          final documentData = documentDataMapper.map(ocrParsedDocument);
          return DocumentResponse.left(documentData);
        },
        (unknownDocument) {
          return Future.value(DocumentResponse.right('Unknown document'));
        },
      );
    } catch (e) {
      return DocumentResponse.right(e.toString());
    }
  }
}

class PreprocessOcrUsecase
    implements
        Usecase<GoogleVisionOcrData, (GoogleVisionOcrData, DocumentFormat)> {
  const PreprocessOcrUsecase({required this.getTargetBoxesUsecase});
  final Usecase<List<OcrBoundingBox>, DocumentFormat> getTargetBoxesUsecase;

  @override
  Future<GoogleVisionOcrData> execute(
    (GoogleVisionOcrData, DocumentFormat) event,
  ) async {
    final targetBoxes = await getTargetBoxesUsecase.execute(event.$2);
    final newData = GoogleVisionOcrData(
      text: event.$1.text,
      ocrDocument:
          event.$1.ocrDocument
              .map(
                (page) => OcrPage(
                  size: page.size,
                  confidence: page.confidence,
                  languageConfidences: page.languageConfidences,
                  blocks: preprocessBlocks(page.blocks, targetBoxes),
                ),
              )
              .toList(),
    );
    return Future.value(newData);
  }
}

List<OcrBlock> preprocessBlocks(
  List<OcrBlock> blocks,
  List<OcrBoundingBox> targetBlocks,
) =>
    targetBlocks
        .fold<List<OcrBlock>>(
          blocks,
          (accumulatedBlocks, target) => partitionBlocksFunctional(
                accumulatedBlocks,
                LambdaPredicate((b) => target.contains(b.boundingBox)),
              )
              .map(mergeBlocks, (s) => s)
              .fold(
                [],
                (mergedBlock, list) =>
                    mergedBlock != null ? [...list, mergedBlock] : list,
                (restBlocks, list) => [...list, ...restBlocks],
              ),
        )
        .map(
          (block) => OcrBlock(
            boundingBox: block.boundingBox,
            paragraphs: sortParagraphs(block.paragraphs),
            blockType: block.blockType,
            confidence: block.confidence,
          ),
        )
        .toList();

List<OcrParagraph> sortParagraphs(List<OcrParagraph> paragraphs) {
  // Create a new list of paragraphs, sorted vertically and horizontally
  final sortedParagraphs =
      paragraphs..sort((a, b) {
        final aUpperLeft = a.boundingBox.upperLeft;
        final bUpperLeft = b.boundingBox.upperLeft;

        // Sort by vertical position (y coordinate) first
        if (aUpperLeft.y != bUpperLeft.y) {
          return aUpperLeft.y.compareTo(bUpperLeft.y);
        }

        // If vertical positions are the same, sort horizontally (x coordinate)
        return aUpperLeft.x.compareTo(bUpperLeft.x);
      });

  return sortedParagraphs;
}

OcrBlock? mergeBlocks(List<OcrBlock> blocks) {
  if (blocks.isEmpty) {
    return null;
  }

  return blocks
      .skip(1)
      .fold<OcrBlock>(
        blocks.first,
        (acc, block) => OcrBlock(
          paragraphs: [...acc.paragraphs, ...block.paragraphs],
          confidence: acc.confidence,
          blockType: acc.blockType,
          boundingBox: mergeBounds(acc.boundingBox, block.boundingBox),
        ),
      );
}

(List<OcrBlock>, List<OcrBlock>) partitionBlocks(
  List<OcrBlock> blocks,
  Predicate<OcrBlock> blockPredicate,
) {
  List<OcrBlock> trueList = [];
  List<OcrBlock> falseList = [];

  for (final block in blocks) {
    if (blockPredicate.check(block)) {
      trueList.add(block);
    } else {
      falseList.add(block);
    }
  }

  return (trueList, falseList);
}

(List<OcrBlock>, List<OcrBlock>) partitionBlocksFunctional(
  List<OcrBlock> blocks,
  Predicate<OcrBlock> blockPredicate,
) => blocks.fold(
  ([], []),
  (acc, block) =>
      blockPredicate.check(block)
          ? ([...acc.$1, block], acc.$2)
          : (acc.$1, [...acc.$2, block]),
);

class GetTargetBoxesUsecase
    implements Usecase<List<OcrBoundingBox>, DocumentFormat> {
  const GetTargetBoxesUsecase(this.ocrData);

  final GoogleVisionOcrData ocrData;
  @override
  Future<List<OcrBoundingBox>> execute(DocumentFormat event) {
    final targetBlocks = event.fold(
      (dei) {
        final d1 = ocrData.ocrDocument.first.findByPredicate(
          SubstringPredicate(substring: 'RF'),
        );
        final d2 = ocrData.ocrDocument.first.findByPredicate(
          SubstringPredicate(substring: 'Η Κατανάλωσή σας'),
        );
        final d3 = ocrData.ocrDocument.first.findByPredicate(
          SubstringPredicate(substring: 'Εκκαθαριστικός'),
        );
        return [
          if (d1 != null)
            OcrBoundingBox(
              upperLeft: d1.boundingBox.upperLeft,
              upperRight: Point(
                x: d1.boundingBox.upperLeft.x + 215.1,
                y: d1.boundingBox.upperLeft.y,
              ),
              bottomLeft: Point(
                x: d1.boundingBox.upperLeft.x,
                y: d1.boundingBox.upperLeft.y + 68.1,
              ),
              bottomRight: Point(
                x: d1.boundingBox.upperLeft.x + 215.1,
                y: d1.boundingBox.upperLeft.y + 68.1,
              ),
            ),
          if (d2 != null)
            OcrBoundingBox(
              upperLeft: d2.boundingBox.upperLeft,
              upperRight: Point(
                x: d2.boundingBox.upperLeft.x + 293,
                y: d2.boundingBox.upperLeft.y,
              ),
              bottomLeft: Point(
                x: d2.boundingBox.upperLeft.x,
                y: d2.boundingBox.upperLeft.y + 114.7,
              ),
              bottomRight: Point(
                x: d2.boundingBox.upperLeft.x + 293,
                y: d2.boundingBox.upperLeft.y + 114.7,
              ),
            ),
          if (d3 != null)
            OcrBoundingBox(
              upperLeft: d3.boundingBox.upperLeft,
              upperRight: Point(
                x: d3.boundingBox.upperLeft.x + 700.1,
                y: d3.boundingBox.upperLeft.y,
              ),
              bottomLeft: Point(
                x: d3.boundingBox.upperLeft.x,
                y: d3.boundingBox.upperLeft.y + 600.7,
              ),
              bottomRight: Point(
                x: d3.boundingBox.upperLeft.x + 700.1,
                y: d3.boundingBox.upperLeft.y + 600.7,
              ),
            ),
        ];
      },
      (eydap) => <OcrBoundingBox>[],
      (cosmote) => <OcrBoundingBox>[],
      (nova) => [
        OcrBoundingBox(
          upperLeft: Point(x: 166, y: 331),
          upperRight: Point(x: 634, y: 331),
          bottomLeft: Point(x: 166, y: 592),
          bottomRight: Point(x: 634, y: 592),
        ),
        OcrBoundingBox(
          upperLeft: Point(x: 126.1, y: 950.5),
          upperRight: Point(x: 926, y: 950.5),
          bottomLeft: Point(x: 126.1, y: 1209.7),
          bottomRight: Point(x: 926, y: 1209.7),
        ),
      ],
    );
    final expandedTargets =
        targetBlocks
            .map(
              (targetBloc) => targetBloc.expandBoundingBox(
                ocrData.ocrDocument.first.size.$1 / 12,
                ocrData.ocrDocument.first.size.$2 / 12,
              ),
            )
            .map(
              (blockTarget) => normalizeBoundingBox(
                blockTarget,
                ocrData.ocrDocument.first.size,
              ),
            )
            .toList();

    return Future.value(expandedTargets);
  }
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

double boundingBoxOverlapRatio(OcrBoundingBox a, OcrBoundingBox b) {
  final aBounds = a.getBounds();
  final bBounds = b.getBounds();

  // Compute intersection bounds
  final overlapMinX =
      aBounds.minPoint.x > bBounds.minPoint.x
          ? aBounds.minPoint.x
          : bBounds.minPoint.x;
  final overlapMaxX =
      aBounds.maxPoint.x < bBounds.maxPoint.x
          ? aBounds.maxPoint.x
          : bBounds.maxPoint.x;
  final overlapMinY =
      aBounds.minPoint.y > bBounds.minPoint.y
          ? aBounds.minPoint.y
          : bBounds.minPoint.y;
  final overlapMaxY =
      aBounds.maxPoint.y < bBounds.maxPoint.y
          ? aBounds.maxPoint.y
          : bBounds.maxPoint.y;

  // Compute overlap width and height
  final overlapWidth = (overlapMaxX - overlapMinX).clamp(0, double.infinity);
  final overlapHeight = (overlapMaxY - overlapMinY).clamp(0, double.infinity);

  // Compute overlap area
  final overlapArea = overlapWidth * overlapHeight;

  // Compute areas of both bounding boxes
  final areaA =
      (aBounds.maxPoint.x - aBounds.minPoint.x) *
      (aBounds.maxPoint.y - aBounds.minPoint.y);
  final areaB =
      (bBounds.maxPoint.x - bBounds.minPoint.x) *
      (bBounds.maxPoint.y - bBounds.minPoint.y);

  // Compute IoU (Intersection over Union)
  final unionArea = areaA + areaB - overlapArea;
  return unionArea == 0 ? 0.0 : (overlapArea / unionArea);
}
