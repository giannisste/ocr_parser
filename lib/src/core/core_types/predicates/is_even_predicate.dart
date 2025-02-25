import 'predicate.dart';

class IsEvenPredicate implements Predicate<int> {
  @override
  bool check(int data) => data.isEven;
}
