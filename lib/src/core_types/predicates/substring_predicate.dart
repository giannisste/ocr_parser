import 'predicate.dart';

class SubstringPredicate implements Predicate<String> {
  const SubstringPredicate({required this.substring});

  final String substring;
  @override
  bool check(String data) => data.contains(substring);
}
