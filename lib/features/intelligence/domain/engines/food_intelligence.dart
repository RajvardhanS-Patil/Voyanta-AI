import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class FoodIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    final target = journeyState.currentActivity?.title ?? '';
    if (target.contains('Red Fort')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'food_chandni_chowk',
          type: RecommendationType.food,
          severity: AlertSeverity.info,
          title: 'Nearby Dining: Paranthe Wali Gali',
          description:
              'Head into the alleys of Chandni Chowk for legendary stuffed paranthas and jalebis!',
        ),
      );
    } else if (target.contains('India Gate')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'food_india_gate',
          type: RecommendationType.food,
          severity: AlertSeverity.info,
          title: 'Nearby Dining: Pandara Road',
          description:
              'A short drive away, Pandara Road offers some of the best North Indian cuisine (like Gulati) in the city.',
        ),
      );
    }

    return recommendations;
  }
}
