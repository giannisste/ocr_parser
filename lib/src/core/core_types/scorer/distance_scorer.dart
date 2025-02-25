import 'dart:math' show sqrt;

import '../../../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import 'scorer.dart';

class ManhattanDistanceScorer implements Scorer<OcrBoundingBox> {
  const ManhattanDistanceScorer({required this.target});

  final OcrBoundingBox target;

  @override
  double score(OcrBoundingBox data) {
    final dx = (data.center.x - target.center.x);
    final dy = (data.center.y - target.center.y);
    return dx.abs() + dy.abs();
  }
}

class EuclideanDistanceScorer implements Scorer<OcrBoundingBox> {
  const EuclideanDistanceScorer({required this.target});

  final OcrBoundingBox target;

  @override
  double score(OcrBoundingBox data) {
    final dx = (data.center.x - target.center.x);
    final dy = (data.center.y - target.center.y);
    return sqrt(dx * dx + dy * dy);
  }
}
