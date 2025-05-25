import 'package:flutter/material.dart';
import '../models/prayer_time.dart';
import '../services/location_service.dart';
import '../services/prayer_calculator/prayer_calculator_factory.dart';

class PrayerTimeProvider extends ChangeNotifier {
  PrayerTimes? prayerTimes;
  bool isLoading = false;
  String? error;
  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> loadPrayerTimes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final location = await LocationService().getCurrentLocation();
      latitude = location['latitude']!;
      longitude = location['longitude']!;

      final calculator = PrayerCalculatorFactory.createCalculator('adhan');
      prayerTimes = await calculator.calculatePrayerTimes(latitude, longitude, DateTime.now());
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}