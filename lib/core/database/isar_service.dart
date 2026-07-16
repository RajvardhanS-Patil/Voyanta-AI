import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'collections/user_profile_db.dart';
import 'collections/trip_db.dart';
import 'collections/expense_db.dart';
import 'collections/journey_progress_db.dart';
import 'collections/chat_message_db.dart';
import 'collections/recommendation_db.dart';
import 'collections/cache_entry_db.dart';
import 'collections/sync_queue_db.dart';

class IsarService {
  static late final Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        UserProfileDbSchema,
        TripDbSchema,
        ExpenseDbSchema,
        JourneyProgressDbSchema,
        ChatMessageDbSchema,
        RecommendationDbSchema,
        CacheEntryDbSchema,
        SyncQueueDbSchema,
      ],
      directory: dir.path,
    );
  }
}
