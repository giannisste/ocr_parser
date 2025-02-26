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

  // Helper function to get the bounds of the bounding box as a strict BoundingBoxBounds object
  BoundingBoxBounds getBounds() {
    final xs = [upperLeft.x, upperRight.x, bottomLeft.x, bottomRight.x];
    final ys = [upperLeft.y, upperRight.y, bottomLeft.y, bottomRight.y];

    return BoundingBoxBounds(
      Point(
        x: xs.reduce((a, b) => a < b ? a : b),
        y: ys.reduce((a, b) => a < b ? a : b),
      ),
      Point(
        x: xs.reduce((a, b) => a > b ? a : b),
        y: ys.reduce((a, b) => a > b ? a : b),
      ),
    );
  }

  // Check if this bounding box contains another bounding box horizontally
  bool horizontalContains(OcrBoundingBox other) {
    final thisBounds = getBounds();
    final otherBounds = other.getBounds();

    return thisBounds.minPoint.x <= otherBounds.minPoint.x &&
        thisBounds.maxPoint.x >= otherBounds.maxPoint.x;
  }

  // Check if this bounding box contains another bounding box vertically
  bool verticalContains(OcrBoundingBox other) {
    final thisBounds = getBounds();
    final otherBounds = other.getBounds();

    return thisBounds.minPoint.y <= otherBounds.minPoint.y &&
        thisBounds.maxPoint.y >= otherBounds.maxPoint.y;
  }

  // Check if this bounding box contains another bounding box (both horizontally and vertically)
  bool contains(OcrBoundingBox other) {
    return horizontalContains(other) && verticalContains(other);
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

OcrBoundingBox expandBoundingBox(double width, double height) {
  final dx = width / 2;
  final dy = height / 2;

  return OcrBoundingBox(
    upperLeft: Point(x: upperLeft.x - dx, y: upperLeft.y - dy),
    upperRight: Point(x: upperRight.x + dx, y: upperRight.y - dy),
    bottomLeft: Point(x: bottomLeft.x - dx, y: bottomLeft.y + dy),
    bottomRight: Point(x: bottomRight.x + dx, y: bottomRight.y + dy),
  );
}


  @override
  String toString() {
    return 'OcrBoundingBox(upperLeft: Point(x:${rectangle.upperLeft.x}, y:${rectangle.upperLeft.y}), upperRight: Point(x:${rectangle.upperRight.x}, y:${rectangle.upperRight.y}), bottomLeft: Point(x:${rectangle.bottomLeft.x}, y:${rectangle.bottomLeft.y}), bottomRight: Point(x:${rectangle.bottomRight.x}, y:${rectangle.bottomRight.y}))';
  }
}

// Define a strict class to represent the bounds of a bounding box
class BoundingBoxBounds {
  final Point<double> minPoint;
  final Point<double> maxPoint;

  BoundingBoxBounds(this.minPoint, this.maxPoint);
}

Point<double> mergeMinPoints(Point<double> point1, Point<double> point2) {
  final minX = point1.x < point2.x ? point1.x : point2.x;
  final minY = point1.y < point2.y ? point1.y : point2.y;
  return Point(x: minX, y: minY);
}

Point<double> mergeMaxPoints(Point<double> point1, Point<double> point2) {
  final maxX = point1.x > point2.x ? point1.x : point2.x;
  final maxY = point1.y > point2.y ? point1.y : point2.y;
  return Point(x: maxX, y: maxY);
}

OcrBoundingBox mergeBounds(OcrBoundingBox box1, OcrBoundingBox box2) {
  // Find the minimum and maximum of the four corner points between the two bounding boxes
  final minX =
      box1.upperLeft.x < box2.upperLeft.x ? box1.upperLeft.x : box2.upperLeft.x;
  final maxX =
      box1.upperRight.x > box2.upperRight.x
          ? box1.upperRight.x
          : box2.upperRight.x;
  final minY =
      box1.upperLeft.y < box2.upperLeft.y ? box1.upperLeft.y : box2.upperLeft.y;
  final maxY =
      box1.bottomLeft.y > box2.bottomLeft.y
          ? box1.bottomLeft.y
          : box2.bottomLeft.y;

  // Create and return a new OcrBoundingBox that contains both boxes
  return OcrBoundingBox(
    upperLeft: Point(x: minX, y: minY), // Upper Left
    upperRight: Point(x: maxX, y: minY), // Upper Right
    bottomLeft: Point(x: minX, y: maxY), // Bottom Left
    bottomRight: Point(x: maxX, y: maxY), // Bottom Right
  );
}
