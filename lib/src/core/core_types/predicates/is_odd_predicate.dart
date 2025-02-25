import 'predicate.dart';

class IsOddPredicate implements Predicate<int> {
  @override
  bool check(int data) => data.isOdd;
}
