import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';

enum JourneyStatus { idle, navigating, arrived, completed }

class JourneyState {
  final TripItinerary? activeItinerary;
  final int currentActivityIndex;
  final double currentLatitude;
  final double currentLongitude;
  final double distanceToNextMeters;
  final int etaMinutes;
  final JourneyStatus status;
  final bool permissionDenied;

  // Active status helper flags
  bool get hasActiveJourney =>
      status != JourneyStatus.idle && activeItinerary != null;

  Activity? get currentActivity {
    if (activeItinerary == null ||
        currentActivityIndex < 0 ||
        currentActivityIndex >= activeItinerary!.activities.length) {
      return null;
    }
    return activeItinerary!.activities[currentActivityIndex];
  }

  const JourneyState({
    this.activeItinerary,
    this.currentActivityIndex = 0,
    this.currentLatitude = 0.0,
    this.currentLongitude = 0.0,
    this.distanceToNextMeters = 0.0,
    this.etaMinutes = 0,
    this.status = JourneyStatus.idle,
    this.permissionDenied = false,
  });

  JourneyState copyWith({
    TripItinerary? activeItinerary,
    int? currentActivityIndex,
    double? currentLatitude,
    double? currentLongitude,
    double? distanceToNextMeters,
    int? etaMinutes,
    JourneyStatus? status,
    bool? permissionDenied,
  }) {
    return JourneyState(
      activeItinerary: activeItinerary ?? this.activeItinerary,
      currentActivityIndex: currentActivityIndex ?? this.currentActivityIndex,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      distanceToNextMeters: distanceToNextMeters ?? this.distanceToNextMeters,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      status: status ?? this.status,
      permissionDenied: permissionDenied ?? this.permissionDenied,
    );
  }
}
