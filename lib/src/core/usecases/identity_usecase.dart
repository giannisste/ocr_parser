import 'usecase.dart';

/// A usecase that just forwards the event to the result.
class IdentityUsecase<E> implements Usecase<E, E> {
  @override
  Future<E> execute(E event) => Future.value(event);
}
