
import 'usecase.dart';

/// A usecase that always executes [usecase] with [event] ignoring outer event.
class ConstantEventUsecase<R, IE, OE> implements Usecase<R, OE> {
  ConstantEventUsecase(this.usecase, this.event);

  final Usecase<R, IE> usecase;
  final IE event;

  @override
  Future<R> execute(OE event) => usecase.execute(this.event);
}
