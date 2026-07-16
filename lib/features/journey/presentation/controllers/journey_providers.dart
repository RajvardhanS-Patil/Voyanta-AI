import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/journey/data/repositories/location_repository_impl.dart';
import 'package:voyanta_ai/features/journey/domain/repositories/location_repository.dart';
import 'package:voyanta_ai/features/journey/domain/usecases/calculate_eta_usecase.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepositoryImpl();
});

final calculateEtaUseCaseProvider = Provider<CalculateEtaUseCase>((ref) {
  return CalculateEtaUseCase();
});
