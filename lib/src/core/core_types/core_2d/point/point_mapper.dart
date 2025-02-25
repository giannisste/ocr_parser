import '../../../mappers/mapper.dart';
import '../../setters/setter.dart';
import 'point.dart';

class CoordinateAdder<T> implements Mapper<Point<T>, T> {
  const CoordinateAdder({required this.adder});

  final Setter<T, T> adder;

  @override
  T map(Point<T> dataModel) => adder.set(dataModel.x, dataModel.y);
}
