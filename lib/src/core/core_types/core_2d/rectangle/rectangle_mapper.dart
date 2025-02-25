import '../../../mappers/mapper.dart';
import '../../setters/setter.dart';
import '../point/point.dart';
import 'rectangle.dart';

class RectangleMidpointMapper<T> implements Mapper<Rectangle<T>, Point<T>> {
  const RectangleMidpointMapper({required this.midpointSetter});

  final Setter<Point<T>, Point<T>> midpointSetter;

  @override
  Point<T> map(Rectangle<T> dataModel) =>
      midpointSetter.set(dataModel.upperLeft, dataModel.bottomRight);
}
