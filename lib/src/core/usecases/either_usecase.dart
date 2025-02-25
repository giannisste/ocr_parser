import '../core_types/either/either.dart';
import 'usecase.dart';

class EitherUsecase<T, E1, E2> implements Usecase<T, Either<E1, E2>> {
  const EitherUsecase({required this.leftUsecase, required this.rightUsecase});

  final Usecase<T, E1> leftUsecase;
  final Usecase<T, E2> rightUsecase;

  @override
  Future<T> execute(Either<E1, E2> event) => event.fold(leftUsecase.execute, rightUsecase.execute);
}
