import '../predicate.dart';

class IsValidDatePredicate implements Predicate<String> {
  @override
  bool check(String date) {
    RegExp dateRegExp = RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');
    if (!dateRegExp.hasMatch(date)) return false;

    try {
      List<int> parts = date.split('/').map(int.parse).toList();
      DateTime parsed = DateTime(parts[2], parts[1], parts[0]);
      return parsed.day == parts[0] && parsed.month == parts[1] && parsed.year == parts[2];
    } catch (e) {
      return false;
    }
  }
}
