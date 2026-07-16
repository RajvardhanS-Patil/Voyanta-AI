import 'package:flutter_test/flutter_test.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/expense.dart';
import 'package:voyanta_ai/features/expenses/domain/usecases/calculate_budget_health_usecase.dart';

void main() {
  group('CalculateBudgetHealthUseCase', () {
    late CalculateBudgetHealthUseCase useCase;

    setUp(() {
      useCase = CalculateBudgetHealthUseCase(totalBudget: 1000.0);
    });

    test('should calculate zero spent when expenses list is empty', () {
      final status = useCase([]);

      expect(status.totalBudget, 1000.0);
      expect(status.currentSpent, 0.0);
      expect(status.remaining, 1000.0);
      expect(status.percentageSpent, 0.0);
      expect(status.isWarning, false);
      expect(status.isOverBudget, false);
    });

    test('should calculate spent correctly and trigger warning at 80%', () {
      final expenses = [
        Expense(
          id: '1',
          amount: 850.0,
          category: ExpenseCategory.lodging,
          description: 'Hotel',
          date: DateTime.now(),
        ),
      ];

      final status = useCase(expenses);

      expect(status.currentSpent, 850.0);
      expect(status.percentageSpent, 0.85);
      expect(status.isWarning, true);
      expect(status.isOverBudget, false);
    });

    test('should trigger overBudget when spent exceeds total budget', () {
      final expenses = [
        Expense(id: '1', amount: 900.0, category: ExpenseCategory.lodging, description: 'Hotel', date: DateTime.now()),
        Expense(id: '2', amount: 150.0, category: ExpenseCategory.food, description: 'Dinner', date: DateTime.now()),
      ];

      final status = useCase(expenses);

      expect(status.currentSpent, 1050.0);
      expect(status.remaining, -50.0);
      expect(status.isWarning, false); // Warning is strictly [80% - 100%)
      expect(status.isOverBudget, true);
    });

    test('should accurately breakdown expenses by category', () {
      final expenses = [
        Expense(id: '1', amount: 50.0, category: ExpenseCategory.food, description: 'Lunch', date: DateTime.now()),
        Expense(id: '2', amount: 30.0, category: ExpenseCategory.food, description: 'Dinner', date: DateTime.now()),
        Expense(id: '3', amount: 100.0, category: ExpenseCategory.transport, description: 'Flight', date: DateTime.now()),
      ];

      final breakdown = useCase.getCategoryBreakdown(expenses);

      expect(breakdown[ExpenseCategory.food], 80.0);
      expect(breakdown[ExpenseCategory.transport], 100.0);
      expect(breakdown[ExpenseCategory.lodging], 0.0);
    });
  });
}
