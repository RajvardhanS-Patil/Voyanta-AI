import '../entities/expense.dart';
import '../entities/budget_status.dart';

class CalculateBudgetHealthUseCase {
  final double totalBudget;

  CalculateBudgetHealthUseCase({required this.totalBudget});

  BudgetStatus call(List<Expense> expenses) {
    double totalSpent = 0;
    for (var expense in expenses) {
      totalSpent += expense.amount;
    }

    return BudgetStatus(totalBudget: totalBudget, currentSpent: totalSpent);
  }

  Map<ExpenseCategory, double> getCategoryBreakdown(List<Expense> expenses) {
    final breakdown = <ExpenseCategory, double>{};
    for (var cat in ExpenseCategory.values) {
      breakdown[cat] = 0.0;
    }

    for (var expense in expenses) {
      breakdown[expense.category] =
          (breakdown[expense.category] ?? 0.0) + expense.amount;
    }

    return breakdown;
  }
}
