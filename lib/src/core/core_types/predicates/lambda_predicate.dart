import 'predicate.dart';

class LambdaPredicate<T> implements Predicate<T> {
  const LambdaPredicate(this.predicate);

  final bool Function(T data) predicate;
  @override
  bool check(T data) => predicate(data);
}
