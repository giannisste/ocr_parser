import '../predicate.dart';

class IsInPastPredicate implements Predicate<DateTime> {
  @override
  bool check(DateTime data) => data.compareTo(DateTime.now()) < 0;
}

class DateTimeEqualsPredicate implements Predicate<DateTime> {
  const DateTimeEqualsPredicate(this.dateTime);

  final DateTime dateTime;
  
  @override
  bool check(DateTime data) =>
      data.year == dateTime.year && data.month == dateTime.month && data.day == dateTime.day;
}
