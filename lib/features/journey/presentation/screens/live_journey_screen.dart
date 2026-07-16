import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:voyanta_ai/features/maps/presentation/widgets/itinerary_map_view.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';

class LiveJourneyScreen extends ConsumerStatefulWidget {
  const LiveJourneyScreen({super.key});

  @override
  ConsumerState<LiveJourneyScreen> createState() => _LiveJourneyScreenState();
}

class _LiveJourneyScreenState extends ConsumerState<LiveJourneyScreen> {
  @override
  void initState() {
    super.initState();
    // Bootstrap the Journey Engine with a test itinerary on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(journeyControllerProvider.notifier)
          .startJourney(
            const TripItinerary(
              dayNumber: 1,
              theme: 'City Highlights',
              activities: [
                Activity(
                  time: '10:00 AM',
                  title: 'Empire State Building',
                  description: 'Observation deck',
                  latitude: 40.7484,
                  longitude: -73.9857,
                ),
                Activity(
                  time: '1:00 PM',
                  title: 'Central Park',
                  description: 'Lunch and walk',
                  latitude: 40.7812,
                  longitude: -73.9665,
                ),
              ],
            ),
          );
    });
  }

  Future<void> _launchMapsIntent(double lat, double lng) async {
    final String googleMapsUrl = 'google.navigation:q=$lat,$lng&mode=d';
    final String appleMapsUrl = 'maps://?daddr=$lat,$lng&dirflg=d';

    final uri = Uri.parse(Platform.isIOS ? appleMapsUrl : googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Fallback gracefully to the web platform
      final webUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      );
      await launchUrl(webUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final journeyState = ref.watch(journeyControllerProvider);
    final isArrived = journeyState.status == JourneyStatus.arrived;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Live Journey',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Leverage the existing offline maps integration
          const ItineraryMapView(),

          // Glassmorphic real-time overlay
          if (journeyState.currentActivity != null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: _buildGlassPanel(journeyState, isArrived),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel(JourneyState state, bool isArrived) {
    final activity = state.currentActivity!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isArrived ? 'Arrived!' : 'Heading to',
            style: TextStyle(
              color: isArrived ? Colors.tealAccent : Colors.white54,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            activity.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${(state.distanceToNextMeters / 1000).toStringAsFixed(1)} km away • ${state.etaMinutes} min',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.navigation),
                  label: const Text('Navigate'),
                  onPressed: () =>
                      _launchMapsIntent(activity.latitude, activity.longitude),
                ),
              ),
              if (isArrived) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white12,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Next'),
                    onPressed: () {
                      ref
                          .read(journeyControllerProvider.notifier)
                          .advanceToNextActivity();
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
