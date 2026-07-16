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
import 'companion_providers.dart';

class CompanionController extends AsyncNotifier<List<ChatMessage>> {
  late final GetCompanionResponseUseCase _getCompanionResponse;

  @override
  Future<List<ChatMessage>> build() async {
    _getCompanionResponse = ref.read(getCompanionResponseUseCaseProvider);
    
    // Load previously stored dialogue records from Isar local db
    final saved = await IsarService.isar.chatMessageDbs.where().sortByTimestamp().findAll();
    if (saved.isNotEmpty) {
      return saved.map((db) => ChatMessage(
        id: db.messageId,
        text: db.text,
        sender: db.sender == 'user' ? MessageSender.user : MessageSender.assistant,
        timestamp: db.timestamp,
      )).toList();
    }

    // Seed initial contextual greeting
    final initMsg = ChatMessage(
      id: 'init',
      text: "Hello! I'm your Voyanta AI Travel Companion. I'm connected to your active itinerary and live budget trackers. Ask me anything about local dining, budget optimization, or timing adjustments!",
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
        text: "I am currently offline. I cannot access the live AI travel companion server, but you can still view your offline itineraries, saved budget expenses, and conversation archives.",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );
      state = AsyncData([...state.value!, offlineReply]);
      await _saveMessageToDb(offlineReply);
      return;
    }

    // Append typing placeholder
    state = AsyncValue.data([...state.value!, ChatMessage(
      id: 'typing',
      text: '',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    )]);

    try {
      final context = _buildContext();
      final history = state.value!.where((msg) => msg.id != 'typing').toList();
      
      final assistantMessage = await _getCompanionResponse(
        history: history,
        context: context,
      );

      // Swap out typing indicator for AI reply
      final finalMessages = state.value!.where((msg) => msg.id != 'typing').toList();
      state = AsyncData([...finalMessages, assistantMessage]);
      await _saveMessageToDb(assistantMessage);
    } catch (e, st) {
      final finalMessages = state.value!.where((msg) => msg.id != 'typing').toList();
      final errorReply = ChatMessage(
        id: 'error_${DateTime.now().millisecondsSinceEpoch}',
        text: "I'm having trouble connecting to the travel grid. Please check your API key in .env.",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      );
      state = AsyncData([...finalMessages, errorReply]);
      await _saveMessageToDb(errorReply);
      state = AsyncError(e, st);
    }
  }

  CompanionContext _buildContext() {
    final journeyState = ref.read(journeyControllerProvider);
    final expenses = ref.read(expenseControllerProvider).value ?? [];
    final budgetCalculator = ref.read(calculateBudgetHealthUseCaseProvider);
    final budgetStatus = budgetCalculator(expenses);

    const destination = "New York City";
    const theme = "City Highlights";
    const dayNum = 1;

    final nextActivity = journeyState.currentActivity?.title ?? "Empire State Building";
    final nextDistance = journeyState.distanceToNextMeters / 1000.0;
    final nextEta = journeyState.etaMinutes;

    return CompanionContext(
      activeTripDestination: destination,
      activeTripTheme: theme,
      activeTripDayNumber: dayNum,
      completedActivityTitles: const ["Times Square Arrival Walk"],
      nextActivityTitle: nextActivity,
      nextActivityDistanceKm: nextDistance > 0 ? nextDistance : 1.8,
      nextActivityEtaMinutes: nextEta > 0 ? nextEta : 12,
      totalBudget: budgetStatus.totalBudget,
      totalSpent: budgetStatus.currentSpent,
      weatherInfo: "Sunny, 22°C",
    );
  }
}

final companionControllerProvider = AsyncNotifierProvider<CompanionController, List<ChatMessage>>(() {
  return CompanionController();
});
