import '../entities/trip_itinerary.dart';

abstract class TripRepository {
  /// Generates a structured multi-day itinerary using the AI model.
  Future<List<TripItinerary>> generateItinerary({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  });
}
