import 'package:flutter/material.dart';
import 'package:voyanta_ai/core/ux/empty_state_view.dart';

class TripPlannerScreen extends StatelessWidget {
  const TripPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Trip Planner',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        ),
      ),
      body: const EmptyStateView(
        icon: Icons.map_outlined,
        title: 'Plan Your Next Adventure',
        description: 'AI-powered trip generation is coming in the next update. Stay tuned!',
      ),
    );
  }
}
