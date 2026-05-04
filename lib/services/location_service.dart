import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Request location permission
  static Future<LocationPermission> requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return await Geolocator.requestPermission();
    }
    return permission;
  }

  /// Check current location permission status
  static Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Get current location
  static Future<Position?> getCurrentLocation() async {
    try {
      final permission = await checkLocationPermission();

      if (permission == LocationPermission.denied) {
        return null;
      }

      if (permission == LocationPermission.deniedForever) {
        // Open app settings
        await Geolocator.openLocationSettings();
        return null;
      }

      if (!await isLocationServiceEnabled()) {
        await Geolocator.openLocationSettings();
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Get permission status description
  static String getPermissionStatusDescription(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission denied';
      case LocationPermission.deniedForever:
        return 'Location permission denied forever';
      case LocationPermission.whileInUse:
        return 'Location permission granted while in use';
      case LocationPermission.always:
        return 'Location permission always granted';
      case LocationPermission.unableToDetermine:
        return 'Unable to determine location permission';
    }
  }
}
