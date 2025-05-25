// adhan_prayer_calculator.dart
import 'package:adhan/adhan.dart' as adhan;
import '../../models/prayer_time.dart';
import 'prayer_calculator.dart';

class AdhanPrayerCalculator implements PrayerCalculator {
  @override
  Future<PrayerTimes> calculatePrayerTimes(double latitude, double longitude, DateTime date) async {
    final coordinates = adhan.Coordinates(latitude, longitude);
    final params = adhan.CalculationMethod.muslim_world_league.getParameters();
    params.madhab = adhan.Madhab.shafi;

    final dateComponents = adhan.DateComponents.from(date); 
    final prayerTimes = adhan.PrayerTimes(coordinates, dateComponents, params);

    return PrayerTimes(date: date, times: [
      PrayerTime(name: 'Fajr', time: prayerTimes.fajr),
      PrayerTime(name: 'Sunrise', time: prayerTimes.sunrise),
      PrayerTime(name: 'Dhuhr', time: prayerTimes.dhuhr),
      PrayerTime(name: 'Asr', time: prayerTimes.asr),
      PrayerTime(name: 'Maghrib', time: prayerTimes.maghrib),
      PrayerTime(name: 'Isha', time: prayerTimes.isha),
    ]);
  }
}
