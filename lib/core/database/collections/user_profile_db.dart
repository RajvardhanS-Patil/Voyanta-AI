import 'package:isar/isar.dart';

part 'user_profile_db.g.dart';

@collection
class UserProfileDb {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;
  
  late String email;
  late String name;
}
