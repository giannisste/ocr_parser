
import '../core_types/either/either.dart';
import 'usecase.dart';

/// A usecase that executes [leftUsecase] or [rightUsecase] based on the [condition].
class ConditionalUsecase<T1, T2, Event, E1, E2> implements Usecase<Either<T1, T2>, Event> {
  ConditionalUsecase({
    required this.leftUsecase,
    required this.rightUsecase,
    required this.condition,
  });

  final Usecase<T1, E1> leftUsecase;
  final Usecase<T2, E2> rightUsecase;

  final Either<E1, E2> Function(Event) condition;

  @override
  Future<Either<T1, T2>> execute(Event event) {
    return condition(event).asyncFold(
      (left) async => Either.left(await leftUsecase.execute(left)),
      (right) async => Either.right(await rightUsecase.execute(right)),
    );
  }
}
