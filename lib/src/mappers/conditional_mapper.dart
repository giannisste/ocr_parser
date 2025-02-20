import '../core_types/either/either.dart';
import 'mapper.dart';

class ConditionalMapper<F, T1, T2> implements Mapper<F, Either<T1, T2>> {
  const ConditionalMapper(this._firstMapper, this._secondMapper, this.condition);

  final Mapper<F, T1> _firstMapper;
  final Mapper<F, T2> _secondMapper;
  final bool Function(F) condition;

  @override
  Either<T1, T2> map(F data) =>
      condition(data) ? Either.left(_firstMapper.map(data)) : Either.right(_secondMapper.map(data));
}
