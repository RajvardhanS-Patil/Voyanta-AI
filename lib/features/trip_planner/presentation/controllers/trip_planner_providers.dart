import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/trip_planner/data/datasources/gemini_remote_datasource.dart'; // Kept for TripRemoteDataSource
import 'package:voyanta_ai/features/trip_planner/data/datasources/groq_remote_datasource.dart';
import 'package:voyanta_ai/features/trip_planner/data/repositories/trip_repository_impl.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/repositories/trip_repository.dart';
import 'package:voyanta_ai/features/trip_planner/domain/usecases/generate_itinerary_usecase.dart';

final tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  return GroqRemoteDataSource();
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final remoteDataSource = ref.watch(tripRemoteDataSourceProvider);
  return TripRepositoryImpl(remoteDataSource);
});

final generateItineraryUseCaseProvider = Provider<GenerateItineraryUseCase>((
  ref,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return GenerateItineraryUseCase(repository);
});

/// Tracks loading/error state for trip generation
class TripPlannerStateNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  void setLoading() => state = const AsyncValue.loading();
  void setData() => state = const AsyncValue.data(null);
  void setError(Object error, StackTrace st) =>
      state = AsyncValue.error(error, st);
}

final tripPlannerStateProvider =
    NotifierProvider<TripPlannerStateNotifier, AsyncValue<void>>(() {
      return TripPlannerStateNotifier();
    });

/// Stores the full multi-day AI-generated itinerary.
/// The Planner screen displays this, and the AI companion can mutate it.
class GeneratedItinerariesNotifier extends Notifier<List<TripItinerary>> {
  @override
  List<TripItinerary> build() => [];

  void setItineraries(List<TripItinerary> itineraries) {
    state = itineraries;
  }

  void clear() {
    state = [];
  }

  void addActivityToDay(int dayNumber, dynamic activity) {
    // Used by the AI companion to push new activities
    state = state.map((itin) {
      if (itin.dayNumber == dayNumber) {
        return TripItinerary(
          dayNumber: itin.dayNumber,
          theme: itin.theme,
          activities: [...itin.activities, activity],
        );
      }
      return itin;
    }).toList();
  }
}

final generatedItinerariesProvider =
    NotifierProvider<GeneratedItinerariesNotifier, List<TripItinerary>>(() {
      return GeneratedItinerariesNotifier();
    });
