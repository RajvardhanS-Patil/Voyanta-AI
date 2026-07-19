import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/database/collections/expense_db.dart';
import 'package:voyanta_ai/core/database/collections/chat_message_db.dart';

class DemoSeeder {
  static Future<void> seedDatabase() async {
    final isar = IsarService.isar;

    // Clear everything
    await isar.writeTxn(() async {
      await isar.expenseDbs.clear();
      await isar.chatMessageDbs.clear();

      // Inject Demo Expenses (A day in Jaipur)
      await isar.expenseDbs.putAll([
        ExpenseDb()
          ..expenseId = 'exp_1'
          ..amount = 40.0
          ..category = 'Food'
          ..date = DateTime.now()
          ..description = 'Morning chai & kachori at Rawat Mishthan Bhandar'
          ..isSynced = true,
        ExpenseDb()
          ..expenseId = 'exp_2'
          ..amount = 250.0
          ..category = 'Transport'
          ..date = DateTime.now()
          ..description = 'Auto-rickshaw to Amber Fort'
          ..isSynced = true,
        ExpenseDb()
          ..expenseId = 'exp_3'
          ..amount = 500.0
          ..category = 'Activities'
          ..date = DateTime.now()
          ..description = 'Amber Fort entry ticket (with guide)'
          ..isSynced = true,
      ]);

      // Inject Demo AI Chat History
      await isar.chatMessageDbs.putAll([
        ChatMessageDb()
          ..messageId = 'msg_1'
          ..text =
              'Hello! I am in Jaipur and have a free afternoon. Any hidden gems near Hawa Mahal?'
          ..sender = 'user'
          ..timestamp = DateTime.now().subtract(const Duration(minutes: 5)),
        ChatMessageDb()
          ..messageId = 'msg_2'
          ..text =
              'Great choice! Since you are near Hawa Mahal, I highly recommend visiting Jantar Mantar — it is just a 5-minute walk away. The astronomical instruments are fascinating and it is a UNESCO World Heritage Site. Would you like me to add it to your itinerary?'
          ..sender = 'assistant'
          ..timestamp = DateTime.now().subtract(const Duration(minutes: 4)),
      ]);
    });
  }
}
