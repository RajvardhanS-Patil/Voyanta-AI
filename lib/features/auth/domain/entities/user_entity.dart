class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ avatarUrl.hashCode;
}
