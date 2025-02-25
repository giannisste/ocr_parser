import 'predicate.dart';

class TruePredicate<T> implements Predicate<T> {
  const TruePredicate();

  @override
  bool check(T data) => true;
}
