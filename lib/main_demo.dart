import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:voyanta_ai/core/database/isar_service.dart';
import 'package:voyanta_ai/core/demo/demo_seeder.dart';
import 'package:voyanta_ai/main.dart';
import 'package:voyanta_ai/core/observability/observability_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load dev environment
  await dotenv.load(fileName: ".env.dev");

  // Initialize standard services
  await IsarService.initialize();
  ObservabilityService.initialize(Environment.dev);

  // Drop and re-seed the local database for Demo Mode
  await DemoSeeder.seedDatabase();

  ObservabilityService.trackEvent('app_launched_demo_mode');

  runApp(const ProviderScope(child: VoyantaApp()));
}
