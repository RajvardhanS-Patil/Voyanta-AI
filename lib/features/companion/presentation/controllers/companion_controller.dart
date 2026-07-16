import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    
    // Seed initial contextual greeting
    return [
      ChatMessage(
        id: 'init',
        text: "Hello! I'm your Voyanta AI Travel Companion. I'm connected to your active itinerary and live budget trackers. Ask me anything about local dining, budget optimization, or timing adjustments!",
        sender: MessageSender.assistant,
        timestamp: DateTime.now(),
      ),
    ];
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

    // Set loading indicator placeholder state by setting a temporary UI flag
    // In Flutter, we can either append a loading message or manage loading state separately.
    // Let's set loading state inside the UI using the state's async status or append a dummy "loading" msg.
    // Setting state to loading while keeping previous values:
    state = AsyncValue.data([...state.value!, ChatMessage(
      id: 'typing',
      text: '',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    )]);

    try {
      final context = _buildContext();
      
      // Filter out typing placeholder from the history sent to AI
      final history = state.value!.where((msg) => msg.id != 'typing').toList();
      
      final assistantMessage = await _getCompanionResponse(
        history: history,
        context: context,
      );

      // Replace typing placeholder with actual response
      final finalMessages = state.value!.where((msg) => msg.id != 'typing').toList();
      state = AsyncData([...finalMessages, assistantMessage]);
    } catch (e, st) {
      // Remove typing indicator and attach error message
      final finalMessages = state.value!.where((msg) => msg.id != 'typing').toList();
      state = AsyncData([
        ...finalMessages,
        ChatMessage(
          id: 'error_${DateTime.now().millisecondsSinceEpoch}',
          text: "I'm having trouble connecting to the travel grid. Please check your API key in .env.",
          sender: MessageSender.assistant,
          timestamp: DateTime.now(),
        ),
      ]);
      state = AsyncError(e, st);
    }
  }

  CompanionContext _buildContext() {
    final journeyState = ref.read(journeyControllerProvider);
    final expenses = ref.read(expenseControllerProvider).value ?? [];
    final budgetCalculator = ref.read(calculateBudgetHealthUseCaseProvider);
    final budgetStatus = budgetCalculator(expenses);

    // Fallbacks / extracts context
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
