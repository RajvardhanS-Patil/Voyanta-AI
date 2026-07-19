import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/supabase_client.dart';
import 'core/network/groq_client.dart';
import 'core/database/isar_service.dart';
import 'core/observability/observability_service.dart';
import 'main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load DEV environment variables
  await dotenv.load(fileName: ".env.dev");

  ObservabilityService.initialize(Environment.dev);

  // Initialize Persistent Local Database
  await IsarService.initialize();

  // Initialize Networks
  await SupabaseClientManager.initialize();
  GroqClientManager.initialize();

  ObservabilityService.logInfo('Voyanta AI Dev Build Booted Successfully.');

  runApp(const ProviderScope(child: VoyantaApp()));
}
