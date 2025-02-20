import 'predicate.dart';

class RegexPredicate implements Predicate<String> {
  const RegexPredicate({required this.regex});

  final RegExp regex;

  @override
  bool check(String data) => regex.hasMatch(data);
}

class IsAlphaPredicate implements Predicate<String> {
  const IsAlphaPredicate();

  Predicate<String> get _innerPredicate => RegexPredicate(regex: RegExp(r'^[a-zA-Z]+$'));

  @override
  bool check(String data) => _innerPredicate.check(data);
}

class IsAlphaNumericPredicate implements Predicate<String> {
  const IsAlphaNumericPredicate();

  Predicate<String> get _innerPredicate => RegexPredicate(regex: RegExp(r'^[a-zA-Z0-9]+$'));

  @override
  bool check(String data) => _innerPredicate.check(data);
}

class IsNumericPredicate implements Predicate<String> {
  const IsNumericPredicate();
  
  Predicate<String> get _innerPredicate => RegexPredicate(regex: RegExp(r'^-?[0-9]+$'));

  @override
  bool check(String data) => _innerPredicate.check(data);
}
