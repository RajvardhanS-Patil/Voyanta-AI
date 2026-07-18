import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/expense.dart';
import 'package:voyanta_ai/features/expenses/domain/repositories/expense_repository.dart';
import 'package:voyanta_ai/core/observability/observability_service.dart';
import 'expense_providers.dart';

class ExpenseController extends AsyncNotifier<List<Expense>> {
  late final ExpenseRepository _repository;

  @override
  Future<List<Expense>> build() async {
    _repository = ref.read(expenseRepositoryProvider);
    return await _repository.getExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    // Optimistic UI update: instantly render before DB network resolution
    final previousState = state;
    if (state.hasValue) {
      state = AsyncData([expense, ...state.value!]);
    }

    try {
      await _repository.addExpense(expense);
      ObservabilityService.trackEvent('expense_added', {
        'amount': expense.amount,
        'category': expense.category,
      });
    } catch (e, st) {
      // Revert if DB fails
      state = previousState;
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteExpense(String id) async {
    final previousState = state;
    if (state.hasValue) {
      state = AsyncData(state.value!.where((e) => e.id != id).toList());
    }

    try {
      await _repository.deleteExpense(id);
    } catch (e, st) {
      state = previousState;
      state = AsyncError(e, st);
    }
  }
}

final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, List<Expense>>(() {
      return ExpenseController();
    });
