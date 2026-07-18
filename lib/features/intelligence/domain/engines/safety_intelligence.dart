import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class SafetyIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    // Output essential location security metrics and phone hotlines
    recommendations.add(
      const TravelRecommendation(
        id: 'safety_local_emergency',
        type: RecommendationType.safety,
        severity: AlertSeverity.info,
        title: 'Emergency Safety Guidelines',
        description:
            'New York City local hotlines: Dial 911 for emergency support. Dial 311 for local assistance.',
      ),
    );

    return recommendations;
  }
}
