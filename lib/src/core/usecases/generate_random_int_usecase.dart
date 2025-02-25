import 'dart:math' as math;

import 'usecase.dart';

class GenerateRandomIntUsecase implements Usecase<int, ()> {
  const GenerateRandomIntUsecase(this.randomGenerator, this.upperBound);

  final math.Random randomGenerator;
  final int upperBound;

  @override
  Future<int> execute(() event) => Future.value(randomGenerator.nextInt(upperBound));
}
