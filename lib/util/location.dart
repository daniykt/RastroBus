import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

LocationSettings getLocationSettings() {
  const distanceFilter = 10;

  if (defaultTargetPlatform == TargetPlatform.android) {
    return AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 10),
    );
  }

  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    return AppleSettings(
      accuracy: LocationAccuracy.high,
      activityType: ActivityType.fitness,
      distanceFilter: distanceFilter,
      pauseLocationUpdatesAutomatically: true,
      // Only set to true if our app will be started up in the background.
      showBackgroundLocationIndicator: false,
    );
  }

  if (kIsWeb) {
    return WebSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
      maximumAge: const Duration(seconds: 1),
    );
  }

  return const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: distanceFilter,
  );
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Serviço de geolocalização está desabilido.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Não foi autorizado o uso de gelocalização');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'O serviço de geolocalização está negado e não podemos perguntar novamente.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
    locationSettings: getLocationSettings(),
  );
}
