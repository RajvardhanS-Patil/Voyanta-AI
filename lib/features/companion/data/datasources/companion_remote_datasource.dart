import '../../domain/entities/chat_message.dart';
import '../../domain/entities/companion_context.dart';

abstract class CompanionRemoteDataSource {
  Future<String> getAiResponse({
    required List<ChatMessage> history,
    required CompanionContext context,
  });
}
