import '../tuple/pair.dart';
import 'predicate.dart';

class BetweenPredicate<T> implements Predicate<int> {
  const BetweenPredicate({required this.range});

  final Pair<int> range;

  @override
  bool check(int data) => data >= range.$1 && data <= range.$2;
}

class GreaterThanPredicate implements Predicate<int> {
  GreaterThanPredicate({required this.lowerLimit});

  final int lowerLimit;
  @override
  bool check(int data) => data > lowerLimit;
}



class GreaterThanOrEqualPredicate implements Predicate<int> {
  GreaterThanOrEqualPredicate({required this.lowerLimit});

  final int lowerLimit;
  
  @override
  bool check(int data) => data >= lowerLimit;
}


class LessThanPredicate implements Predicate<int> {
  LessThanPredicate({required this.upperLimit});

  final int upperLimit;
  @override
  bool check(int data) => data < upperLimit;
}


class LessThanOrEqualPredicate implements Predicate<int> {
  LessThanOrEqualPredicate({required this.upperLimit});

  final int upperLimit;
  @override
  bool check(int data) => data <= upperLimit;
}
