import 'predicate.dart';

class IsLowercasePredicate implements Predicate<String> {
  @override
  bool check(String data) => data == data.toLowerCase();
}
