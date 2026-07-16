import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:voyanta_ai/features/companion/data/datasources/companion_remote_datasource.dart';
import 'package:voyanta_ai/features/companion/data/datasources/gemini_companion_datasource.dart';
import 'package:voyanta_ai/features/companion/data/repositories/companion_repository_impl.dart';
import 'package:voyanta_ai/features/companion/domain/repositories/companion_repository.dart';
import 'package:voyanta_ai/features/companion/domain/usecases/get_companion_response_usecase.dart';

final companionRemoteDataSourceProvider = Provider<CompanionRemoteDataSource>((ref) {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
  );
  return GeminiCompanionDataSource(model);
});

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  final remote = ref.read(companionRemoteDataSourceProvider);
  return CompanionRepositoryImpl(remote);
});

final getCompanionResponseUseCaseProvider = Provider<GetCompanionResponseUseCase>((ref) {
  final repo = ref.read(companionRepositoryProvider);
  return GetCompanionResponseUseCase(repo);
});
