import '../../models/prayer_time.dart';

abstract class PrayerCalculator {
  Future<PrayerTimes> calculatePrayerTimes(double latitude, double longitude, DateTime date);
}