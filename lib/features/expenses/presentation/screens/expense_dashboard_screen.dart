import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';
import 'package:voyanta_ai/features/expenses/presentation/widgets/budget_progress_bar.dart';
import 'package:voyanta_ai/features/expenses/presentation/widgets/expense_form_overlay.dart';

class ExpenseDashboardScreen extends ConsumerWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseControllerProvider);
    final calculator = ref.watch(calculateBudgetHealthUseCaseProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Budget & Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        onPressed: () => ExpenseFormOverlay.show(context),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final status = calculator(expenses);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BudgetProgressBar(status: status),
                const SizedBox(height: 32),
                const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.withValues(alpha: 0.2),
                          child: const Icon(Icons.receipt, color: Colors.tealAccent),
                        ),
                        title: Text(expense.description, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(expense.category.name.toUpperCase(), style: const TextStyle(color: Colors.white54)),
                        trailing: Text(
                          '-\$${expense.amount.toStringAsFixed(2)}', 
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
        error: (err, st) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.redAccent))),
      ),
    );
  }
}
