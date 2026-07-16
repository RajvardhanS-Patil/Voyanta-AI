import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:voyanta_ai/features/expenses/domain/repositories/expense_repository.dart';
import 'package:voyanta_ai/features/expenses/domain/usecases/calculate_budget_health_usecase.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl();
});

// Assume a generic $5,000 budget for the MVP demo
final calculateBudgetHealthUseCaseProvider = Provider<CalculateBudgetHealthUseCase>((ref) {
  return CalculateBudgetHealthUseCase(totalBudget: 5000.0);
});
