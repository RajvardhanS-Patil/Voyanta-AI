import '../entities/chat_message.dart';
import '../entities/companion_context.dart';

abstract class CompanionRepository {
  Future<ChatMessage> getCompanionResponse({
    required List<ChatMessage> history,
    required CompanionContext context,
  });
}
