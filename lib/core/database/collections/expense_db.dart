import 'package:isar/isar.dart';

part 'expense_db.g.dart';

@collection
class ExpenseDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String expenseId;

  late double amount;
  late String category;
  late String description;
  late DateTime date;

  @Index()
  late bool isSynced;
}
