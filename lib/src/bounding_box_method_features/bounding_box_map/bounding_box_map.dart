import '../../core_types/predicates/predicate.dart';
import '../../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';

typedef BoundingBoxMap = Map<String, TargetWord>;

class TargetWord {
  const TargetWord({
    required this.boundingBox,
    required this.predicate,
    required this.avoidPredicate,
  });

  final OcrBoundingBox boundingBox;
  final Predicate<String> predicate;
  final Predicate<String>? avoidPredicate;

  TargetWord mapBoundingBox(OcrBoundingBox Function(OcrBoundingBox) boundingBoxFunction) =>
      TargetWord(
        boundingBox: boundingBoxFunction(boundingBox),
        predicate: predicate,
        avoidPredicate: avoidPredicate,
      );
}
