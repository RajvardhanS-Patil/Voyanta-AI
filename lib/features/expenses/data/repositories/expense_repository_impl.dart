import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/expense_db.dart';
import 'package:voyanta_ai/core/database/collections/sync_queue_db.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  @override
  Future<List<Expense>> getExpenses() async {
    final list = await IsarService.isar.expenseDbs.where().sortByDateDesc().findAll();
    return list.map((db) {
      return Expense(
        id: db.expenseId,
        amount: db.amount,
        category: ExpenseCategory.values.firstWhere(
          (c) => c.name == db.category,
          orElse: () => ExpenseCategory.food,
        ),
        description: db.description,
        date: db.date,
      );
    }).toList();
  }

  @override
  Future<void> addExpense(Expense expense) async {
    // Add locally to Isar first
    final db = ExpenseDb()
      ..expenseId = expense.id
      ..amount = expense.amount
      ..category = expense.category.name
      ..description = expense.description
      ..date = expense.date
      ..isSynced = false;

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.expenseDbs.put(db);
    });

    // Add to local offline Sync Queue
    final queueItem = SyncQueueDb()
      ..operationId = DateTime.now().millisecondsSinceEpoch.toString()
      ..type = 'add_expense'
      ..payloadJson = jsonEncode({
        'expenseId': expense.id,
        'amount': expense.amount,
        'category': expense.category.name,
        'description': expense.description,
        'date': expense.date.toIso8601String(),
      })
      ..timestamp = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.syncQueueDbs.put(queueItem);
    });
  }

  @override
  Future<void> deleteExpense(String id) async {
    final entry = await IsarService.isar.expenseDbs.filter().expenseIdEqualTo(id).findFirst();
    if (entry != null) {
      await IsarService.isar.writeTxn(() async {
        await IsarService.isar.expenseDbs.delete(entry.id);
      });
    }

    // Add to local offline Sync Queue
    final queueItem = SyncQueueDb()
      ..operationId = DateTime.now().millisecondsSinceEpoch.toString()
      ..type = 'delete_expense'
      ..payloadJson = jsonEncode({
        'expenseId': id,
      })
      ..timestamp = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.syncQueueDbs.put(queueItem);
    });
  }
}
