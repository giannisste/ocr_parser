import 'predicate.dart';

class PositivePredicate implements Predicate<int> {
  @override
  bool check(int data) => data > 0;
}

class NotPositivePredicate implements Predicate<int> {
  @override
  bool check(int data) => data <= 0;
}

class NegativePredicate implements Predicate<int> {
  @override
  bool check(int data) => data < 0;
}

class NotNegativePredicate implements Predicate<int> {
  @override
  bool check(int data) => data >= 0;
}

class ZeroPredicate implements Predicate<int> {
  @override
  bool check(int data) => data == 0;
}
