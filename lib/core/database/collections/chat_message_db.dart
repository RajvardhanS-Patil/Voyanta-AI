import 'package:isar/isar.dart';

part 'chat_message_db.g.dart';

@collection
class ChatMessageDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String messageId;

  late String text;
  late String sender;
  late DateTime timestamp;
}
