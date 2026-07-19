import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/services/weather_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

import 'package:voyanta_ai/features/maps/presentation/widgets/itinerary_map_view.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/trip_planner/domain/entities/activity.dart';
import 'package:voyanta_ai/features/intelligence/presentation/controllers/intelligence_providers.dart';
import 'package:voyanta_ai/features/intelligence/presentation/widgets/recommendation_card.dart';
import 'package:voyanta_ai/core/theme/theme_provider.dart';
import 'package:voyanta_ai/core/widgets/sync_status_banner.dart';
import 'package:voyanta_ai/core/utils/city_search.dart';
import 'package:voyanta_ai/core/ux/animated_background.dart';
import 'package:voyanta_ai/core/services/trip_config_provider.dart';
import 'package:go_router/go_router.dart';

class LiveJourneyScreen extends ConsumerStatefulWidget {
  const LiveJourneyScreen({super.key});

  @override
  ConsumerState<LiveJourneyScreen> createState() => _LiveJourneyScreenState();
}

class _LiveJourneyScreenState extends ConsumerState<LiveJourneyScreen>
    with TickerProviderStateMixin {
  final _destinationController = TextEditingController();
  late AnimationController _bgAnimController;
  bool _isFullscreen = false;

  // Popular India destinations for quick-pick cards
  static const _popularDestinations = [
    _DestinationCard(
      name: 'Goa',
      tagline: 'Beaches & Nightlife',
      icon: Icons.beach_access_rounded,
      gradient: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    ),
    _DestinationCard(
      name: 'Jaipur',
      tagline: 'Heritage & Forts',
      icon: Icons.account_balance_rounded,
      gradient: [Color(0xFFEC4899), Color(0xFFF43F5E)],
    ),
    _DestinationCard(
      name: 'Kerala',
      tagline: 'Backwaters & Nature',
      icon: Icons.forest_rounded,
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
    ),
    _DestinationCard(
      name: 'Varanasi',
      tagline: 'Spirituality & Culture',
      icon: Icons.temple_hindu_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    ),
    _DestinationCard(
      name: 'Udaipur',
      tagline: 'Lakes & Palaces',
      icon: Icons.castle_rounded,
      gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    ),
    _DestinationCard(
      name: 'Manali',
      tagline: 'Mountains & Adventure',
      icon: Icons.landscape_rounded,
      gradient: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _bgAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveJourney = ref.watch(
      journeyControllerProvider.select((state) => state.hasActiveJourney),
    );

    if (!hasActiveJourney) {
      final journeyState = ref.read(journeyControllerProvider);
      return _buildStartScreen(journeyState);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: _isFullscreen ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.location_on, color: Colors.tealAccent),
        title: const Text(
          'Live Route Tracker',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.stop_circle_outlined,
              color: Colors.redAccent,
              size: 28,
            ),
            onPressed: () {
              ref.read(journeyControllerProvider.notifier).endJourney();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const ItineraryMapView(),
          
          // Fullscreen Toggle Button
          Positioned(
            top: _isFullscreen ? 50 : 100,
            right: 16,
            child: FloatingActionButton.small(
              backgroundColor: Colors.black54,
              child: Icon(
                _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isFullscreen = !_isFullscreen;
                });
              },
            ),
          ),
          
          if (!_isFullscreen) ...[
            const Positioned(
              top: 100,
              left: 16,
              right: 64, // leave room for FAB
              child: SyncStatusBanner(),
            ),
            const Positioned(
              bottom: 160,
              left: 16,
              right: 16,
              child: _ActiveJourneyGlassPanel(),
            ),
            const _DraggableTimelineSheet(),
          ],
        ],
      ),
    );
  }

  Widget _buildStartScreen(JourneyState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final cardColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.white.withValues(alpha: 0.85);
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtextColor = isDark ? Colors.white70 : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Animated floating orbs background
          const AnimatedBackground(child: SizedBox.expand()),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar with logo and theme toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.explore,
                              color: isDark
                                  ? Colors.tealAccent
                                  : const Color(0xFF0D9488),
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Voyanta AI',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ],
                        ),
                        // Dark/Light mode toggle
                        Container(
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.1)
                                  : Colors.black.withValues(alpha: 0.08),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: isDark
                                  ? Colors.amber
                                  : const Color(0xFF475569),
                            ),
                            onPressed: () {
                              ref.read(themeModeProvider.notifier).toggle();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Hero heading
                    Text(
                      'Where are you\ntravelling to?',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your destination and let AI plan the perfect trip.',
                      style: TextStyle(
                        color: subtextColor,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Destination input card
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.08),
                        ),
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Icon(
                            Icons.location_on_outlined,
                            color: isDark
                                ? Colors.tealAccent
                                : const Color(0xFF0D9488),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Autocomplete<String>(
                              optionsBuilder: (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return searchCities(textEditingValue.text, maxResults: 15);
                              },
                              onSelected: (String selection) {
                                _destinationController.text = selection;
                                _navigateToPlanner();
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController fieldTextEditingController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                // Bind external controller
                                if (fieldTextEditingController.text.isEmpty && _destinationController.text.isNotEmpty) {
                                  fieldTextEditingController.text = _destinationController.text;
                                }
                                fieldTextEditingController.addListener(() {
                                  _destinationController.text = fieldTextEditingController.text;
                                });

                                return TextField(
                                  controller: fieldTextEditingController,
                                  focusNode: fieldFocusNode,
                                  style: TextStyle(color: textColor),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Goa, Jaipur, Mumbai...',
                                    hintStyle: TextStyle(
                                      color: subtextColor.withValues(alpha: 0.5),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    onFieldSubmitted();
                                    _navigateToPlanner();
                                  },
                                );
                              },
                              optionsViewBuilder: (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width - 150, // Account for padding and button
                                      height: 200,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8.0),
                                        itemCount: options.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          final String option = options.elementAt(index);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(
                                                option,
                                                style: TextStyle(color: textColor),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.tealAccent
                                    : const Color(0xFF0D9488),
                                foregroundColor: isDark
                                    ? Colors.black
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                              ),
                              onPressed: _navigateToPlanner,
                              child: const Text(
                                'Plan Trip',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Popular destinations section
                    Text(
                      'Popular Destinations',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to explore with AI-powered planning',
                      style: TextStyle(color: subtextColor, fontSize: 13),
                    ),
                    const SizedBox(height: 16),

                    // Destination cards grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.6,
                          ),
                      itemCount: _popularDestinations.length,
                      itemBuilder: (context, index) {
                        final dest = _popularDestinations[index];
                        return _buildDestinationCard(
                          dest,
                          isDark,
                          cardColor,
                          textColor,
                          subtextColor,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Permission Warning
                    if (state.permissionDenied)
                      Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.redAccent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Location Access Denied',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Voyanta requires GPS permission to animate your route and trigger geofence arrivals. Please enable it in settings.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Background tracking notice
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security,
                            color: isDark
                                ? Colors.tealAccent
                                : const Color(0xFF0D9488),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Equipped with background tracking. Voyanta monitors progress even when your screen is locked.',
                              style: TextStyle(
                                color: subtextColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPlanner() {
    final dest = _destinationController.text.trim();
    if (dest.isEmpty) return;
    ref.read(tripConfigProvider.notifier).setDestination(dest);
    // Navigate to planner tab
    context.go('/planner');
  }

  Widget _buildDestinationCard(
    _DestinationCard dest,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color subtextColor,
  ) {
    return GestureDetector(
      onTap: () {
        _destinationController.text = dest.name;
        _navigateToPlanner();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              dest.gradient[0].withValues(alpha: isDark ? 0.25 : 0.12),
              dest.gradient[1].withValues(alpha: isDark ? 0.10 : 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dest.gradient[0].withValues(alpha: isDark ? 0.3 : 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(dest.icon, color: dest.gradient[0], size: 28),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dest.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Outfit',
                  ),
                ),
                Text(
                  dest.tagline,
                  style: TextStyle(color: subtextColor, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationCard {
  final String name;
  final String tagline;
  final IconData icon;
  final List<Color> gradient;

  const _DestinationCard({
    required this.name,
    required this.tagline,
    required this.icon,
    required this.gradient,
  });
}

// ─── Animated Background Painter ─────────────────────────────────


// ─── Active Journey Glass Panel ──────────────────────────────────
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
    final weatherState = ref.watch(destinationWeatherProvider);
    if (state.currentActivity == null) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDark ? Colors.black.withValues(alpha: 0.65) : Colors.white.withValues(alpha: 0.85);
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.1);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final isArrived = state.status == JourneyStatus.arrived;
    final activity = state.currentActivity!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor),
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
              if (weatherState.value != null && weatherState.value!.description.toLowerCase().contains('rain'))
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Weather Alert: ${weatherState.value!.description} (${weatherState.value!.temperatureC}°C)',
                        style: TextStyle(color: textColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              Text(
                isArrived
                    ? '🎯 ARRIVED AT DESTINATION'
                    : '⏳ ACTIVE ROUTE STATE',
                style: TextStyle(
                  color: isArrived ? (isDark ? Colors.tealAccent : Colors.teal) : subTextColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activity.title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${(state.distanceToNextMeters / 1000).toStringAsFixed(2)} km away • ETA: ${state.etaMinutes} mins',
                style: TextStyle(color: subTextColor, fontSize: 13),
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
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.navigation),
                      label: const Text('Navigate'),
                      onPressed: () => _launchMapsIntent(
                        activity.latitude,
                        activity.longitude,
                      ),
                    ),
                  ),
                  if (isArrived) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white12 : Colors.black12,
                          foregroundColor: textColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Complete'),
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
        ),
      ),
    );
  }
}

// ─── Draggable Timeline Sheet ────────────────────────────────────
class _DraggableTimelineSheet extends ConsumerWidget {
  const _DraggableTimelineSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeItinerary = ref.watch(
      journeyControllerProvider.select((s) => s.activeItinerary),
    );
    final currentActivityIndex = ref.watch(
      journeyControllerProvider.select((s) => s.currentActivityIndex),
    );

    final totalActivities = activeItinerary?.activities.length ?? 1;
    final completedCount = currentActivityIndex;
    final progressFraction = completedCount / totalActivities;
    final activities = activeItinerary?.activities ?? [];

    return DraggableScrollableSheet(
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.55,
      builder: (context, scrollController) {
        final recommendations = ref.watch(activeRecommendationsProvider);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final sheetColor = isDark ? const Color(0xFF1E293B).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95);
        final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
        final textColor = isDark ? Colors.white : Colors.black87;
        final handleColor = isDark ? Colors.white30 : Colors.black26;
        final trackBgColor = isDark ? Colors.white10 : Colors.black12;
        
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: sheetColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border.all(color: borderColor),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: handleColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (recommendations.isNotEmpty) ...[
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          return RecommendationCard(
                            recommendation: recommendations[index],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Journey Timeline',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$completedCount / $totalActivities completed',
                        style: TextStyle(
                          color: isDark ? Colors.tealAccent : Colors.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressFraction,
                      backgroundColor: trackBgColor,
                      color: isDark ? Colors.tealAccent : Colors.teal,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      final act = activities[index];
                      final isCompleted = index < currentActivityIndex;
                      final isActive = index == currentActivityIndex;

                      return _buildTimelineItem(
                        context,
                        act,
                        isCompleted,
                        isActive,
                        index == activities.length - 1,
                      );
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

  Widget _buildTimelineItem(
    BuildContext context,
    Activity activity,
    bool isCompleted,
    bool isActive,
    bool isLast,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color dotColor = isDark ? Colors.white24 : Colors.black26;
    IconData icon = Icons.circle_outlined;
    TextStyle titleStyle = TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 15, fontWeight: FontWeight.bold);
    
    if (isCompleted) {
      dotColor = isDark ? Colors.tealAccent : Colors.teal;
      icon = Icons.check_circle;
      titleStyle = TextStyle(
        color: isDark ? Colors.white38 : Colors.black38,
        fontSize: 15,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.lineThrough,
      );
    } else if (isActive) {
      dotColor = isDark ? Colors.purpleAccent : Colors.purple;
      icon = Icons.gps_fixed;
      titleStyle = TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(icon, color: dotColor, size: 24),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: isCompleted ? (isDark ? Colors.tealAccent.withValues(alpha: 0.6) : Colors.teal.withValues(alpha: 0.6)) : (isDark ? Colors.white12 : Colors.black12),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📍 Checkpoint',
                        style: TextStyle(
                          color: isActive ? Colors.purpleAccent : Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        activity.time,
                        style: TextStyle(
                          color: isActive ? Colors.purpleAccent : Colors.white54,
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.title,
                    style: titleStyle,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    activity.description,
                    style: TextStyle(
                      color: isActive ? Colors.white70 : Colors.white38,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
