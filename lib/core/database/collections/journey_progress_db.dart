import 'package:isar/isar.dart';

part 'journey_progress_db.g.dart';

@collection
class JourneyProgressDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String tripId;

  late int currentActivityIndex;
  late double currentLatitude;
  late double currentLongitude;
  late String status;
  late DateTime lastUpdated;
  late String? activeItineraryJson;
}
