import '../../setters/setter.dart';
import 'point.dart';

class PointSetter<T> implements Setter<Point<T>, Point<T>> {
  const PointSetter(this.setter);

  final Setter<T, T> setter;

  @override
  Point<T> set(Point<T> state, Point<T> newValue) => Point(
        x: setter.set(state.x, newValue.x),
        y: setter.set(state.y, newValue.y),
      );
}
