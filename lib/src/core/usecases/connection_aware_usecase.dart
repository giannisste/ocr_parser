import '../core_types/either/either.dart';
import '../mappers/lambda_mapper.dart';
import 'constant_event_usecase.dart';
import 'distribute_usecase.dart';
import 'fuse_usecase.dart';
import 'map_usecase.dart';
import 'usecase.dart';

class ConnectionAwareUsecase<T, E> implements Usecase<T, E> {
  ConnectionAwareUsecase({
    required this.connectivityUsecase,
    required this.onlineUsecase,
    required this.offlineUsecase,
  }) : _innerUsecase = FuseUsecase(
          firstUsecase: ConstantEventUsecase(connectivityUsecase, ()),
          secondUsecase: DistributeUsecase(
            leftUsecase: PreMapUsecase(usecase: onlineUsecase, mapper: LambdaMapper((((), E) t) => t.$2)),
            rightUsecase: PreMapUsecase(usecase: offlineUsecase, mapper: LambdaMapper((((), E) t) => t.$2)),
          ),
        );

  final Usecase<Either<(), ()>, ()> connectivityUsecase;
  final Usecase<T, E> onlineUsecase;
  final Usecase<T, E> offlineUsecase;

  final Usecase<T, E> _innerUsecase;

  @override
  Future<T> execute(E event) => _innerUsecase.execute(event);
}
