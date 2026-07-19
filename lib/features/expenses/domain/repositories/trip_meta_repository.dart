import '../entities/trip_meta.dart';

abstract class TripMetaRepository {
  Future<TripMeta> getTripMeta();
  Future<void> saveTripMeta(TripMeta meta);
}
