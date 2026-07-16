import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class TrafficIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    final distanceMeters = journeyState.distanceToNextMeters;
    // Suggest walking if distance is under 2.5km and traffic makes transit slow
    if (distanceMeters > 0 && distanceMeters < 2500 && journeyState.etaMinutes > 12) {
      recommendations.add(
        const TravelRecommendation(
          id: 'traffic_transit_walk',
          type: RecommendationType.transit,
          severity: AlertSeverity.info,
          title: 'Heavy Gridlock Detected',
          description: 'High vehicular traffic ahead. Walking to the next activity is estimated to save 10 minutes.',
          actionLabel: 'Walk Route',
        ),
      );
    }
    
    return recommendations;
  }
}
