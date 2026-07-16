import 'package:flutter_riverpod/flutter_riverpod.dart';
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

final weatherIntelligenceProvider = Provider((ref) => WeatherIntelligenceEngine());
final trafficIntelligenceProvider = Provider((ref) => TrafficIntelligenceEngine());
final budgetIntelligenceProvider = Provider((ref) => BudgetIntelligenceEngine());
final scheduleIntelligenceProvider = Provider((ref) => ScheduleIntelligenceEngine());
final foodIntelligenceProvider = Provider((ref) => FoodIntelligenceEngine());
final safetyIntelligenceProvider = Provider((ref) => SafetyIntelligenceEngine());
final nearbyIntelligenceProvider = Provider((ref) => NearbyIntelligenceEngine());

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
final activeRecommendationsProvider = Provider<List<TravelRecommendation>>((ref) {
  final journey = ref.watch(journeyControllerProvider);
  final expenses = ref.watch(expenseControllerProvider).value ?? [];
  final budgetCalculator = ref.watch(calculateBudgetHealthUseCaseProvider);
  
  final budgetStatus = budgetCalculator(expenses);
  final engine = ref.read(recommendationEngineProvider);

  // Seed default weather state to trigger proactive warning cards for demonstration
  const weatherInfo = "Showers & Rainy"; 

  return engine.generateRecommendations(
    journeyState: journey,
    budgetStatus: budgetStatus,
    weatherInfo: weatherInfo,
  );
});
