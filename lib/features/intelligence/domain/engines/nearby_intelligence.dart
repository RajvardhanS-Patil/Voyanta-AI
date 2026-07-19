import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class NearbyIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    final target = journeyState.currentActivity?.title ?? '';
    if (target.contains('India Gate')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'nearby_national_museum',
          type: RecommendationType.nearby,
          severity: AlertSeverity.info,
          title: 'Nearby: National Museum',
          description:
              'The largest museum in India is just a short 10-minute walk away down Janpath.',
          actionLabel: 'Route There',
        ),
      );
    } else if (target.contains('Red Fort')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'nearby_chandni_chowk',
          type: RecommendationType.nearby,
          severity: AlertSeverity.info,
          title: 'Hidden Gem: Chandni Chowk',
          description:
              'Step right across the street into one of the oldest and busiest markets in Old Delhi!',
        ),
      );
    }

    return recommendations;
  }
}
