import '../../bounding_box_method_features/bounding_box_map/bounding_box_map.dart';
import '../../core/core_types/core_2d/point/point.dart';
import '../../core/core_types/predicates/predicate.dart';
import '../language_confidence/language_confidence.dart';
import '../ocr_block/ocr_block.dart';
import '../ocr_bounding_box/ocr_bounding_box.dart';
import '../ocr_paragraph/ocr_paragraph.dart';

class OcrPage {
  const OcrPage({
    required this.size,
    required this.confidence,
    required this.languageConfidences,
    required this.blocks,
  });

  final (double, double) size;
  final List<LanguageConfidence> languageConfidences;
  final double confidence;
  final List<OcrBlock> blocks;

  OcrBoundingBox get boundingBox => OcrBoundingBox(
    upperLeft: const Point(x: 0, y: 0),
    upperRight: Point(x: 1.0, y: 0),
    bottomLeft: Point(x: 0, y: 1.0),
    bottomRight: Point(x: 1, y: 1.0),
  );
}

extension OcrPageSearch on OcrPage {
  OcrParagraph? findByPredicate(Predicate<String> predicate) {
    OcrParagraph? closest;
    for (final block in blocks) {
      for (final paragraph in block.paragraphs) {
        final paragraphText = paragraph.toParagraph().trim();
        if (predicate.check(paragraphText)) {
          return paragraph;
        }
      }
    }
    return closest;
  }

  OcrParagraph? findClosestParagraph(TargetWord targetWord) {
    OcrParagraph? closest;
    double minDistance = double.infinity;
    final targetBoxScorer = targetWord.boundingBoxScorer;

    // Search all blocks, pruning early if possible
    for (final block in blocks) {
      if (targetBoxScorer.score(block.boundingBox) >= minDistance) {
        continue; // Skip this block if it's farther than the closest found paragraph
      }

      // Search paragraphs within the block
      for (final paragraph in block.paragraphs) {
        final paragraphText = paragraph.toParagraph().trim();
        if (targetWord.predicate.check(paragraphText)) {
          return paragraph;
        } else if ((targetWord.avoidPredicate != null &&
            !targetWord.avoidPredicate!.check(paragraphText))) {
          double distance = targetBoxScorer.score(paragraph.boundingBox);
          if (distance < minDistance) {
            minDistance = distance;
            closest = paragraph;
          }
        }
      }
    }
    return closest;
  }
}
