import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/journey/domain/repositories/location_repository.dart';
import 'package:voyanta_ai/features/journey/domain/usecases/calculate_eta_usecase.dart';
import 'journey_providers.dart';

class JourneyController extends Notifier<JourneyState> {
  StreamSubscription<Position>? _positionSubscription;
  late final LocationRepository _locationRepo;
  late final CalculateEtaUseCase _calculateEta;

  @override
  JourneyState build() {
    _locationRepo = ref.read(locationRepositoryProvider);
    _calculateEta = ref.read(calculateEtaUseCaseProvider);

    ref.onDispose(() {
      _positionSubscription?.cancel();
    });

    return const JourneyState();
  }

  Future<void> startJourney(TripItinerary itinerary) async {
    if (itinerary.activities.isEmpty) return;

    final hasPermission = await _locationRepo.requestPermissions();
    if (!hasPermission) {
      state = state.copyWith(
        status: JourneyStatus.idle,
        permissionDenied: true,
      );
      return;
    }

    state = JourneyState(
      activeItinerary: itinerary,
      currentActivityIndex: 0,
      status: JourneyStatus.navigating,
      permissionDenied: false,
    );

    final lastKnown = await _locationRepo.getLastKnownPosition();
    if (lastKnown != null) {
      _updateStateWithPosition(lastKnown);
    }

    _positionSubscription?.cancel();
    _positionSubscription = _locationRepo.getLocationStream().listen((position) {
      _updateStateWithPosition(position);
    });
  }

  void _updateStateWithPosition(Position pos) {
    final itinerary = state.activeItinerary;
    final index = state.currentActivityIndex;

    if (itinerary == null || index >= itinerary.activities.length) {
      state = state.copyWith(status: JourneyStatus.completed);
      _positionSubscription?.cancel();
      return;
    }

    final targetActivity = itinerary.activities[index];

    final distanceMeters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      targetActivity.latitude,
      targetActivity.longitude,
    );

    final eta = _calculateEta(distanceMeters: distanceMeters);

    JourneyStatus newStatus = JourneyStatus.navigating;
    if (distanceMeters <= 150) {
      newStatus = JourneyStatus.arrived;
    }

    state = state.copyWith(
      currentLatitude: pos.latitude,
      currentLongitude: pos.longitude,
      distanceToNextMeters: distanceMeters,
      etaMinutes: eta,
      status: newStatus,
    );
  }

  void advanceToNextActivity() {
    final itinerary = state.activeItinerary;
    if (itinerary == null) return;

    final nextIndex = state.currentActivityIndex + 1;
    if (nextIndex >= itinerary.activities.length) {
      state = state.copyWith(
        currentActivityIndex: nextIndex,
        status: JourneyStatus.completed,
      );
      _positionSubscription?.cancel();
    } else {
      state = state.copyWith(
        currentActivityIndex: nextIndex,
        status: JourneyStatus.navigating,
      );
    }
  }

  void endJourney() {
    _positionSubscription?.cancel();
    state = const JourneyState();
  }
}

final journeyControllerProvider =
    NotifierProvider<JourneyController, JourneyState>(() {
      return JourneyController();
    });
