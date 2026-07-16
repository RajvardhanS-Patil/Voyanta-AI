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
  TripItinerary? _activeItinerary;
  int _currentActivityIndex = 0;

  @override
  JourneyState build() {
    _locationRepo = ref.read(locationRepositoryProvider);
    _calculateEta = ref.read(calculateEtaUseCaseProvider);

    // Dispose the subscription when the notifier is destroyed
    ref.onDispose(() {
      _positionSubscription?.cancel();
    });

    return const JourneyState();
  }

  Future<void> startJourney(TripItinerary itinerary) async {
    _activeItinerary = itinerary;
    _currentActivityIndex = 0;

    if (_activeItinerary!.activities.isEmpty) return;

    final hasPermission = await _locationRepo.requestPermissions();
    if (!hasPermission) {
      // Without location permissions, the live engine cannot function.
      return;
    }

    state = state.copyWith(status: JourneyStatus.navigating);

    // Bootstrap with the last known position to prevent initial blank states
    final lastKnown = await _locationRepo.getLastKnownPosition();
    if (lastKnown != null) {
      _updateStateWithPosition(lastKnown);
    }

    // Subscribe to continuous GPS updates (filtered every 10 meters)
    _positionSubscription?.cancel();
    _positionSubscription = _locationRepo.getLocationStream().listen((
      position,
    ) {
      _updateStateWithPosition(position);
    });
  }

  void _updateStateWithPosition(Position pos) {
    if (_activeItinerary == null ||
        _currentActivityIndex >= _activeItinerary!.activities.length) {
      state = state.copyWith(status: JourneyStatus.completed);
      _positionSubscription?.cancel();
      return;
    }

    final targetActivity = _activeItinerary!.activities[_currentActivityIndex];

    final distanceMeters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      targetActivity.latitude,
      targetActivity.longitude,
    );

    final eta = _calculateEta(distanceMeters: distanceMeters);

    // Core Geofencing Architecture: Trip triggers Arrival when within 150 meters
    JourneyStatus newStatus = JourneyStatus.navigating;
    if (distanceMeters <= 150) {
      newStatus = JourneyStatus.arrived;
    }

    state = state.copyWith(
      currentActivity: targetActivity,
      currentLatitude: pos.latitude,
      currentLongitude: pos.longitude,
      distanceToNextMeters: distanceMeters,
      etaMinutes: eta,
      status: newStatus,
    );
  }

  void advanceToNextActivity() {
    if (_activeItinerary == null) return;

    _currentActivityIndex++;
    if (_currentActivityIndex >= _activeItinerary!.activities.length) {
      state = state.copyWith(status: JourneyStatus.completed);
      _positionSubscription?.cancel();
    } else {
      // Revert status to navigating; the next GPS tick will recalibrate the state natively
      state = state.copyWith(status: JourneyStatus.navigating);
    }
  }
}

final journeyControllerProvider =
    NotifierProvider<JourneyController, JourneyState>(() {
      return JourneyController();
    });
