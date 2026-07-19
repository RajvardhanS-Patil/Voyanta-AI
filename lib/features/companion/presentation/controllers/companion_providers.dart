import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/companion/data/datasources/companion_remote_datasource.dart';
import 'package:voyanta_ai/features/companion/data/datasources/groq_companion_datasource.dart';
import 'package:voyanta_ai/features/companion/data/repositories/companion_repository_impl.dart';
import 'package:voyanta_ai/features/companion/domain/repositories/companion_repository.dart';
import 'package:voyanta_ai/features/companion/domain/usecases/get_companion_response_usecase.dart';

final companionRemoteDataSourceProvider = Provider<CompanionRemoteDataSource>((
  ref,
) {
  return GroqCompanionDataSource();
});

final companionRepositoryProvider = Provider<CompanionRepository>((ref) {
  final remote = ref.read(companionRemoteDataSourceProvider);
  return CompanionRepositoryImpl(remote);
});

final getCompanionResponseUseCaseProvider =
    Provider<GetCompanionResponseUseCase>((ref) {
      final repo = ref.read(companionRepositoryProvider);
      return GetCompanionResponseUseCase(repo);
    });
