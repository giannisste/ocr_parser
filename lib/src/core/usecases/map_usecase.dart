import '../mappers/mapper.dart';
import 'usecase.dart';

class PostMapUsecase<RI, RF, E> implements Usecase<RF, E> {
  PostMapUsecase({
    required this.usecase,
    required this.mapper,
  });

  final Usecase<RI, E> usecase;
  final Mapper<RI, RF> mapper;

  @override
  Future<RF> execute(E event) => usecase.execute(event).then(mapper.map);
}

class PreMapUsecase<R, EI, EF> implements Usecase<R, EI> {
  PreMapUsecase({
    required this.usecase,
    required this.mapper,
  });

  final Usecase<R, EF> usecase;
  final Mapper<EI, EF> mapper;

  @override
  Future<R> execute(EI event) => usecase.execute(mapper.map(event));
}

class WrapUsecase<RI, EI, RF, EF> implements Usecase<RF, EI> {
  const WrapUsecase({
    required this.usecase,
    required this.preMapper,
    required this.postMapper,
  });

  final Usecase<RI, EF> usecase;
  final Mapper<EI, EF> preMapper;
  final Mapper<RI, RF> postMapper;

  @override
  Future<RF> execute(EI event) => usecase.execute(preMapper.map(event)).then(postMapper.map);
}
