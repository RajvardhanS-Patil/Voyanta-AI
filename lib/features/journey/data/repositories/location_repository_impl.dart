import 'package:geolocator/geolocator.dart';
import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<bool> requestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // User disabled location services at OS level
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // Must direct user to OS settings
    }

    return true;
  }

  @override
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter:
            10, // Optimize battery by emitting only after 10m movement
      ),
    );
  }

  @override
  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }
}
