import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/trip_itinerary_model.dart';

abstract class TripRemoteDataSource {
  Future<List<TripItineraryModel>> generateItinerary({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  });
}

class GeminiRemoteDataSource implements TripRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource(this._model);

  @override
  Future<List<TripItineraryModel>> generateItinerary({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  }) async {
    final prompt =
        '''
You are an expert travel planner specializing in student-friendly, budget travel. 
Create a $numDays day itinerary for a trip to $destination.
The user is interested in: $interests. The budget level is: $budgetLevel.

CRITICAL RULES FOR AI:
1. Prioritize highly affordable, student-friendly solutions for everything.
2. Recommend cheap and efficient travel routes (public transport, walking) instead of expensive taxis.
3. Suggest budget stays, hostels, or safe but pocket-friendly neighborhoods.
4. Maximize enjoyment by including cool local spots, street food, and free/discounted student attractions at the lowest possible cost.

Return ONLY a valid JSON array of day objects. Do not include markdown formatting like ```json.
Each day object must have the following schema:
{
  "dayNumber": int,
  "theme": "string",
  "activities": [
    {
      "time": "string (e.g. 10:00 AM)",
      "title": "string",
      "description": "string",
      "latitude": float,
      "longitude": float
    }
  ]
}
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text;
      if (text == null || text.isEmpty) {
        throw Exception('AI returned an empty response.');
      }

      // Clean potential markdown blocks if the model ignored instructions
      final cleanText = text.replaceAll(RegExp(r'```json|```'), '').trim();
      final List<dynamic> jsonList = jsonDecode(cleanText);

      return jsonList.map((e) => TripItineraryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to generate itinerary: $e');
    }
  }
}
