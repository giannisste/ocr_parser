import '../core_types/tuple/record_map_extension.dart';
import 'mapper.dart';

class TupleMapper<F1, F2, T1, T2> implements Mapper<(F1, F2), (T1, T2)> {
  const TupleMapper(this._firstMapper, this._secondMapper);

  final Mapper<F1, T1> _firstMapper;
  final Mapper<F2, T2> _secondMapper;

  @override
  (T1, T2) map((F1, F2) dataModel) => dataModel.map(_firstMapper.map, _secondMapper.map);
}
