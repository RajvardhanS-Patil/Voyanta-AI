import 'package:isar/isar.dart';

part 'recommendation_db.g.dart';

@collection
class RecommendationDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String recommendationId;

  late String type;
  late String severity;
  late String title;
  late String description;
  late String? actionLabel;
}
