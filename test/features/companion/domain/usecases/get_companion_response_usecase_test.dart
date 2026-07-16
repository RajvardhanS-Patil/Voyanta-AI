import 'package:flutter_test/flutter_test.dart';
import 'package:voyanta_ai/features/companion/domain/entities/chat_message.dart';
import 'package:voyanta_ai/features/companion/domain/entities/companion_context.dart';
import 'package:voyanta_ai/features/companion/domain/repositories/companion_repository.dart';
import 'package:voyanta_ai/features/companion/domain/usecases/get_companion_response_usecase.dart';

class MockCompanionRepository implements CompanionRepository {
  List<ChatMessage>? lastHistoryPassed;
  CompanionContext? lastContextPassed;
  
  @override
  Future<ChatMessage> getCompanionResponse({
    required List<ChatMessage> history,
    required CompanionContext context,
  }) async {
    lastHistoryPassed = history;
    lastContextPassed = context;
    return ChatMessage(
      id: 'mock_id',
      text: 'Mock response for ${context.activeTripDestination}',
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    );
  }
}

void main() {
  group('GetCompanionResponseUseCase', () {
    late MockCompanionRepository mockRepository;
    late GetCompanionResponseUseCase useCase;

    setUp(() {
      mockRepository = MockCompanionRepository();
      useCase = GetCompanionResponseUseCase(mockRepository);
    });

    test('should pass history and context to repository and return response message', () async {
      final context = const CompanionContext(
        activeTripDestination: 'Tokyo',
        activeTripTheme: 'Art & Tech',
        activeTripDayNumber: 2,
        completedActivityTitles: ['Shibuya Crossing'],
        nextActivityTitle: 'teamLab Borderless',
        nextActivityDistanceKm: 3.5,
        nextActivityEtaMinutes: 20,
        totalBudget: 3000.0,
        totalSpent: 450.0,
        weatherInfo: 'Rainy, 18C',
      );

      final history = [
        ChatMessage(
          id: '1',
          text: 'Suggest food in Tokyo',
          sender: MessageSender.user,
          timestamp: DateTime.now(),
        ),
      ];

      final result = await useCase(history: history, context: context);

      expect(result.id, 'mock_id');
      expect(result.text, 'Mock response for Tokyo');
      expect(result.sender, MessageSender.assistant);
      expect(mockRepository.lastHistoryPassed, history);
      expect(mockRepository.lastContextPassed, context);
    });
  });
}
