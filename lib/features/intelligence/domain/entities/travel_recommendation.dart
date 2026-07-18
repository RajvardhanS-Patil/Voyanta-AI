enum RecommendationType {
  weather,
  budget,
  schedule,
  food,
  safety,
  transit,
  nearby,
}

enum AlertSeverity { info, warning, critical }

class TravelRecommendation {
  final String id;
  final RecommendationType type;
  final AlertSeverity severity;
  final String title;
  final String description;
  final String? actionLabel;

  const TravelRecommendation({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.description,
    this.actionLabel,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TravelRecommendation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          severity == other.severity &&
          title == other.title &&
          description == other.description &&
          actionLabel == other.actionLabel;

  @override
  int get hashCode =>
      id.hashCode ^
      type.hashCode ^
      severity.hashCode ^
      title.hashCode ^
      description.hashCode ^
      actionLabel.hashCode;
}
