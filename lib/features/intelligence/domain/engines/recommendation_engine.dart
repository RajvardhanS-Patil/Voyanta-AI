import 'package:voyanta_ai/features/expenses/domain/entities/budget_status.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../entities/travel_recommendation.dart';
import 'weather_intelligence.dart';
import 'traffic_intelligence.dart';
import 'budget_intelligence.dart';
import 'schedule_intelligence.dart';
import 'food_intelligence.dart';
import 'safety_intelligence.dart';
import 'nearby_intelligence.dart';

class RecommendationEngine {
  final WeatherIntelligenceEngine weatherEngine;
  final TrafficIntelligenceEngine trafficEngine;
  final BudgetIntelligenceEngine budgetEngine;
  final ScheduleIntelligenceEngine scheduleEngine;
  final FoodIntelligenceEngine foodEngine;
  final SafetyIntelligenceEngine safetyEngine;
  final NearbyIntelligenceEngine nearbyEngine;

  const RecommendationEngine({
    required this.weatherEngine,
    required this.trafficEngine,
    required this.budgetEngine,
    required this.scheduleEngine,
    required this.foodEngine,
    required this.safetyEngine,
    required this.nearbyEngine,
  });

  List<TravelRecommendation> generateRecommendations({
    required JourneyState journeyState,
    required BudgetStatus budgetStatus,
    required String weatherInfo,
  }) {
    final List<TravelRecommendation> list = [];

    list.addAll(weatherEngine.analyze(journeyState, weatherInfo));
    list.addAll(trafficEngine.analyze(journeyState));
    list.addAll(budgetEngine.analyze(budgetStatus));
    list.addAll(scheduleEngine.analyze(journeyState));
    list.addAll(foodEngine.analyze(journeyState));
    list.addAll(safetyEngine.analyze(journeyState));
    list.addAll(nearbyEngine.analyze(journeyState));

    return list;
  }
}
