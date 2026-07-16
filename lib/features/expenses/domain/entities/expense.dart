enum ExpenseCategory { food, transport, lodging, entertainment, misc }

class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final DateTime date;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    String? description,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
