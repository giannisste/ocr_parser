import 'dart:math' show sqrt;

import '../../core/core_types/core_2d/point/point.dart';
import '../../core/core_types/core_2d/rectangle/rectangle.dart';

class OcrBoundingBox {
  OcrBoundingBox({
    required Point<double> upperLeft,
    required Point<double> upperRight,
    required Point<double> bottomLeft,
    required Point<double> bottomRight,
  }) : rectangle = Rectangle(
         upperLeft: upperLeft,
         upperRight: upperRight,
         bottomLeft: bottomLeft,
         bottomRight: bottomRight,
       );

  final Rectangle<double> rectangle;

  Point<double> get upperLeft => rectangle.upperLeft;
  Point<double> get upperRight => rectangle.upperRight;
  Point<double> get bottomLeft => rectangle.bottomLeft;
  Point<double> get bottomRight => rectangle.bottomRight;

  // Get center of the bounding box
  Point<double> get center => Point(
    x: (rectangle.upperLeft.x + rectangle.bottomRight.x) / 2.0,
    y: (rectangle.upperLeft.y + rectangle.bottomRight.y) / 2.0,
  );

  double distanceTo(OcrBoundingBox other) {
    final dx = center.x - other.center.x;
    final dy = center.y - other.center.y;
    return sqrt(dx * dx + dy * dy);
  }

  double distanceToManhattan(OcrBoundingBox other) {
    double dx = (center.x - other.center.x).abs();
    double dy = (center.y - other.center.y).abs();
    return dx + dy;
  }

  bool overlaps(OcrBoundingBox other) {
    return !(rectangle.bottomRight.x < rectangle.upperLeft.x ||
        rectangle.upperLeft.x > other.rectangle.bottomRight.x ||
        rectangle.bottomRight.y < other.rectangle.upperLeft.y ||
        rectangle.upperLeft.y > other.rectangle.bottomRight.y);
  }

  Point<double> distanceVector(OcrBoundingBox other) {
    return Point(
      x: upperLeft.x - other.upperLeft.x,
      y: upperLeft.y - other.upperLeft.y,
    );
  }

  OcrBoundingBox translate(Point<double> offset) => OcrBoundingBox(
    upperLeft: Point(
      x: rectangle.upperLeft.x + offset.x,
      y: rectangle.upperLeft.y + offset.y,
    ),
    upperRight: Point(
      x: rectangle.upperRight.x + offset.x,
      y: rectangle.upperRight.y + offset.y,
    ),
    bottomLeft: Point(
      x: rectangle.bottomLeft.x + offset.x,
      y: rectangle.bottomLeft.y + offset.y,
    ),
    bottomRight: Point(
      x: rectangle.bottomRight.x + offset.x,
      y: rectangle.bottomRight.y + offset.y,
    ),
  );

  @override
  String toString() {
    return 'OcrBoundingBox(upperLeft: Point(x:${rectangle.upperLeft.x}, y:${rectangle.upperLeft.y}), upperRight: Point(x:${rectangle.upperRight.x}, y:${rectangle.upperRight.y}), bottomLeft: Point(x:${rectangle.bottomLeft.x}, y:${rectangle.bottomLeft.y}), bottomRight: Point(x:${rectangle.bottomRight.x}, y:${rectangle.bottomRight.y}))';
  }
}
