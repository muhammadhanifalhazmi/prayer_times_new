import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static final LocationService _instance = LocationService._();
  factory LocationService() => _instance;

  Future<Map<String, double>> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}
