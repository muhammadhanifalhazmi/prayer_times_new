class PrayerTime {
  final String name;
  final DateTime time;

  PrayerTime({required this.name, required this.time});
}

class PrayerTimes {
  final DateTime date;
  final List<PrayerTime> times;

  PrayerTimes({required this.date, required this.times});
}
