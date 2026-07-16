import 'package:flutter_test/flutter_test.dart';
import 'package:voyanta_ai/features/expenses/domain/entities/budget_status.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';
import 'package:voyanta_ai/features/intelligence/domain/entities/travel_recommendation.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/weather_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/traffic_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/budget_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/schedule_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/food_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/safety_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/nearby_intelligence.dart';
import 'package:voyanta_ai/features/intelligence/domain/engines/recommendation_engine.dart';

void main() {
  group('Smart Travel Intelligence Engines', () {
    late WeatherIntelligenceEngine weatherEngine;
    late TrafficIntelligenceEngine trafficEngine;
    late BudgetIntelligenceEngine budgetEngine;
    late ScheduleIntelligenceEngine scheduleEngine;
    late FoodIntelligenceEngine foodEngine;
    late SafetyIntelligenceEngine safetyEngine;
    late NearbyIntelligenceEngine nearbyEngine;
    late RecommendationEngine recommendationEngine;

    const testItinerary = TripItinerary(
      dayNumber: 1,
      theme: 'Theme',
      activities: [
        Activity(time: '10:00 AM', title: 'Central Park', description: 'Desc', latitude: 40.7, longitude: -74.0),
      ],
    );

    setUp(() {
      weatherEngine = WeatherIntelligenceEngine();
      trafficEngine = TrafficIntelligenceEngine();
      budgetEngine = BudgetIntelligenceEngine();
      scheduleEngine = ScheduleIntelligenceEngine();
      foodEngine = FoodIntelligenceEngine();
      safetyEngine = SafetyIntelligenceEngine();
      nearbyEngine = NearbyIntelligenceEngine();

      recommendationEngine = RecommendationEngine(
        weatherEngine: weatherEngine,
        trafficEngine: trafficEngine,
        budgetEngine: budgetEngine,
        scheduleEngine: scheduleEngine,
        foodEngine: foodEngine,
        safetyEngine: safetyEngine,
        nearbyEngine: nearbyEngine,
      );
    });

    test('WeatherIntelligence should suggest indoor swap if rain is forecasted', () {
      const journey = JourneyState(
        activeItinerary: testItinerary,
        status: JourneyStatus.navigating,
      );
      final recs = weatherEngine.analyze(journey, 'Heavy Rain Showers');
      expect(recs.length, 1);
      expect(recs.first.type, RecommendationType.weather);
      expect(recs.first.severity, AlertSeverity.warning);
    });

    test('BudgetIntelligence should trigger critical warning if budget limit exceeded', () {
      const budgetStatus = BudgetStatus(totalBudget: 1000.0, currentSpent: 1200.0);
      final recs = budgetEngine.analyze(budgetStatus);
      expect(recs.length, 1);
      expect(recs.first.type, RecommendationType.budget);
      expect(recs.first.severity, AlertSeverity.critical);
    });

    test('TrafficIntelligence should suggest walking if distance is short and delay is high', () {
      const journey = JourneyState(
        activeItinerary: testItinerary,
        status: JourneyStatus.navigating,
        distanceToNextMeters: 1200,
        etaMinutes: 20,
      );
      final recs = trafficEngine.analyze(journey);
      expect(recs.length, 1);
      expect(recs.first.type, RecommendationType.transit);
      expect(recs.first.severity, AlertSeverity.info);
    });

    test('RecommendationEngine should aggregate all engine warnings into list', () {
      const journey = JourneyState(
        activeItinerary: testItinerary,
        status: JourneyStatus.navigating,
        distanceToNextMeters: 1200,
        etaMinutes: 20,
      );
      const budgetStatus = BudgetStatus(totalBudget: 1000.0, currentSpent: 1200.0);

      final all = recommendationEngine.generateRecommendations(
        journeyState: journey,
        budgetStatus: budgetStatus,
        weatherInfo: 'Rainy Showers',
      );

      // Verify that weather, transit, and budget aggregations are mapped
      expect(all.any((r) => r.type == RecommendationType.weather), true);
      expect(all.any((r) => r.type == RecommendationType.transit), true);
      expect(all.any((r) => r.type == RecommendationType.budget), true);
    });
  });
}
