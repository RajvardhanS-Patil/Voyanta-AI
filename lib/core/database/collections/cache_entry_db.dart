import 'package:isar/isar.dart';

part 'cache_entry_db.g.dart';

@collection
class CacheEntryDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String cacheKey;

  late String valueJson;
  late DateTime expiresAt;
}
