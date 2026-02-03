int? valentineDayForDate(DateTime date) {
  if (date.month != 2) return null;
  final d = date.day;
  if (d >= 7 && d <= 13) return d; // Rose..Kiss
  if (d == 14) return 14; // Valentine
  return null;
}

bool isBeforeDay(int day, DateTime now) {
  final target = DateTime(now.year, 2, day);
  return now.isBefore(target);
}
