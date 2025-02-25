import 'package:ocr_parser/src/core/core_types/either/distribute_extension.dart';

import '../core_types/either/either.dart';
import 'usecase.dart';

class DistributeUsecase<T, E1, E2, E3> implements Usecase<T, (Either<E1, E2>, E3)> {
  const DistributeUsecase({required this.leftUsecase, required this.rightUsecase});

  final Usecase<T, (E1, E3)> leftUsecase;
  final Usecase<T, (E2, E3)> rightUsecase;

  @override
  Future<T> execute((Either<E1, E2>, E3) event) =>
      event.distribute.fold(leftUsecase.execute, rightUsecase.execute);
}
