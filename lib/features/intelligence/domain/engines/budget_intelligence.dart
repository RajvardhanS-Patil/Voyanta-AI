import 'package:voyanta_ai/features/expenses/domain/entities/budget_status.dart';
import '../entities/travel_recommendation.dart';

class BudgetIntelligenceEngine {
  List<TravelRecommendation> analyze(BudgetStatus budgetStatus) {
    final List<TravelRecommendation> recommendations = [];
    
    if (budgetStatus.isOverBudget) {
      recommendations.add(
        TravelRecommendation(
          id: 'budget_overlimit_alert',
          type: RecommendationType.budget,
          severity: AlertSeverity.critical,
          title: 'Budget Threshold Exceeded',
          description: 'You are currently over budget by \$${(budgetStatus.currentSpent - budgetStatus.totalBudget).toStringAsFixed(2)}. Recommend choosing free activities today.',
        ),
      );
    } else if (budgetStatus.isWarning) {
      recommendations.add(
        TravelRecommendation(
          id: 'budget_warning_alert',
          type: RecommendationType.budget,
          severity: AlertSeverity.warning,
          title: 'Approaching Budget Cap',
          description: 'You have utilized ${((budgetStatus.percentageSpent) * 100).toStringAsFixed(0)}% of your trip fund. Recommend budget-friendly dining.',
        ),
      );
    }
    
    return recommendations;
  }
}
