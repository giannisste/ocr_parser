import '../core_types/either/either.dart';
import 'mapper.dart';

class EitherMapper<F1, F2, T> implements Mapper<Either<F1, F2>, T> {
  const EitherMapper(this._firstMapper, this._secondMapper);

  final Mapper<F1, T> _firstMapper;
  final Mapper<F2, T> _secondMapper;

  @override
  T map(Either<F1, F2> data) => data.fold(_firstMapper.map, _secondMapper.map);
}

class Either3Mapper<F1, F2, F3, T> implements Mapper<Either3<F1, F2, F3>, T> {
  const Either3Mapper(this._firstMapper, this._secondMapper, this._thirdMapper);

  final Mapper<F1, T> _firstMapper;
  final Mapper<F2, T> _secondMapper;
  final Mapper<F3, T> _thirdMapper;

  @override
  T map(Either3<F1, F2, F3> data) =>
      data.fold(_firstMapper.map, _secondMapper.map, _thirdMapper.map);
}

class Either4Mapper<F1, F2, F3, F4, T> implements Mapper<Either4<F1, F2, F3, F4>, T> {
  const Either4Mapper(this._firstMapper, this._secondMapper, this._thirdMapper, this._fourthMapper);

  final Mapper<F1, T> _firstMapper;
  final Mapper<F2, T> _secondMapper;
  final Mapper<F3, T> _thirdMapper;
  final Mapper<F4, T> _fourthMapper;

  @override
  T map(Either4<F1, F2, F3, F4> data) =>
      data.fold(_firstMapper.map, _secondMapper.map, _thirdMapper.map, _fourthMapper.map);
}
