import 'dart:convert';
import 'package:voyanta_ai/core/network/groq_client.dart';
import '../models/trip_itinerary_model.dart';
import 'gemini_remote_datasource.dart'; // To get the TripRemoteDataSource interface

class GroqRemoteDataSource implements TripRemoteDataSource {
  @override
  Future<List<TripItineraryModel>> generateItinerary({
    required String destination,
    required int numDays,
    required String interests,
    required String budgetLevel,
  }) async {
    final prompt = '''
You are an expert travel planner specializing in student-friendly, budget travel. 
Create a $numDays day itinerary for a trip to $destination.
The user is interested in: $interests. The budget level is: $budgetLevel.

CRITICAL RULES FOR AI:
1. NO RIGID OR BORING SCHEDULES: Do not just spit out generic "10 AM, 1 PM, 5 PM" templates. Generate highly realistic, dynamic schedules with varying durations depending on the spot (e.g. 9:15 AM, 11:30 AM, 3:45 PM).
2. DENSE BUT ACHIEVABLE DAYS: Include 4 to 6 places/activities per day, factoring in realistic travel times between them.
3. STUDENT BUDGET (MAX ENJOYMENT / MIN EXPENSE): You MUST heavily prioritize affordable, local, and student-friendly solutions. Suggest cheap/free entry places, hidden gems, street food, or inexpensive local eateries over tourist traps.
4. TRANSPORTATION HINTS: In the description, briefly mention the cheapest way to travel between the spots (e.g., "Take a local bus/metro", "15 min walk").

You MUST return a JSON object containing a single key "itinerary" which is a JSON array of day objects.
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
      final response = await GroqClientManager.dio.post(
        '/chat/completions',
        data: {
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {
              "role": "user",
              "content": prompt,
            }
          ],
          "response_format": {"type": "json_object"},
          "temperature": 0.3,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      if (content == null || content.isEmpty) {
        throw Exception('AI returned an empty response.');
      }

      final Map<String, dynamic> jsonResponse = jsonDecode(content);
      final List<dynamic> jsonList = jsonResponse['itinerary'] as List<dynamic>;

      return jsonList.map((e) => TripItineraryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to generate itinerary: $e');
    }
  }
}
