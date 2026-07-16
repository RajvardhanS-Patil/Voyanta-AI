import '../../domain/entities/activity.dart';

class ActivityModel extends Activity {
  const ActivityModel({
    required super.time,
    required super.title,
    required super.description,
    required super.latitude,
    required super.longitude,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      latitude: json['latitude'] is num 
          ? (json['latitude'] as num).toDouble() 
          : double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      longitude: json['longitude'] is num 
          ? (json['longitude'] as num).toDouble() 
          : double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
    );
  }
}
