class BudgetStatus {
  final double totalBudget;
  final double currentSpent;
  
  const BudgetStatus({
    required this.totalBudget,
    required this.currentSpent,
  });

  double get remaining => totalBudget - currentSpent;
  double get percentageSpent => totalBudget == 0 ? 0 : currentSpent / totalBudget;
  
  bool get isWarning => percentageSpent >= 0.8 && percentageSpent < 1.0;
  bool get isOverBudget => percentageSpent >= 1.0;
}
