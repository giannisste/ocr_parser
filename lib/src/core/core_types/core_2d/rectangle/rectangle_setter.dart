import '../../setters/setter.dart';
import '../point/point.dart';
import 'rectangle.dart';

class RectangleSetter<T> implements Setter<Rectangle<T>, Rectangle<T>> {
  const RectangleSetter(this.setter);

  final Setter<Point<T>, Point<T>> setter;

  @override
  Rectangle<T> set(Rectangle<T> state, Rectangle<T> newValue) => Rectangle(
        upperLeft: setter.set(state.upperLeft, newValue.upperLeft),
        upperRight: setter.set(state.upperRight, newValue.upperRight),
        bottomLeft: setter.set(state.bottomLeft, newValue.bottomLeft),
        bottomRight: setter.set(state.bottomRight, newValue.bottomRight),
      );
}
