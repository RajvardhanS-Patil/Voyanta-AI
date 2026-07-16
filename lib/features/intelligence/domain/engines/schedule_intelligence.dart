import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';

class ScheduleIntelligenceEngine {
  List<TravelRecommendation> analyze(JourneyState journeyState) {
    final List<TravelRecommendation> recommendations = [];
    if (!journeyState.hasActiveJourney) return recommendations;

    // Trigger warning if next destination ETA threatens timing bounds
    if (journeyState.etaMinutes > 25) {
      recommendations.add(
        const TravelRecommendation(
          id: 'schedule_delay_alert',
          type: RecommendationType.schedule,
          severity: AlertSeverity.warning,
          title: 'Schedule Timing Alert',
          description: 'ETA to destination is high. You risk running late for upcoming scheduled openings. Reorder itinerary if needed.',
          actionLabel: 'Reschedule',
        ),
      );
    }
    
    return recommendations;
  }
}
