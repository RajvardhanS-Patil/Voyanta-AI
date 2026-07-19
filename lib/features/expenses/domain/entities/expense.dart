enum ExpenseCategory { food, transport, lodging, entertainment, misc }

class Expense {
  final String id;
  final double amount;
  final ExpenseCategory category;
  final String description;
  final DateTime date;
  final String paidBy;
  final List<String> splitAmong;

  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    this.paidBy = 'Me',
    this.splitAmong = const ['Me'],
  });

  double get perPersonAmount =>
      splitAmong.isEmpty ? amount : amount / splitAmong.length;

  Expense copyWith({
    String? id,
    double? amount,
    ExpenseCategory? category,
    String? description,
    DateTime? date,
    String? paidBy,
    List<String>? splitAmong,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      paidBy: paidBy ?? this.paidBy,
      splitAmong: splitAmong ?? this.splitAmong,
    );
  }
}
