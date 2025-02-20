import '../point/point.dart';

class Rectangle<T> {
  const Rectangle({
    required this.upperLeft,
    required this.upperRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  final Point<T> upperLeft;
  final Point<T> upperRight;
  final Point<T> bottomLeft;
  final Point<T> bottomRight;
}
