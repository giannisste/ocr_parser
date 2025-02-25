import 'predicate.dart';

class DivisibleByPredicate implements Predicate<int> {
  const DivisibleByPredicate(this.base);

  final int base;
  @override
  bool check(int data) => data % base == 0;
}
