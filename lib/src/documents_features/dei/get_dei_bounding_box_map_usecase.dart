import '../../core/core_types/core_2d/point/point.dart';
import '../../core/core_types/predicates/and_predicate.dart';
import '../../core/core_types/predicates/datetime/is_valid_date_predicate.dart';
import '../../core/core_types/predicates/starts_with_predicate.dart';
import '../../core/core_types/predicates/substring_predicate.dart';
import '../../core/core_types/scorer/distance_scorer.dart';
import '../../core/core_types/usecases/usecase.dart';
import '../../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import '../../bounding_box_method_features/bounding_box_map/bounding_box_map.dart';
import '../document_format/document_format.dart';

class GetDeiBoundingBoxMapUsecase
    implements Usecase<BoundingBoxMap, DeiDocumentFormat> {
  @override
  Future<BoundingBoxMap> execute(DeiDocumentFormat event) {
    final map = {
      'rfCode': TargetWord(
        boundingBoxScorer: ManhattanDistanceScorer(
          target: OcrBoundingBox(
            upperLeft: Point(x: 0.1276923076923077, y: 0.2576882290562036),
            upperRight: Point(x: 0.4046153846153846, y: 0.2576882290562036),
            bottomLeft: Point(x: 0.4046153846153846, y: 0.2841993637327678),
            bottomRight: Point(x: 0.1276923076923077, y: 0.2841993637327678),
          ),
        ),
        predicate: SubstringPredicate(substring: 'RF'),
        avoidPredicate: null,
      ),
      'address': TargetWord(
        boundingBoxScorer: ManhattanDistanceScorer(
          target: OcrBoundingBox(
            upperLeft: Point(x: 0.2523076923076923, y: 0.43160127253446445),
            upperRight: Point(x: 0.46307692307692305, y: 0.43160127253446445),
            bottomLeft: Point(x: 0.2523076923076923, y: 0.4496288441145281),
            bottomRight: Point(x: 0.46307692307692305, y: 0.4496288441145281),
          ),
        ),
        predicate: SubstringPredicate(substring: 'ΖΑΚΥΝΘΟΣ'),
        avoidPredicate: SubstringPredicate(substring: '/'),
      ),
      'totalAmount': TargetWord(
        boundingBoxScorer: ManhattanDistanceScorer(
          target: OcrBoundingBox(
            upperLeft: Point(x: 0.5153846153846153, y: 0.3743372216330859),
            upperRight: Point(x: 0.6569230769230769, y: 0.3753976670201485),
            bottomLeft: Point(x: 0.6569230769230769, y: 0.3944856839872747),
            bottomRight: Point(x: 0.5153846153846153, y: 0.3934252386002121),
          ),
        ),
        predicate: BothPredicate(
          firstPredicate: SubstringPredicate(substring: '€'),
          secondPredicate: StartsWithPredicate(start: '*'),
        ),
        avoidPredicate: null,
      ),
      'dueDate': TargetWord(
        boundingBoxScorer: ManhattanDistanceScorer(
          target: OcrBoundingBox(
            upperLeft: Point(x: 0.52, y: 0.4252386002120891),
            upperRight: Point(x: 0.6707692307692308, y: 0.4252386002120891),
            bottomLeft: Point(x: 0.6707692307692308, y: 0.4411452810180276),
            bottomRight: Point(x: 0.52, y: 0.4411452810180276),
          ),
        ),
        predicate: IsValidDatePredicate(),
        avoidPredicate: null,
      ),
    };

    return Future.value(map);
  }
}
