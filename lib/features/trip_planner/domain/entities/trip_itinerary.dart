import 'activity.dart';

class TripItinerary {
  final int dayNumber;
  final String theme;
  final List<Activity> activities;

  const TripItinerary({
    required this.dayNumber,
    required this.theme,
    required this.activities,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripItinerary &&
          runtimeType == other.runtimeType &&
          dayNumber == other.dayNumber &&
          theme == other.theme &&
          activities.length == other.activities.length; // Simplified for speed

  @override
  int get hashCode => dayNumber.hashCode ^ theme.hashCode ^ activities.hashCode;
}
