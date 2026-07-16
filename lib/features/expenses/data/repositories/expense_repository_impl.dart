import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  // In-memory cache simulating database latency
  final List<Expense> _cache = [];

  @override
  Future<List<Expense>> getExpenses() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cache.insert(0, expense); // Newest first
  }

  @override
  Future<void> deleteExpense(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cache.removeWhere((e) => e.id == id);
  }
}
