class CalculateEtaUseCase {
  /// Calculates ETA in minutes based on distance.
  /// Uses a heuristic:
  /// - Under 2km: Assumes walking speed (~5 km/h = 83m/min).
  /// - Over 2km: Assumes city driving speed (~35 km/h = 583m/min).
  int call({required double distanceMeters}) {
    if (distanceMeters <= 0) return 0;

    if (distanceMeters < 2000) {
      return (distanceMeters / 83).ceil();
    } else {
      return (distanceMeters / 583).ceil();
    }
  }
}
