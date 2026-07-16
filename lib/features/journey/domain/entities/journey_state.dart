import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';

enum JourneyStatus { idle, navigating, arrived, completed }

class JourneyState {
  final Activity? currentActivity;
  final double currentLatitude;
  final double currentLongitude;
  final double distanceToNextMeters;
  final int etaMinutes;
  final JourneyStatus status;

  const JourneyState({
    this.currentActivity,
    this.currentLatitude = 0.0,
    this.currentLongitude = 0.0,
    this.distanceToNextMeters = 0.0,
    this.etaMinutes = 0,
    this.status = JourneyStatus.idle,
  });

  JourneyState copyWith({
    Activity? currentActivity,
    double? currentLatitude,
    double? currentLongitude,
    double? distanceToNextMeters,
    int? etaMinutes,
    JourneyStatus? status,
  }) {
    return JourneyState(
      currentActivity: currentActivity ?? this.currentActivity,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      distanceToNextMeters: distanceToNextMeters ?? this.distanceToNextMeters,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      status: status ?? this.status,
    );
  }
}
