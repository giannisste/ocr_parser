import 'mapper.dart';

class ConstantMapper<From, To> implements Mapper<From, To> {
  const ConstantMapper(this.value);

  final To value;

  @override
  To map(From dataModel) => value;
}
