import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:voyanta_ai/features/maps/presentation/widgets/itinerary_map_view.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/trip_itinerary.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';
import 'package:voyanta_ai/features/intelligence/presentation/controllers/intelligence_providers.dart';
import 'package:voyanta_ai/features/intelligence/presentation/widgets/recommendation_card.dart';
import 'package:voyanta_ai/core/widgets/sync_status_banner.dart';

class LiveJourneyScreen extends ConsumerStatefulWidget {
  const LiveJourneyScreen({super.key});

  @override
  ConsumerState<LiveJourneyScreen> createState() => _LiveJourneyScreenState();
}

class _LiveJourneyScreenState extends ConsumerState<LiveJourneyScreen> {
  // Demo itinerary to seed the engine
  static const _testItinerary = TripItinerary(
    dayNumber: 1,
    theme: 'Manhattan Skyline & Park Tour',
    activities: [
      Activity(
        time: '10:00 AM',
        title: 'Empire State Building',
        description: 'Take in the 360-degree observation deck views.',
        latitude: 40.7484,
        longitude: -73.9857,
      ),
      Activity(
        time: '1:00 PM',
        title: 'Central Park Carousel',
        description: 'Relaxing ride and stroll through the mall.',
        latitude: 40.7712,
        longitude: -73.9725,
      ),
      Activity(
        time: '4:00 PM',
        title: 'Metropolitan Museum of Art',
        description: 'Explore historical exhibits and rooftop sculptures.',
        latitude: 40.7794,
        longitude: -73.9632,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    // Only rebuild LiveJourneyScreen when hasActiveJourney changes
    final hasActiveJourney = ref.watch(
      journeyControllerProvider.select((state) => state.hasActiveJourney),
    );
    final recommendations = ref.watch(activeRecommendationsProvider);

    // If journey is not active, display the Start Dashboard / Permissions controller
    if (!hasActiveJourney) {
      final journeyState = ref.read(journeyControllerProvider); // read once for start screen
      return _buildStartScreen(journeyState);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.location_on, color: Colors.tealAccent),
        title: const Text(
          'Live Route Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent, size: 28),
            onPressed: () {
              ref.read(journeyControllerProvider.notifier).endJourney();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Underlying Mapbox Canvas
          const ItineraryMapView(),

          // Connectivity / action queue sync status banner
          const Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: SyncStatusBanner(),
          ),

          // Proactive Travel Intelligence Recommendations
          if (recommendations.isNotEmpty)
            Positioned(
              bottom: 335,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return RecommendationCard(recommendation: recommendations[index]);
                  },
                ),
              ),
            ),

          // Glassmorphic status panel
          const Positioned(
            bottom: 160,
            left: 16,
            right: 16,
            child: _ActiveJourneyGlassPanel(),
          ),

          // Draggable Bottom Timeline & Trip Progress Indicator
          const _DraggableTimelineSheet(),
        ],
      ),
    );
  }

  Widget _buildStartScreen(JourneyState state) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.explore_outlined, color: Colors.tealAccent, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Live Journey Engine',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Transform your static travel plan into a real-time guided tour with automatic arrival alerts and live GPS tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Inter', height: 1.5),
                ),
                const SizedBox(height: 32),

                // Graceful Permission Warning overlay if location check failed
                if (state.permissionDenied)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                            SizedBox(width: 8),
                            Text(
                              'Location Access Denied',
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Voyanta requires background & foreground GPS permission to animate your route and trigger geofence arrivals. Please enable it in settings or click Grant below.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                // Background location support notice
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.security, color: Colors.tealAccent, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Equipped with background tracking capabilities. Voyanta safely monitors progress even when your screen is locked.',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    onPressed: () {
                      ref.read(journeyControllerProvider.notifier).startJourney(_testItinerary);
                    },
                    child: const Text(
                      'Start Journey',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Outfit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveJourneyGlassPanel extends ConsumerWidget {
  const _ActiveJourneyGlassPanel();

  Future<void> _launchMapsIntent(double lat, double lng) async {
    final String googleMapsUrl = 'google.navigation:q=$lat,$lng&mode=d';
    final String appleMapsUrl = 'maps://?daddr=$lat,$lng&dirflg=d';

    final uri = Uri.parse(Platform.isIOS ? appleMapsUrl : googleMapsUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final webUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
      );
      await launchUrl(webUri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journeyControllerProvider);
    if (state.currentActivity == null) return const SizedBox.shrink();

    final isArrived = state.status == JourneyStatus.arrived;
    final activity = state.currentActivity!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isArrived ? '🎯 ARRIVED AT DESTINATION' : '⏳ ACTIVE ROUTE STATE',
                style: TextStyle(
                  color: isArrived ? Colors.tealAccent : Colors.white54,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.title,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${(state.distanceToNextMeters / 1000).toStringAsFixed(2)} km away • ETA: ${state.etaMinutes} mins',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.navigation),
                      label: const Text('Navigate'),
                      onPressed: () => _launchMapsIntent(activity.latitude, activity.longitude),
                    ),
                  ),
                  if (isArrived) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white12,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Complete'),
                        onPressed: () {
                          ref.read(journeyControllerProvider.notifier).advanceToNextActivity();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DraggableTimelineSheet extends ConsumerWidget {
  const _DraggableTimelineSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeItinerary = ref.watch(journeyControllerProvider.select((s) => s.activeItinerary));
    final currentActivityIndex = ref.watch(journeyControllerProvider.select((s) => s.currentActivityIndex));
    
    final totalActivities = activeItinerary?.activities.length ?? 1;
    final completedCount = currentActivityIndex;
    final progressFraction = completedCount / totalActivities;
    final activities = activeItinerary?.activities ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withValues(alpha: 0.9), // Glass panel
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  // Center drag indicator line
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar Block
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Journey Timeline',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '$completedCount / $totalActivities completed',
                        style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      backgroundColor: Colors.white10,
                      color: Colors.tealAccent,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline activities checklist
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final act = activities[index];
                      final isCompleted = index < currentActivityIndex;
                      final isActive = index == currentActivityIndex;

                      return _buildTimelineItem(act, isCompleted, isActive, index == activities.length - 1);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineItem(Activity activity, bool isCompleted, bool isActive, bool isLast) {
    Color dotColor = Colors.white24;
    IconData icon = Icons.circle_outlined;
    TextStyle titleStyle = const TextStyle(color: Colors.white70, fontSize: 14);

    if (isCompleted) {
      dotColor = Colors.tealAccent;
      icon = Icons.check_circle;
      titleStyle = const TextStyle(color: Colors.white38, fontSize: 14, decoration: TextDecoration.lineThrough);
    } else if (isActive) {
      dotColor = Colors.purpleAccent;
      icon = Icons.gps_fixed;
      titleStyle = const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left timeline visual track
          Column(
            children: [
              Icon(icon, color: dotColor, size: 20),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? Colors.tealAccent : Colors.white12,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      activity.time,
                      style: TextStyle(
                        color: isActive ? Colors.purpleAccent : Colors.white30,
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  activity.description,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
