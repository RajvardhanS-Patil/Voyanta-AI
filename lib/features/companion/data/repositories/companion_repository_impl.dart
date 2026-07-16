import '../../domain/entities/chat_message.dart';
import '../../domain/entities/companion_context.dart';
import '../../domain/repositories/companion_repository.dart';
import '../datasources/companion_remote_datasource.dart';

class CompanionRepositoryImpl implements CompanionRepository {
  final CompanionRemoteDataSource _remoteDataSource;

  CompanionRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChatMessage> getCompanionResponse({
    required List<ChatMessage> history,
    required CompanionContext context,
  }) async {
    final responseText = await _remoteDataSource.getAiResponse(
      history: history,
      context: context,
    );
    
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responseText,
      sender: MessageSender.assistant,
      timestamp: DateTime.now(),
    );
  }
}
