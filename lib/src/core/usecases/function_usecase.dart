import '../mappers/mapper.dart';
import 'usecase.dart';

class FunctionUsecase<T, E> implements Usecase<T, E> {
  const FunctionUsecase(this.function);

  final T Function(E) function;

  @override
  Future<T> execute(E event) => Future.value(function(event));
}

class MapperUsecase<T, E> implements Usecase<T, E> {
  const MapperUsecase({required this.mapper});

  final Mapper<E, T> mapper;

  @override
  Future<T> execute(E event) => Future.value(mapper.map(event));
}
