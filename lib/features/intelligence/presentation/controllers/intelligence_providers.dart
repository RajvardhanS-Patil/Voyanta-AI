import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/services/weather_provider.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_controller.dart';
import 'package:voyanta_ai/features/expenses/presentation/controllers/expense_providers.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import '../../domain/engines/budget_intelligence.dart';
import '../../domain/engines/food_intelligence.dart';
import '../../domain/engines/nearby_intelligence.dart';
import '../../domain/engines/recommendation_engine.dart';
import '../../domain/engines/safety_intelligence.dart';
import '../../domain/engines/schedule_intelligence.dart';
import '../../domain/engines/traffic_intelligence.dart';
import '../../domain/engines/weather_intelligence.dart';
import '../../domain/entities/travel_recommendation.dart';

final weatherIntelligenceProvider = Provider(
  (ref) => WeatherIntelligenceEngine(),
);
final trafficIntelligenceProvider = Provider(
  (ref) => TrafficIntelligenceEngine(),
);
final budgetIntelligenceProvider = Provider(
  (ref) => BudgetIntelligenceEngine(),
);
final scheduleIntelligenceProvider = Provider(
  (ref) => ScheduleIntelligenceEngine(),
);
final foodIntelligenceProvider = Provider((ref) => FoodIntelligenceEngine());
final safetyIntelligenceProvider = Provider(
  (ref) => SafetyIntelligenceEngine(),
);
final nearbyIntelligenceProvider = Provider(
  (ref) => NearbyIntelligenceEngine(),
);

final recommendationEngineProvider = Provider<RecommendationEngine>((ref) {
  return RecommendationEngine(
    weatherEngine: ref.read(weatherIntelligenceProvider),
    trafficEngine: ref.read(trafficIntelligenceProvider),
    budgetEngine: ref.read(budgetIntelligenceProvider),
    scheduleEngine: ref.read(scheduleIntelligenceProvider),
    foodEngine: ref.read(foodIntelligenceProvider),
    safetyEngine: ref.read(safetyIntelligenceProvider),
    nearbyEngine: ref.read(nearbyIntelligenceProvider),
  );
});

// Listens to Journey, Expenses, and Weather details to return active recommendations
final activeRecommendationsProvider = Provider<List<TravelRecommendation>>((
  ref,
) {
  final journey = ref.watch(journeyControllerProvider);
  final expenses = ref.watch(expenseControllerProvider).value ?? [];
  final tripMeta = ref.watch(tripMetaControllerProvider).value;
  final budgetCalculator = ref.watch(calculateBudgetHealthUseCaseProvider);

  final totalBudget = tripMeta?.totalBudget ?? 5000.0;
  final budgetStatus = budgetCalculator(expenses, totalBudget: totalBudget);
  final engine = ref.read(recommendationEngineProvider);

  // Use live weather condition string for intelligent recommendation engine
  final liveWeather = ref.watch(destinationWeatherProvider);
  final weatherInfo = liveWeather.value?.description ?? "Clear";

  final recommendations = engine.generateRecommendations(
    journeyState: journey,
    budgetStatus: budgetStatus,
    weatherInfo: weatherInfo,
  );
  
  // If no critical alerts are generated, provide a helpful contextual tip
  // so the intelligence bar is always visible and useful.
  if (recommendations.isEmpty) {
    final title = journey.currentActivity?.title ?? journey.activeItinerary?.activities.firstOrNull?.title ?? 'Your Destination';
    recommendations.add(
      TravelRecommendation(
        id: 'tip_1',
        type: RecommendationType.nearby,
        severity: AlertSeverity.info,
        title: 'Enjoy $title!',
        description: 'Conditions are perfect right now. Have a great time exploring!',
      ),
    );
  }

  return recommendations;
});
