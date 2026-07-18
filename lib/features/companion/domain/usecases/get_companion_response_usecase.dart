import '../entities/chat_message.dart';
import '../entities/companion_context.dart';
import '../repositories/companion_repository.dart';

class GetCompanionResponseUseCase {
  final CompanionRepository _repository;

  GetCompanionResponseUseCase(this._repository);

  Future<ChatMessage> call({
    required List<ChatMessage> history,
    required CompanionContext context,
  }) {
    return _repository.getCompanionResponse(history: history, context: context);
  }
}
