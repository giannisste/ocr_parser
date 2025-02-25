import '../core_types/either/either.dart';
import 'usecase.dart';

class FoldUsecase<T, E, T1, T2> implements Usecase<Either<T1, T2>, E> {
  const FoldUsecase({required this.usecase, required this.fold});

  final Usecase<T, E> usecase;
  final Either<T1, T2> Function(T) fold;

  @override
  Future<Either<T1, T2>> execute(E event) async {
    final result = await usecase.execute(event);
    return fold(result);
  }
}
