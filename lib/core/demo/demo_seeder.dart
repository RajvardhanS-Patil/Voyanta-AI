import 'package:isar/isar.dart';
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
      
      // Inject Demo Expenses (A day in Paris)
      await isar.expenseDbs.putAll([
        ExpenseDb()
          ..id = 'exp_1'
          ..amount = 4.50
          ..currency = 'EUR'
          ..category = 'Food'
          ..date = DateTime.now()
          ..note = 'Morning Croissant at Café de Flore'
          ..isSynced = true,
        ExpenseDb()
          ..id = 'exp_2'
          ..amount = 25.00
          ..currency = 'EUR'
          ..category = 'Transport'
          ..date = DateTime.now()
          ..note = 'Metro Pass (3 Days)'
          ..isSynced = true,
        ExpenseDb()
          ..id = 'exp_3'
          ..amount = 115.00
          ..currency = 'EUR'
          ..category = 'Activities'
          ..date = DateTime.now()
          ..note = 'Louvre VIP Tour'
          ..isSynced = true,
      ]);

      // Inject Demo AI Chat History
      await isar.chatMessageDbs.putAll([
        ChatMessageDb()
          ..messageId = 'msg_1'
          ..text = 'Hello! I am in Paris and have a free afternoon. Any hidden gems near Le Marais?'
          ..sender = 'user'
          ..timestamp = DateTime.now().subtract(const Duration(minutes: 5)),
        ChatMessageDb()
          ..messageId = 'msg_2'
          ..text = 'Le Marais is fantastic! Since you have 3 hours free, I highly recommend visiting the Musée Picasso. It is less crowded than the Louvre and set in a beautiful 17th-century hôtel particulier. Would you like me to add it to your itinerary?'
          ..sender = 'assistant'
          ..timestamp = DateTime.now().subtract(const Duration(minutes: 4)),
      ]);
    });
  }
}
