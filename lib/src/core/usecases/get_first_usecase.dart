import 'usecase.dart';

class GetFirstUsecase<T1, T2> implements Usecase<T1, (T1, T2)> {
  const GetFirstUsecase();

  @override
  Future<T1> execute((T1, T2) event) => Future.value(event.$1);
}

class GetSecondUsecase<T1, T2> implements Usecase<T2, (T1, T2)> {
  const GetSecondUsecase();

  @override
  Future<T2> execute((T1, T2) event) => Future.value(event.$2);
}
