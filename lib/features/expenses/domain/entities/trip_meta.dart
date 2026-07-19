class TripMeta {
  final double totalBudget;
  final List<String> members;

  const TripMeta({
    required this.totalBudget,
    required this.members,
  });

  TripMeta copyWith({
    double? totalBudget,
    List<String>? members,
  }) {
    return TripMeta(
      totalBudget: totalBudget ?? this.totalBudget,
      members: members ?? this.members,
    );
  }
}
