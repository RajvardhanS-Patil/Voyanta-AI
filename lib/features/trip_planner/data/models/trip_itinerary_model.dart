import '../../domain/entities/trip_itinerary.dart';
import 'activity_model.dart';

class TripItineraryModel extends TripItinerary {
  const TripItineraryModel({
    required super.dayNumber,
    required super.theme,
    required super.activities,
  });

  factory TripItineraryModel.fromJson(Map<String, dynamic> json) {
    return TripItineraryModel(
      dayNumber: json['dayNumber'] as int? ?? 0,
      theme: json['theme'] ?? '',
      activities:
          (json['activities'] as List<dynamic>?)
              ?.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
