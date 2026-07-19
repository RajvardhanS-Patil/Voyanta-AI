import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:voyanta_ai/features/expenses/domain/repositories/expense_repository.dart';
import 'package:voyanta_ai/features/expenses/domain/usecases/calculate_budget_health_usecase.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:voyanta_ai/features/expenses/data/repositories/trip_meta_repository_impl.dart';
import 'package:voyanta_ai/features/expenses/domain/repositories/trip_meta_repository.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/trip_meta_controller.dart';
import '../../domain/entities/trip_meta.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final tripMetaRepositoryProvider = Provider<TripMetaRepository>((ref) {
  return TripMetaRepositoryImpl(ref.read(secureStorageProvider));
});

final tripMetaControllerProvider =
    AsyncNotifierProvider<TripMetaController, TripMeta>(() {
  return TripMetaController();
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl();
});

final calculateBudgetHealthUseCaseProvider =
    Provider<CalculateBudgetHealthUseCase>((ref) {
  return CalculateBudgetHealthUseCase();
});
