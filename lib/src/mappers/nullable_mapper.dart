import '../extensions/nullable_map_extension.dart';
import 'mapper.dart';

class NullableMapper<F, T> implements Mapper<F?, T?> {
  const NullableMapper(this._innerMapper);

  final Mapper<F, T> _innerMapper;

  @override
  T? map(F? dataModel) => dataModel.foldNull(_innerMapper.map);
}
