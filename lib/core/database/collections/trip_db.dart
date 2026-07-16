import 'package:isar/isar.dart';

part 'trip_db.g.dart';

@collection
class TripDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String tripId;

  late String destination;
  late String theme;
  late int dayNumber;

  late String activitiesJson;
}
