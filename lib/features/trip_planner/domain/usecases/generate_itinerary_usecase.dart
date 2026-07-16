import '../entities/trip_itinerary.dart';
import '../repositories/trip_repository.dart';

class GenerateItineraryUseCase {
  final TripRepository repository;

  GenerateItineraryUseCase(this.repository);

  Future<List<TripItinerary>> call({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  }) async {
    if (numDays <= 0 || numDays > 14) {
      throw ArgumentError(
        'Trips must be between 1 and 14 days to ensure high quality AI plans.',
      );
    }
    if (destination.trim().isEmpty) {
      throw ArgumentError('Destination cannot be empty.');
    }

    return await repository.generateItinerary(
      destination: destination,
      numDays: numDays,
      interests: interests,
      budgetLevel: budgetLevel,
    );
  }
}
