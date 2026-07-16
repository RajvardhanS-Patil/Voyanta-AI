import '../../domain/entities/trip_itinerary.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/gemini_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TripItinerary>> generateItinerary({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  }) async {
    return await remoteDataSource.generateItinerary(
      destination: destination,
      numDays: numDays,
      interests: interests,
      budgetLevel: budgetLevel,
    );
  }
}
