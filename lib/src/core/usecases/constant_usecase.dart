import 'usecase.dart';

/// A usecase that returns always a constant value
class ConstantUsecase<R, Event> implements Usecase<R, Event> {
  ConstantUsecase(this.constantTerm);

  final R constantTerm;

  @override
  Future<R> execute(Event event) => Future.value(constantTerm);
}

class DelayedUsecase<R, Event> implements Usecase<R, Event> {
  DelayedUsecase({required this.usecase, required this.delay});

  final Usecase<R, Event> usecase;
  final Duration delay;

  @override
  Future<R> execute(Event event) => Future.delayed(delay, () => usecase.execute(event));
}
