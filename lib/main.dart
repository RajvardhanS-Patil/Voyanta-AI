import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/supabase_client.dart';
import 'core/network/gemini_client.dart';
import 'features/maps/presentation/screens/trip_map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Networks
  await SupabaseClientManager.initialize();
  GeminiClientManager.initialize();

  runApp(const ProviderScope(child: VoyantaApp()));
}

class VoyantaApp extends StatelessWidget {
  const VoyantaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voyanta AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TripMapScreen(),
    );
  }
}
