import 'usecase.dart';

// A usecase that is S combinator in disguise
class FuseUsecase<R, R2, Event> implements Usecase<R2, Event> {
  const FuseUsecase({required this.firstUsecase, required this.secondUsecase});

  final Usecase<R, Event> firstUsecase;
  final Usecase<R2, (R, Event)> secondUsecase;

  @override
  Future<R2> execute(Event event) async {
    final result = await firstUsecase.execute(event);
    return secondUsecase.execute((result, event));
  }
}
