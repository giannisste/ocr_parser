import '../core_types/either/either.dart';
import 'mapper.dart';

class CombinedMapper<T1, T2, U1, U2> implements Mapper<Either<T1, T2>, Either<U1, U2>> {
  CombinedMapper(this._mapper1, this._mapper2);

  final Mapper<T1, U1> _mapper1;
  final Mapper<T2, U2> _mapper2;

  @override
  Either<U1, U2> map(Either<T1, T2> data) {
    return data.map(_mapper1.map, _mapper2.map);
  }
}
