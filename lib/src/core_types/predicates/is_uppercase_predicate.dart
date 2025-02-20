import 'predicate.dart';

class IsUppercasePredicate implements Predicate<String> {
  @override
  bool check(String data) => data == data.toUpperCase();
}
