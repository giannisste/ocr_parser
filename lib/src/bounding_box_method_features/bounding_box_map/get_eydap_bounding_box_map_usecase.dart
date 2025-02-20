import '../../core_types/core_2d/point/point.dart' show Point;
import '../../core_types/predicates/substring_predicate.dart';
import '../../core_types/usecases/usecase.dart';
import '../../google_vision_ocr_features/ocr_bounding_box/ocr_bounding_box.dart';
import 'bounding_box_map.dart';

class GetEydapBoundingBoxMapUsecase implements Usecase<BoundingBoxMap, String> {
  @override
  Future<BoundingBoxMap> execute(String event) {
    final value = {
      'rfCode': TargetWord(
        boundingBox: OcrBoundingBox(
          upperLeft: Point(x: 0.5273333333333333, y: 0.308),
          upperRight: Point(x: 0.778, y: 0.307),
          bottomLeft: Point(x: 0.778, y: 0.317),
          bottomRight: Point(x: 0.5273333333333333, y: 0.318),
        ),
        predicate: SubstringPredicate(substring: 'RF'),
        avoidPredicate: null,
      ),
      'address': TargetWord(
        boundingBox: OcrBoundingBox(
          upperLeft: Point(x: 0.288, y: 0.46),
          upperRight: Point(x: 0.408, y: 0.46),
          bottomLeft: Point(x: 0.408, y: 0.4785),
          bottomRight: Point(x: 0.288, y: 0.4785),
        ),
        predicate: SubstringPredicate(substring: 'ΖΑΚΥΝΘΟΣ'),
        avoidPredicate: null,
      ),
      'totalAmount': TargetWord(
        boundingBox: OcrBoundingBox(
          upperLeft: Point(x: 0.5253333333333333, y: 0.4065),
          upperRight: Point(x: 0.618, y: 0.4065),
          bottomLeft: Point(x: 0.618, y: 0.419),
          bottomRight: Point(x: 0.5253333333333333, y: 0.419),
        ),
        predicate: SubstringPredicate(substring: '€'),
        avoidPredicate: null,
      ),
    };
    return Future.value(value);
  }
}
