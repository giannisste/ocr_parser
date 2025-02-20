import 'predicate.dart';

class StartsWithPredicate implements Predicate<String> {
  const StartsWithPredicate({required this.start});

  final String start;

  @override
  bool check(String data) => data.startsWith(start);
}

class EndsWithPredicate implements Predicate<String> {
  const EndsWithPredicate({required this.end});

  final String end;
  
  @override
  bool check(String data) => data.endsWith(end);
}
