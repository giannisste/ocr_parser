import '../../setters/setter.dart';

class Point<T> {
  const Point({required this.x, required this.y});

  final T x;
  final T y;
}

class PointSetter<T> implements Setter<Point<T>, Point<T>> {
  const PointSetter(this.adder);

  final Setter<T, T> adder;

  @override
  Point<T> set(Point<T> state, Point<T> newValue) => Point(
        x: adder.set(state.x, newValue.x),
        y: adder.set(state.y, newValue.y),
      );
}
