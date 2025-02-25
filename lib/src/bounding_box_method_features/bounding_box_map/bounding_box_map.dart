import '../../core/core_types/predicates/predicate.dart';
import '../../core/core_types/scorer/scorer.dart';
import '../../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';

typedef BoundingBoxMap = Map<String, TargetWord>;

class TargetWord {
  const TargetWord({
    required this.boundingBoxScorer,
    required this.predicate,
    required this.avoidPredicate,
  });

  final Scorer<OcrBoundingBox> boundingBoxScorer;
  final Predicate<String> predicate;
  final Predicate<String>? avoidPredicate;
}
