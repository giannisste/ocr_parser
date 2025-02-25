import 'usecase.dart';

class ComposeUsecase<T1, E1, T2> implements Usecase<T2, E1> {
  const ComposeUsecase({
    required this.firstUsecase,
    required this.secondUsecase,
  });

  final Usecase<T1, E1> firstUsecase;
  final Usecase<T2, T1> secondUsecase;

  @override
  Future<T2> execute(E1 event) {
    return firstUsecase.execute(event).then(secondUsecase.execute);
  }
}
