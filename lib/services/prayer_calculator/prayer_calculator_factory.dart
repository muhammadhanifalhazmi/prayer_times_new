import 'prayer_calculator.dart';
import 'adhan_prayer_calculator.dart';

class PrayerCalculatorFactory {
  static PrayerCalculator createCalculator(String type) {
    switch (type) {
      case 'adhan':
        return AdhanPrayerCalculator();
      default:
        return AdhanPrayerCalculator();
    }
  }
}