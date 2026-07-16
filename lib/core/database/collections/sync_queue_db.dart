import 'package:isar/isar.dart';

part 'sync_queue_db.g.dart';

@collection
class SyncQueueDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String operationId;

  late String type;
  late String payloadJson;
  late DateTime timestamp;
}
