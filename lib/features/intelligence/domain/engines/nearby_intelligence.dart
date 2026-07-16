import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class NearbyIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    final target = journeyState.currentActivity?.title ?? '';
    if (target.contains('Empire State')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'nearby_flatiron',
          type: RecommendationType.nearby,
          severity: AlertSeverity.info,
          title: 'Photo Spot: Flatiron Building',
          description: 'The historic architectural gem is just a 12-minute walk south down 5th Ave.',
          actionLabel: 'Route There',
        ),
      );
    } else if (target.contains('Central Park')) {
      recommendations.add(
        const TravelRecommendation(
          id: 'nearby_bethesda',
          type: RecommendationType.nearby,
          severity: AlertSeverity.info,
          title: 'Hidden Gem: Bethesda Fountain',
          description: ' Bethesda Fountain and Terrace are only 250 meters ahead. Perfect scenic stop.',
        ),
      );
    }
    
    return recommendations;
  }
}
