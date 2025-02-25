import 'predicate.dart';

class FalsePredicate<T> implements Predicate<T> {
  const FalsePredicate();

  @override
  bool check(T data) => false;
}
