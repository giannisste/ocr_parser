extension WeekEdgeDatesExtension on DateTime {
  DateTime get weekFirstDay => subtract(Duration(days: weekday - 1));
  DateTime get weekLastDay => add(Duration(days: DateTime.daysPerWeek - weekday));  
}

extension MonthEdgeDatesExtension on DateTime {
  DateTime get monthFirstDay => DateTime(year, month);
  DateTime get monthLastDay => DateTime(year, month + 1, 0);  
}
