import 'package:flutter/material.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/budget_status.dart';

class BudgetProgressBar extends StatelessWidget {
  final BudgetStatus status;

  const BudgetProgressBar({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color barColor = Colors.tealAccent;
    if (status.isOverBudget) {
      barColor = Colors.redAccent;
    } else if (status.isWarning) {
      barColor = Colors.orangeAccent;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Budget', style: TextStyle(color: Colors.white70)),
            Text(
              '₹${status.currentSpent.toStringAsFixed(2)} / ₹${status.totalBudget.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth * status.percentageSpent;
              if (width > constraints.maxWidth) width = constraints.maxWidth;
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  width: width,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
