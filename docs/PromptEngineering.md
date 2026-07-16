# Prompt Engineering Guide — Voyanta AI

This document defines the system instructions, output schemas, and dynamic prompt templates for the Voyanta AI itinerary generator.

---

## 1. System Instruction Prompts

The following system prompt is injected into every itinerary generation request:

```
You are the lead travel planning agent for Voyanta AI. 
Your objective is to generate highly optimized, engaging, and geographically logical travel itineraries.

CONSTRAINTS:
1. Always output valid JSON conforming exactly to the requested schema. No conversational headers or markdown wrapper tags outside the JSON block.
2. Ensure activities are geographically grouped to minimize travel times (e.g., do not schedule morning activities on one side of a city and afternoon activities on the opposite side).
3. Provide realistic latitude and longitude coordinates for all scheduled event locations.
4. Keep activity costs realistic and aligned with the user's budget level.
```

---

## 2. Target Output Schema (JSON Schema)

When requesting itineraries, Gemini is configured to output matching this JSON schema:

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "title": "ItineraryResponse",
  "type": "object",
  "properties": {
    "title": { "type": "string" },
    "days": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "dayNumber": { "type": "integer" },
          "theme": { "type": "string" },
          "events": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "title": { "type": "string" },
                "description": { "type": "string" },
                "timeSlot": { "type": "string" }, // e.g., "09:00 - 11:30"
                "costEstimate": { "type": "number" },
                "latitude": { "type": "number" },
                "longitude": { "type": "number" }
              },
              "required": ["title", "description", "timeSlot", "costEstimate", "latitude", "longitude"]
            }
          }
        },
        "required": ["dayNumber", "theme", "events"]
      }
    }
  },
  "required": ["title", "days"]
}
```

---

## 3. Dynamic Prompt Building Pipeline

The prompt template is constructed dynamically in Dart/TypeScript:

```dart
String buildItineraryPrompt({
  required String destination,
  required int durationDays,
  required String budgetLevel,
  required List<String> interests,
  required String weatherContext,
}) {
  return '''
Generate a travel itinerary for:
Destination: $destination
Duration: $durationDays days
Budget: $budgetLevel
Interests: ${interests.join(', ')}
Weather Condition Indicators: $weatherContext

Make sure to balance the activities to match these interests. Add geographical coordinates matching Mapbox search layouts.
''';
}
```
