import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt the user to enable location services
      return null;
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If permission is still denied, return null
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // If permission is denied forever, return null
      return null;
    }

    // Get current location if permission is granted
    LocationSettings locationSettings =
        const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100);
    return await Geolocator.getCurrentPosition(locationSettings: locationSettings);
  }
}
