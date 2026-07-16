class CompanionContext {
  final String activeTripDestination;
  final String activeTripTheme;
  final int activeTripDayNumber;
  final List<String> completedActivityTitles;
  final String nextActivityTitle;
  final double nextActivityDistanceKm;
  final int nextActivityEtaMinutes;
  final double totalBudget;
  final double totalSpent;
  final String weatherInfo;

  const CompanionContext({
    required this.activeTripDestination,
    required this.activeTripTheme,
    required this.activeTripDayNumber,
    required this.completedActivityTitles,
    required this.nextActivityTitle,
    required this.nextActivityDistanceKm,
    required this.nextActivityEtaMinutes,
    required this.totalBudget,
    required this.totalSpent,
    required this.weatherInfo,
  });

  CompanionContext copyWith({
    String? activeTripDestination,
    String? activeTripTheme,
    int? activeTripDayNumber,
    List<String>? completedActivityTitles,
    String? nextActivityTitle,
    double? nextActivityDistanceKm,
    int? nextActivityEtaMinutes,
    double? totalBudget,
    double? totalSpent,
    String? weatherInfo,
  }) {
    return CompanionContext(
      activeTripDestination: activeTripDestination ?? this.activeTripDestination,
      activeTripTheme: activeTripTheme ?? this.activeTripTheme,
      activeTripDayNumber: activeTripDayNumber ?? this.activeTripDayNumber,
      completedActivityTitles: completedActivityTitles ?? this.completedActivityTitles,
      nextActivityTitle: nextActivityTitle ?? this.nextActivityTitle,
      nextActivityDistanceKm: nextActivityDistanceKm ?? this.nextActivityDistanceKm,
      nextActivityEtaMinutes: nextActivityEtaMinutes ?? this.nextActivityEtaMinutes,
      totalBudget: totalBudget ?? this.totalBudget,
      totalSpent: totalSpent ?? this.totalSpent,
      weatherInfo: weatherInfo ?? this.weatherInfo,
    );
  }
}
