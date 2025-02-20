import 'mapper.dart';

class LambdaMapper<X, Y> implements Mapper<X, Y> {
  LambdaMapper(this._function);

  final Y Function(X) _function;
  
  @override
  Y map(X data) => _function(data);
}
