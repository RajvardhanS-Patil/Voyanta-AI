import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/chat_message_db.dart';
import 'package:voyanta_ai/core/services/connectivity_service.dart';
import 'package:voyanta_ai/features/companion/domain/entities/chat_message.dart';
import 'package:voyanta_ai/features/companion/domain/entities/companion_context.dart';
import 'package:voyanta_ai/features/companion/domain/usecases/get_companion_response_usecase.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/trip_planner/presentation/controllers/trip_planner_providers.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';
import 'package:voyanta_ai/core/observability/observability_service.dart';
import 'companion_providers.dart';

class CompanionController extends AsyncNotifier<List<ChatMessage>> {
  late final GetCompanionResponseUseCase _getCompanionResponse;

  @override
  Future<List<ChatMessage>> build() async {
    _getCompanionResponse = ref.read(getCompanionResponseUseCaseProvider);

    // Load previously stored dialogue records from Isar local db
    final saved = await IsarService.isar.chatMessageDbs
        .where()
        .sortByTimestamp()
        .findAll();
    if (saved.isNotEmpty) {
      return saved
          .map(
            (db) => ChatMessage(
              id: db.messageId,
              text: db.text,
              sender: db.sender == 'user'
                  ? MessageSender.user
                  : MessageSender.assistant,
              timestamp: db.timestamp,
            ),
          )
          .toList();
    }

    // Seed initial contextual greeting
    final initMsg = ChatMessage(
      id: 'init',
      text:
          "Hello! I'm your Voyanta AI Travel Companion. I'm connected to your active itinerary and live budget trackers. Ask me anything about local dining, budget optimization, or timing adjustments!",
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    );

    await _saveMessageToDb(initMsg);
    return [initMsg];
  }

  Future<void> _saveMessageToDb(ChatMessage message) async {
    final db = ChatMessageDb()
      ..messageId = message.id
      ..text = message.text
      ..sender = message.sender == MessageSender.user ? 'user' : 'assistant'
      ..timestamp = message.timestamp;

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.chatMessageDbs.put(db);
    });
  }

  Future<void> sendMessage(String text) async {
    final currentList = state.value ?? [];

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    // Append user message instantly
    state = AsyncData([...currentList, userMessage]);
    await _saveMessageToDb(userMessage);

    // Guard: Prevent API generation if offline, display custom system helper message
    final connection = ref.read(connectivityServiceProvider);
    if (connection == ConnectionStatus.offline) {
      final offlineReply = ChatMessage(
        id: 'offline_${DateTime.now().millisecondsSinceEpoch}',
        text:
            "I am currently offline. I cannot access the live AI travel companion server, but you can still view your offline itineraries, saved budget expenses, and conversation archives.",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );
      state = AsyncData([...state.value!, offlineReply]);
      await _saveMessageToDb(offlineReply);
      return;
    }

    // Append typing placeholder
    state = AsyncValue.data([
      ...state.value!,
      ChatMessage(
        id: 'typing',
        text: '',
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      ),
    ]);

    try {
      final context = _buildContext();
      final history = state.value!.where((msg) => msg.id != 'typing').toList();

      final assistantMessage = await _getCompanionResponse(
        history: history,
        context: context,
      );

      // Parse PLAN_UPDATE blocks from the AI response
      _parsePlanUpdates(assistantMessage.text);

      // Swap out typing indicator for AI reply
      final finalMessages = state.value!
          .where((msg) => msg.id != 'typing')
          .toList();
      state = AsyncData([...finalMessages, assistantMessage]);
      await _saveMessageToDb(assistantMessage);
      ObservabilityService.trackEvent('ai_request', {'success': true});
    } catch (e, st) {
      final finalMessages = state.value!
          .where((msg) => msg.id != 'typing')
          .toList();
      final errorReply = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        text:
            "I'm having trouble connecting to the travel grid. Please check your API key in .env.",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );
      state = AsyncData([...finalMessages, errorReply]);
      await _saveMessageToDb(errorReply);
      state = AsyncError(e, st);
    }
  }

  /// Parse [PLAN_UPDATE] JSON blocks from the AI response and push changes
  /// into the generatedItinerariesProvider so the Planner screen updates live.
  void _parsePlanUpdates(String responseText) {
    final planUpdateRegex = RegExp(
      r'\[PLAN_UPDATE\](.*?)\[/PLAN_UPDATE\]',
      dotAll: true,
    );

    final matches = planUpdateRegex.allMatches(responseText);
    if (matches.isEmpty) return;

    for (final match in matches) {
      try {
        final jsonStr = match.group(1)?.trim();
        if (jsonStr == null) continue;

        final Map<String, dynamic> update = jsonDecode(jsonStr);
        final action = update['action'] as String?;
        final dayNumber = update['dayNumber'] as int? ?? 1;

        if (action == 'add' && update['activity'] != null) {
          final actData = update['activity'] as Map<String, dynamic>;
          final newActivity = Activity(
            time: actData['time'] ?? '12:00 PM',
            title: actData['title'] ?? 'New Activity',
            description: actData['description'] ?? '',
            latitude: (actData['latitude'] as num?)?.toDouble() ?? 0.0,
            longitude: (actData['longitude'] as num?)?.toDouble() ?? 0.0,
          );

          final currentItineraries = ref.read(generatedItinerariesProvider);
          if (currentItineraries.isEmpty) {
            // Create a new day if none exist
            ref.read(generatedItinerariesProvider.notifier).setItineraries([
              TripItinerary(
                dayNumber: dayNumber,
                theme: 'Updated Plan',
                activities: [newActivity],
              ),
            ]);
          } else {
            // Find the matching day or add to the closest day
            final updated = currentItineraries.map((itin) {
              if (itin.dayNumber == dayNumber) {
                return TripItinerary(
                  dayNumber: itin.dayNumber,
                  theme: itin.theme,
                  activities: [...itin.activities, newActivity],
                );
              }
              return itin;
            }).toList();

            // If no matching day found, append to first day
            final hasMatch = currentItineraries.any(
              (i) => i.dayNumber == dayNumber,
            );
            if (!hasMatch && updated.isNotEmpty) {
              final first = updated[0];
              updated[0] = TripItinerary(
                dayNumber: first.dayNumber,
                theme: first.theme,
                activities: [...first.activities, newActivity],
              );
            }

            ref
                .read(generatedItinerariesProvider.notifier)
                .setItineraries(updated);
          }

          ObservabilityService.trackEvent('plan_update_from_ai', {
            'action': action,
            'activity': newActivity.title,
          });
        }
      } catch (e) {
        // Silently ignore parse errors — the AI may not always format perfectly
        ObservabilityService.logInfo('PLAN_UPDATE parse error: $e');
      }
    }
  }

  CompanionContext _buildContext() {
    final journeyState = ref.read(journeyControllerProvider);
    final expenses = ref.read(expenseControllerProvider).value ?? [];
    final tripMeta = ref.read(tripMetaControllerProvider).value;
    final budgetCalculator = ref.read(calculateBudgetHealthUseCaseProvider);
    
    final totalBudget = tripMeta?.totalBudget ?? 5000.0;
    final budgetStatus = budgetCalculator(expenses, totalBudget: totalBudget);

    final itinerary = journeyState.activeItinerary;

    final destination = itinerary?.theme ?? "Unknown Destination";
    final theme = itinerary?.theme ?? "General Travel";
    final dayNum = itinerary?.dayNumber ?? 1;

    final completedActivities = <String>[];
    if (itinerary != null) {
      for (int i = 0; i < journeyState.currentActivityIndex; i++) {
        if (i < itinerary.activities.length) {
          completedActivities.add(itinerary.activities[i].title);
        }
      }
    }

    final nextActivity = journeyState.currentActivity?.title ?? "None";
    final nextDistance = journeyState.distanceToNextMeters / 1000.0;
    final nextEta = journeyState.etaMinutes;

    return CompanionContext(
      activeTripDestination: destination,
      activeTripTheme: theme,
      activeTripDayNumber: dayNum,
      completedActivityTitles: completedActivities,
      nextActivityTitle: nextActivity,
      nextActivityDistanceKm: nextDistance,
      nextActivityEtaMinutes: nextEta,
      totalBudget: budgetStatus.totalBudget,
      totalSpent: budgetStatus.currentSpent,
      weatherInfo: "Showers & Rainy", // Mock shared with intelligence
    );
  }
}

final companionControllerProvider =
    AsyncNotifierProvider<CompanionController, List<ChatMessage>>(() {
      return CompanionController();
    });
