import 'predicate.dart';
import 'regex_predicate.dart';

class EmailPredicate implements Predicate<String> {
  const EmailPredicate();

  Predicate<String> get _innerPredicate => RegexPredicate(
        regex: RegExp(
          r"^(?!\.)[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+(?<!\.)@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$",
        ),
      );

  @override
  bool check(String data) => _innerPredicate.check(data);
}
