import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/journey_progress_db.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/data/models/trip_itinerary_model.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/journey/domain/repositories/location_repository.dart';
import 'package:voyanta_ai/features/journey/domain/usecases/calculate_eta_usecase.dart';
import 'package:voyanta_ai/core/observability/observability_service.dart';
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

    _restoreJourneyProgress();

    return const JourneyState();
  }

  Future<void> _restoreJourneyProgress() async {
    try {
      final progress = await IsarService.isar.journeyProgressDbs.where().findFirst();
      if (progress != null && progress.activeItineraryJson != null) {
        final itineraryMap = jsonDecode(progress.activeItineraryJson!) as Map<String, dynamic>;
        final itinerary = TripItineraryModel.fromJson(itineraryMap);
        
        final statusVal = JourneyStatus.values.firstWhere(
          (s) => s.name == progress.status,
          orElse: () => JourneyStatus.idle,
        );

        if (statusVal == JourneyStatus.completed || statusVal == JourneyStatus.idle) {
          return;
        }

        state = JourneyState(
          activeItinerary: itinerary,
          currentActivityIndex: progress.currentActivityIndex,
          currentLatitude: progress.currentLatitude,
          currentLongitude: progress.currentLongitude,
          status: statusVal,
        );

        _positionSubscription?.cancel();
        _positionSubscription = _locationRepo.getLocationStream().listen((position) {
          _updateStateWithPosition(position);
        });
      }
    } catch (_) {}
  }

  Map<String, dynamic> _itineraryToJson(TripItinerary itinerary) {
    return {
      'dayNumber': itinerary.dayNumber,
      'theme': itinerary.theme,
      'activities': itinerary.activities.map((a) => {
        'time': a.time,
        'title': a.title,
        'description': a.description,
        'latitude': a.latitude,
        'longitude': a.longitude,
      }).toList(),
    };
  }

  Future<void> _saveProgress() async {
    final itinerary = state.activeItinerary;
    if (itinerary == null) return;

    final db = JourneyProgressDb()
      ..tripId = itinerary.dayNumber.toString()
      ..currentActivityIndex = state.currentActivityIndex
      ..currentLatitude = state.currentLatitude
      ..currentLongitude = state.currentLongitude
      ..status = state.status.name
      ..lastUpdated = DateTime.now()
      ..activeItineraryJson = jsonEncode(_itineraryToJson(itinerary));

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.journeyProgressDbs.put(db);
    });
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

    ObservabilityService.trackEvent('journey_started', {
      'dayNumber': itinerary.dayNumber,
      'totalActivities': itinerary.activities.length,
    });

    final lastKnown = await _locationRepo.getLastKnownPosition();
    if (lastKnown != null) {
      _updateStateWithPosition(lastKnown);
    }

    _positionSubscription?.cancel();
    _positionSubscription = _locationRepo.getLocationStream().listen((position) {
      _updateStateWithPosition(position);
    });

    await _saveProgress();
  }

  void _updateStateWithPosition(Position pos) {
    final itinerary = state.activeItinerary;
    final index = state.currentActivityIndex;

    if (itinerary == null || index >= itinerary.activities.length) {
      state = state.copyWith(status: JourneyStatus.completed);
      _positionSubscription?.cancel();
      _saveProgress();
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

    _saveProgress();
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

    _saveProgress();
  }

  Future<void> endJourney() async {
    _positionSubscription?.cancel();
    state = const JourneyState();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.journeyProgressDbs.clear();
    });
  }
}

final journeyControllerProvider =
    NotifierProvider<JourneyController, JourneyState>(() {
      return JourneyController();
    });
