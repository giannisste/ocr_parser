import 'predicate.dart';

class AndPredicate<T1, T2> implements Predicate<(T1, T2)> {
  const AndPredicate({required this.firstPredicate, required this.secondPredicate});

  final Predicate<T1> firstPredicate;
  final Predicate<T2> secondPredicate;

  @override
  bool check((T1, T2) data) => firstPredicate.check(data.$1) && secondPredicate.check(data.$2);
}

class EitherPredicate<T1, T2> implements Predicate<(T1, T2)> {
  const EitherPredicate({required this.firstPredicate, required this.secondPredicate});

  final Predicate<T1> firstPredicate;
  final Predicate<T2> secondPredicate;

  @override
  bool check((T1, T2) data) => firstPredicate.check(data.$1) || secondPredicate.check(data.$2);
}

class OrPredicate<T> implements Predicate<T> {
  const OrPredicate({required this.firstPredicate, required this.secondPredicate});

  final Predicate<T> firstPredicate;
  final Predicate<T> secondPredicate;

  @override
  bool check(T data) => firstPredicate.check(data) || secondPredicate.check(data);
}

class BothPredicate<T> implements Predicate<T> {
  const BothPredicate({required this.firstPredicate, required this.secondPredicate});

  final Predicate<T> firstPredicate;
  final Predicate<T> secondPredicate;

  @override
  bool check(T data) => firstPredicate.check(data) && secondPredicate.check(data);
}

class ExclusiveOrPredicate<T1, T2> implements Predicate<(T1, T2)> {
  const ExclusiveOrPredicate({required this.firstPredicate, required this.secondPredicate});

  final Predicate<T1> firstPredicate;
  final Predicate<T2> secondPredicate;

  @override
  bool check((T1, T2) data) => firstPredicate.check(data.$1) ^ secondPredicate.check(data.$2);
}
