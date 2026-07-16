import 'package:geolocator/geolocator.dart';

abstract class LocationRepository {
  /// Requests necessary OS-level location permissions.
  Future<bool> requestPermissions();

  /// Subscribes to a stream of GPS location updates.
  Stream<Position> getLocationStream();

  /// Fetches the last known location for rapid offline bootstrapping.
  Future<Position?> getLastKnownPosition();
}
