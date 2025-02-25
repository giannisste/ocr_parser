import 'predicate.dart';

class NotPredicate<T> implements Predicate<T> {
  const NotPredicate(this.innerPredicate);

  final Predicate<T> innerPredicate;

  @override
  bool check(T data) => !innerPredicate.check(data);
}
