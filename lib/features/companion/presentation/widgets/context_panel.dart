import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/core/services/trip_config_provider.dart';

class ContextPanel extends ConsumerWidget {
  const ContextPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyControllerProvider);
    final expenses = ref.watch(expenseControllerProvider).value ?? [];
    final tripMeta = ref.watch(tripMetaControllerProvider).value;
    final budgetCalculator = ref.watch(calculateBudgetHealthUseCaseProvider);
    
    final totalBudget = tripMeta?.totalBudget ?? 5000.0;
    final budgetStatus = budgetCalculator(expenses, totalBudget: totalBudget);
    final destination = ref.watch(tripConfigProvider);

    final nextActivity = journeyState.currentActivity?.title ?? "India Gate";
    final dist = journeyState.distanceToNextMeters / 1000.0;
    final eta = journeyState.etaMinutes;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final panelBg = isDark ? const Color(0xFF1E293B).withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.85);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.1);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white54 : Colors.black54;
    final iconColor = isDark ? Colors.white54 : Colors.black54;
    final accentText = isDark ? Colors.tealAccent : Colors.teal;
    final dividerColor = isDark ? Colors.white12 : Colors.black12;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: panelBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.dashboard_customize_outlined,
                          color: accentText,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Voyanta Smart Context',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Outfit',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Active Trip',
                        style: TextStyle(
                          color: accentText,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: dividerColor, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destination',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            destination.isNotEmpty ? destination : 'New Delhi',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining Budget',
                            style: TextStyle(
                              color: subTextColor,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '₹${budgetStatus.remaining.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: accentText,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: iconColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Next: $nextActivity (${dist > 0 ? dist.toStringAsFixed(1) : "1.8"} km | ${eta > 0 ? eta : "12"} mins)',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
