import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/prayer_time.dart';
import '../services/location_service.dart';
import '../services/prayer_calculator/prayer_calculator_factory.dart';

class PrayerTimeProvider extends ChangeNotifier {
  PrayerTimes? prayerTimes;
  bool isLoading = false;
  String? error;
  double latitude = 0.0;
  double longitude = 0.0;
  String regionName = 'Lokasi Anda';

  Future<void> loadPrayerTimes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final location = await LocationService().getCurrentLocation();
      latitude = location['latitude']!;
      longitude = location['longitude']!;

      // Reverse Geocoding untuk mendapatkan nama daerah
      try {
        final placemarks = await placemarkFromCoordinates(latitude, longitude);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          regionName = [
            placemark.locality,
            placemark.subLocality,
            placemark.administrativeArea,
          ].where((e) => e != null && e.isNotEmpty).join(', ');
          
          if (regionName.isEmpty) {
            regionName = 'Lokasi Anda';
          }
        }
      } catch (e) {
        regionName = 'Lokasi Anda';
      }

      final calculator = PrayerCalculatorFactory.createCalculator('adhan');
      prayerTimes = await calculator.calculatePrayerTimes(latitude, longitude, DateTime.now());
      
      // Update widget dengan data terbaru
      await _updateWidgetData();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  // Helper untuk mencari index sholat berikutnya
  int? _getNextPrayerIndex(List<PrayerTime> times) {
    final now = DateTime.now();
    for (int i = 0; i < times.length; i++) {
      if (times[i].time.isAfter(now) || times[i].time.isAtSameMomentAs(now)) {
        return i;
      }
    }
    return null;
  }

  // Simpan data untuk widget
  Future<void> _updateWidgetData() async {
    if (prayerTimes == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final nextPrayerIndex = _getNextPrayerIndex(prayerTimes!.times);
      
      if (nextPrayerIndex != null) {
        final nextPrayer = prayerTimes!.times[nextPrayerIndex];
        
        // ✅ Gunakan key yang sama dengan di Kotlin
        await prefs.setString('prayer_name', nextPrayer.name);
        await prefs.setString('prayer_time', DateFormat('HH:mm').format(nextPrayer.time));
        await prefs.setString('region_name', regionName);
        await prefs.setString('date', DateFormat('EEEE, d MMMM yyyy', 'id').format(DateTime.now()));
        
        debugPrint('✅ Widget data saved: ${nextPrayer.name} - ${DateFormat('HH:mm').format(nextPrayer.time)}');
      }
    } catch (e) {
      debugPrint('❌ Gagal update widget: $e');
    }
  }

  // Method untuk refresh widget
  Future<void> refreshWidget() async {
    await loadPrayerTimes();
  }
}