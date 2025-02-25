import '../tuple/pair.dart';
import 'predicate.dart';

class PairAndPredicate<T> implements Predicate<Pair<T>> {
  const PairAndPredicate(this.innerPredicate);

  final Predicate<T> innerPredicate;

  @override
  bool check(Pair<T> data) => innerPredicate.check(data.$1) && innerPredicate.check(data.$2);
}
