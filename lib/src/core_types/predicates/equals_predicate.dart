import '../tuple/pair.dart';
import 'predicate.dart';

class EqualsPredicate<T> implements Predicate<Pair<T>> {
  @override
  bool check(Pair<T> data) => data.$1 == data.$2;
}
