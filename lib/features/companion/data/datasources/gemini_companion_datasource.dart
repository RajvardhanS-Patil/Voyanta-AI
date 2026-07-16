import 'package:google_generative_ai/google_generative_ai.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/companion_context.dart';
import 'companion_remote_datasource.dart';

class GeminiCompanionDataSource implements CompanionRemoteDataSource {
  final GenerativeModel _model;

  GeminiCompanionDataSource(this._model);

  @override
  Future<String> getAiResponse({
    required List<ChatMessage> history,
    required CompanionContext context,
  }) async {
    final systemPrompt = '''
You are "Voyanta AI", a premium, context-aware AI Travel Companion.
You are assisting the user during their trip.

CURRENT TRIP CONTEXT:
- Destination: ${context.activeTripDestination}
- Current Day Number: ${context.activeTripDayNumber}
- Trip Theme: ${context.activeTripTheme}
- Trip Budget Limit: \$${context.totalBudget.toStringAsFixed(2)}
- Current Amount Spent: \$${context.totalSpent.toStringAsFixed(2)}
- Budget Remaining: \$${(context.totalBudget - context.totalSpent).toStringAsFixed(2)}
- Weather Index: ${context.weatherInfo}
- Completed Activities: ${context.completedActivityTitles.isEmpty ? "None yet" : context.completedActivityTitles.join(', ')}
- Upcoming Target Activity: ${context.nextActivityTitle} (Distance: ${context.nextActivityDistanceKm.toStringAsFixed(1)} km, ETA: ${context.nextActivityEtaMinutes} mins)

Capabilities:
1. Context-aware conversation: Reference active locations, trip milestones, and budget metrics naturally.
2. AI itinerary refinement: Suggest optimal times, outdoor changes, and nearby locations.
3. Budget recommendations: Advise on keeping spending low and check remaining balance.
4. Food recommendations near their next location.
5. Suggesting nearby hidden gem attractions.
6. Local travel tips (transit methods, customs).
7. Packing guidance & weather safety suggestions.
8. Time optimization & daily trip summaries.

Directives:
- Respond in warm, premium, concise, markdown-friendly statements.
- Never use generic bot disclaimers like "As an AI...". Speak as their local travel guide/friend.
- Keep responses relatively brief (1-3 paragraphs or simple bullet points) so they are readable on mobile.
- If the user asks for budget advice, reference their remaining budget: \$${(context.totalBudget - context.totalSpent).toStringAsFixed(2)}.
''';

    try {
      final List<Content> contents = [];
      
      // Add system context guide
      contents.add(Content.system(systemPrompt));

      // Append sliding window history
      for (final msg in history) {
        if (msg.sender == MessageSender.user) {
          contents.add(Content.text(msg.text));
        } else {
          contents.add(Content.model([TextPart(msg.text)]));
        }
      }

      final response = await _model.generateContent(contents);
      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Generative model returned an empty response.');
      }
      return responseText;
    } catch (e) {
      throw Exception('Failed to get AI companion response: $e');
    }
  }
}
