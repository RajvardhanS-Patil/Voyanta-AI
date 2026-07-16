class Activity {
  final String time;
  final String title;
  final String description;
  final double latitude;
  final double longitude;

  const Activity({
    required this.time,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          title == other.title &&
          description == other.description &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode =>
      time.hashCode ^
      title.hashCode ^
      description.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
}
