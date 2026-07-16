import 'package:flutter_test/flutter_test.dart';
import 'package:voyanta_ai/features/trip_planner/data/models/trip_itinerary_model.dart';

void main() {
  group('TripItineraryModel JSON Parsing', () {
    test('should parse valid JSON correctly', () {
      final Map<String, dynamic> json = {
        "dayNumber": 1,
        "theme": "Arrival and City Highlights",
        "activities": [
          {
            "time": "10:00 AM",
            "title": "Arrive at Hotel",
            "description": "Check in and freshen up",
            "latitude": 40.7128,
            "longitude": -74.0060,
          },
        ],
      };

      final model = TripItineraryModel.fromJson(json);

      expect(model.dayNumber, 1);
      expect(model.theme, "Arrival and City Highlights");
      expect(model.activities.length, 1);

      final activity = model.activities.first;
      expect(activity.time, "10:00 AM");
      expect(activity.title, "Arrive at Hotel");
      expect(activity.description, "Check in and freshen up");
      expect(activity.latitude, 40.7128);
      expect(activity.longitude, -74.0060);
    });

    test('should handle missing and malformed fields gracefully', () {
      final Map<String, dynamic> json = {
        "activities": [
          {"latitude": "invalid_string_type"},
        ],
      };

      final model = TripItineraryModel.fromJson(json);

      expect(model.dayNumber, 0);
      expect(model.theme, "");
      expect(model.activities.length, 1);

      final activity = model.activities.first;
      expect(activity.time, "");
      expect(activity.title, "");
      expect(activity.description, "");
      expect(activity.latitude, 0.0); // handled by safe casting
      expect(activity.longitude, 0.0);
    });
  });
}
