import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class WeatherIntelligenceEngine {
  List<TravelRecommendation> analyze(
    JourneyState journeyState,
    String weatherInfo,
  ) {
    final List<TravelRecommendation> recommendations = [];

    if (!journeyState.hasActiveJourney) return recommendations;

    final info = weatherInfo.toLowerCase();
    if (info.contains('rain') ||
        info.contains('storm') ||
        info.contains('shower')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'weather_rain_alert',
          type: RecommendationType.weather,
          severity: AlertSeverity.warning,
          title: 'Rain Warning',
          description:
              'Rain showers detected. Consider swapping to indoor museum exhibits early.',
          actionLabel: 'Adjust Plan',
        ),
      );
    } else if (info.contains('hot') ||
        info.contains('heat') ||
        info.contains('sunny')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'weather_heat_alert',
          type: RecommendationType.weather,
          severity: AlertSeverity.info,
          title: 'High Heat Index',
          description:
              'High UV index afternoon. Stay hydrated and plan indoor rest breaks.',
        ),
      );
    }

    return recommendations;
  }
}
