import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/ux/animated_background.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';
import 'package:voyanta_ai/features/expenses/presentation/widgets/expense_form_overlay.dart';
import 'package:voyanta_ai/features/expenses/presentation/widgets/trip_setup_dialog.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/expense.dart';
import 'package:voyanta_ai/core/ux/empty_state_view.dart';
import 'package:voyanta_ai/core/ux/error_recovery_view.dart';
import 'dart:math' as math;

class Settlement {
  final String from;
  final String to;
  final double amount;
  Settlement(this.from, this.to, this.amount);
}

class ExpenseDashboardScreen extends ConsumerStatefulWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  ConsumerState<ExpenseDashboardScreen> createState() => _ExpenseDashboardScreenState();
}

class _ExpenseDashboardScreenState extends ConsumerState<ExpenseDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Settlement> _calculateSettlements(Map<String, double> balances) {
    final debtors = balances.entries.where((e) => e.value < -0.01).map((e) => MapEntry(e.key, -e.value)).toList();
    final creditors = balances.entries.where((e) => e.value > 0.01).map((e) => MapEntry(e.key, e.value)).toList();
    
    debtors.sort((a, b) => b.value.compareTo(a.value));
    creditors.sort((a, b) => b.value.compareTo(a.value));
    
    List<Settlement> settlements = [];
    int i = 0, j = 0;
    
    while (i < debtors.length && j < creditors.length) {
      final debtor = debtors[i];
      final creditor = creditors[j];
      
      final amount = math.min(debtor.value, creditor.value);
      settlements.add(Settlement(debtor.key, creditor.key, amount));
      
      debtors[i] = MapEntry(debtor.key, debtor.value - amount);
      creditors[j] = MapEntry(creditor.key, creditor.value - amount);
      
      if (debtors[i].value < 0.01) i++;
      if (creditors[j].value < 0.01) j++;
    }
    return settlements;
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseControllerProvider);
    final tripMetaAsync = ref.watch(tripMetaControllerProvider);
    final calculator = ref.watch(calculateBudgetHealthUseCaseProvider);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? Colors.white70 : const Color(0xFF475569);
    final cardColor = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white;
    final accentColor = isDark ? Colors.tealAccent : const Color(0xFF0D9488);

    final totalBudget = tripMetaAsync.value?.totalBudget ?? 5000.0;

    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Budget & Split',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: textColor),
            onPressed: () => TripSetupDialog.show(context),
            tooltip: 'Setup Budget & Members',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: accentColor,
          unselectedLabelColor: subtextColor,
          indicatorColor: accentColor,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Settlements'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () => ExpenseFormOverlay.show(context),
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
      ),
      body: expensesAsync.when(
        data: (expenses) {
          final status = calculator(expenses, totalBudget: totalBudget);

          // Build per-person balance summary
          final Map<String, double> balances = {};
          for (final e in expenses) {
            final perPerson = e.perPersonAmount;
            
            // The person who paid is owed the full amount of the expense
            balances[e.paidBy] = (balances[e.paidBy] ?? 0) + e.amount;
            
            // Everyone involved in the split (including the payer if they are in splitAmong)
            // owes their per-person share.
            for (final member in e.splitAmong) {
              balances[member] = (balances[member] ?? 0) - perPerson;
            }
          }

          // Clean floating point errors (e.g., 0.00000001 -> 0)
          final Map<String, double> cleanBalances = {};
          balances.forEach((key, value) {
            if (value.abs() > 0.01) {
              cleanBalances[key] = value;
            }
          });

          final settlements = _calculateSettlements(cleanBalances);

          return TabBarView(
            controller: _tabController,
            children: [
              // Expenses Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryCard(status, isDark, accentColor),
                    const SizedBox(height: 16),
                    Text(
                      'Transactions',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: expenses.isEmpty
                          ? EmptyStateView(
                              icon: Icons.receipt_long_outlined,
                              title: 'No Expenses Yet',
                              description: 'Track your spending. Add your first expense.',
                              primaryActionLabel: 'Add Expense',
                              onPrimaryAction: () => ExpenseFormOverlay.show(context),
                            )
                          : ListView.builder(
                              itemCount: expenses.length,
                              itemBuilder: (context, index) {
                                final expense = expenses[index];
                                return _ExpenseTile(
                                  expense: expense,
                                  isDark: isDark,
                                  textColor: textColor,
                                  subtextColor: subtextColor,
                                  cardColor: cardColor,
                                  accentColor: accentColor,
                                  onDelete: () {
                                    ref.read(expenseControllerProvider.notifier).deleteExpense(expense.id);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              // Settlements Tab
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: settlements.isEmpty
                    ? Center(
                        child: Text(
                          'Everyone is settled up! 🎉',
                          style: TextStyle(color: subtextColor, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: settlements.length,
                        itemBuilder: (context, index) {
                          final s = settlements[index];
                          return Card(
                            color: cardColor,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: accentColor.withValues(alpha: 0.2),
                                child: Icon(Icons.person, color: accentColor),
                              ),
                              title: Text(
                                '${s.from} owes ${s.to}',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                '₹${s.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => ErrorRecoveryView(
          title: 'Unable to Load Budget',
          description: 'We couldn\'t load your expenses. Please verify your connection and try again.',
          onRetry: () {
            ref.invalidate(expenseControllerProvider);
          },
        ),
      ),
    ));
  }

  Widget _buildSummaryCard(dynamic status, bool isDark, Color accentColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D9488), const Color(0xFF7C3AED)]
              : [const Color(0xFF0D9488), const Color(0xFF06B6D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Spent',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            '₹${status.currentSpent.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Budget: ₹${status.totalBudget.toStringAsFixed(0)} • Remaining: ₹${status.remaining.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: status.percentageSpent.clamp(0.0, 1.0),
              backgroundColor: Colors.white24,
              color: status.isOverBudget
                  ? Colors.redAccent
                  : status.isWarning
                  ? Colors.orangeAccent
                  : Colors.white,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final bool isDark;
  final Color textColor;
  final Color subtextColor;
  final Color cardColor;
  final Color accentColor;
  final VoidCallback onDelete;

  const _ExpenseTile({
    required this.expense,
    required this.isDark,
    required this.textColor,
    required this.subtextColor,
    required this.cardColor,
    required this.accentColor,
    required this.onDelete,
  });

  IconData _categoryIcon(ExpenseCategory cat) {
    switch (cat) {
      case ExpenseCategory.food:
        return Icons.restaurant;
      case ExpenseCategory.transport:
        return Icons.directions_car;
      case ExpenseCategory.lodging:
        return Icons.hotel;
      case ExpenseCategory.entertainment:
        return Icons.movie;
      case ExpenseCategory.misc:
        return Icons.receipt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                _categoryIcon(expense.category),
                color: accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.description,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Paid by ${expense.paidBy}${expense.splitAmong.length > 1 ? " • Split /${expense.splitAmong.length}" : ""}',
                    style: TextStyle(color: subtextColor, fontSize: 11),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${expense.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (expense.splitAmong.length > 1)
                  Text(
                    '₹${expense.perPersonAmount.toStringAsFixed(0)}/person',
                    style: TextStyle(color: subtextColor, fontSize: 10),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
