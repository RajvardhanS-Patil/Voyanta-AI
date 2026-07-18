import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class FoodIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    final target = journeyState.currentActivity?.title ?? '';
    if (target.contains('Central Park')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'food_central_park',
          type: RecommendationType.food,
          severity: AlertSeverity.info,
          title: 'Nearby Dining: Central Park',
          description:
              'Try "Tavern on the Green" for iconic park dining, or visit "The Loeb Boathouse" deck.',
        ),
      );
    } else if (target.contains('Empire State')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'food_empire_state',
          type: RecommendationType.food,
          severity: AlertSeverity.info,
          title: 'Nearby Dining: Empire State',
          description:
              'Head to "Koreatown" on 32nd St for authentic barbecue spots just 2 blocks south.',
        ),
      );
    }

    return recommendations;
  }
}
