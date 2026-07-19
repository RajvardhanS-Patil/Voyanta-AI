import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/expense.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';

class ExpenseFormOverlay extends ConsumerStatefulWidget {
  const ExpenseFormOverlay({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExpenseFormOverlay(),
    );
  }

  @override
  ConsumerState<ExpenseFormOverlay> createState() => _ExpenseFormOverlayState();
}

class _ExpenseFormOverlayState extends ConsumerState<ExpenseFormOverlay> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  ExpenseCategory _category = ExpenseCategory.misc;
  String _paidBy = 'Me';
  final List<String> _splitAmong = ['Me'];
  bool _splitEqually = true;

  void _submit() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    final tripMeta = ref.read(tripMetaControllerProvider).value;
    final allMembers = tripMeta?.members ?? ['Me'];

    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      category: _category,
      description: _descController.text.isNotEmpty
          ? _descController.text
          : 'New Expense',
      date: DateTime.now(),
      paidBy: _paidBy,
      splitAmong: _splitEqually ? List.from(allMembers) : List.from(_splitAmong),
    );

    ref.read(expenseControllerProvider.notifier).addExpense(expense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final accentColor = isDark ? Colors.tealAccent : const Color(0xFF0D9488);
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: borderColor),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: subtextColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Add Expense',
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Amount
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                prefixText: '₹ ',
                prefixStyle: TextStyle(
                  color: accentColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                hintText: '0.00',
                hintStyle: TextStyle(color: subtextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: _descController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: subtextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Category
            DropdownButtonFormField<ExpenseCategory>(
              initialValue: _category,
              dropdownColor: bgColor,
              style: TextStyle(color: textColor),
              items: ExpenseCategory.values.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
              decoration: InputDecoration(
                labelText: 'Category',
                labelStyle: TextStyle(color: subtextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Paid by
            Text(
              'Paid by',
              style: TextStyle(color: subtextColor, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Consumer(builder: (context, ref, child) {
              final tripMeta = ref.watch(tripMetaControllerProvider).value;
              final members = tripMeta?.members ?? ['Me'];
              
              if (!members.contains(_paidBy)) {
                _paidBy = members.first;
              }

              return Wrap(
                spacing: 8,
                children: members.map((m) {
                  final isSelected = _paidBy == m;
                  return ChoiceChip(
                    label: Text(m),
                    selected: isSelected,
                    selectedColor: accentColor.withValues(alpha: 0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? accentColor : textColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                    onSelected: (_) => setState(() => _paidBy = m),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),

            // Split toggle
            Row(
              children: [
                Text(
                  'Split equally',
                  style: TextStyle(color: subtextColor, fontSize: 13),
                ),
                const Spacer(),
                Switch(
                  value: _splitEqually,
                  activeThumbColor: accentColor,
                  onChanged: (val) => setState(() => _splitEqually = val),
                ),
              ],
            ),

            if (!_splitEqually) ...[
              const SizedBox(height: 8),
              Text(
                'Split among:',
                style: TextStyle(color: subtextColor, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Consumer(builder: (context, ref, child) {
                final tripMeta = ref.watch(tripMetaControllerProvider).value;
                final members = tripMeta?.members ?? ['Me'];
                
                return Wrap(
                  spacing: 8,
                  children: members.map((m) {
                    final isSelected = _splitAmong.contains(m);
                    return FilterChip(
                      label: Text(m),
                      selected: isSelected,
                      selectedColor: accentColor.withValues(alpha: 0.3),
                      checkmarkColor: accentColor,
                      labelStyle: TextStyle(
                        color: isSelected ? accentColor : textColor,
                      ),
                      backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _splitAmong.add(m);
                          } else {
                            _splitAmong.remove(m);
                          }
                        });
                      },
                    );
                  }).toList(),
                );
              }),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'Add Expense',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
