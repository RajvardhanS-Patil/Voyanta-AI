import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/features/journey/domain/entities/journey_state.dart';
import '../controllers/map_controller.dart';
import 'package:voyanta_ai/core/ux/shimmer_loader.dart';

class ItineraryMapView extends ConsumerStatefulWidget {
  const ItineraryMapView({super.key});

  @override
  ConsumerState<ItineraryMapView> createState() => _ItineraryMapViewState();
}

class _ItineraryMapViewState extends ConsumerState<ItineraryMapView> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? annotationManager;

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    _rebuildAnnotations();
  }

  void _updateAnnotations(List<PointAnnotationOptions> newAnnotations) {
    if (annotationManager == null) return;
    annotationManager?.deleteAll();
    if (newAnnotations.isNotEmpty) {
      annotationManager?.createMulti(newAnnotations);
    }
  }

  void _rebuildAnnotations() {
    final journey = ref.read(journeyControllerProvider);
    final List<PointAnnotationOptions> annotations = [];

    if (journey.hasActiveJourney) {
      final itinerary = journey.activeItinerary!;

      // Dynamic GPS: Draw user current location indicator
      if (journey.currentLatitude != 0.0 && journey.currentLongitude != 0.0) {
        annotations.add(
          PointAnnotationOptions(
            geometry: Point(
              coordinates: Position(
                journey.currentLongitude,
                journey.currentLatitude,
              ),
            ),
            textField: "📍 My Location",
            textColor: 0xFF2DD4BF, // Cyber Teal Accent
            iconImage: 'marker-15',
            iconSize: 1.8,
          ),
        );
      }

      // Map Requirements: Highlight active, fade completed, emphasize upcoming
      for (int i = 0; i < itinerary.activities.length; i++) {
        final act = itinerary.activities[i];
        final isCompleted = i < journey.currentActivityIndex;
        final isActive = i == journey.currentActivityIndex;

        double size = 1.1;
        int color = 0xFFD8B4FE; // Emphasize upcoming with deep lavender
        String prefix = "⏳ ";

        if (isCompleted) {
          size = 0.8;
          color = 0xFF64748B; // Fade completed with slate gray
          prefix = "✓ ";
        } else if (isActive) {
          size = 1.6;
          color = 0xFF2DD4BF; // Highlight active with cyber teal
          prefix = "🎯 ";
        }

        annotations.add(
          PointAnnotationOptions(
            geometry: Point(coordinates: Position(act.longitude, act.latitude)),
            textField: "$prefix${act.title}",
            textColor: color,
            iconImage: 'marker-15',
            iconSize: size,
          ),
        );
      }
    } else {
      // Fallback to static itinerary mode
      annotations.addAll(ref.read(mapControllerProvider).annotations);
    }

    _updateAnnotations(annotations);
  }

  @override
  Widget build(BuildContext context) {
    final publicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];

    // Listen to journey modifications (position adjustments)
    ref.listen<JourneyState>(journeyControllerProvider, (previous, next) {
      _rebuildAnnotations();

      if (next.hasActiveJourney && mapboxMap != null) {
        final currentAct = next.currentActivity;
        if (currentAct != null) {
          double targetLat = currentAct.latitude;
          double targetLng = currentAct.longitude;

          // Intelligent Focus: keeps user & active destination in frame
          if (next.currentLatitude != 0.0 && next.currentLongitude != 0.0) {
            targetLat = (currentAct.latitude + next.currentLatitude) / 2;
            targetLng = (currentAct.longitude + next.currentLongitude) / 2;
          }

          mapboxMap?.flyTo(
            CameraOptions(
              center: Point(coordinates: Position(targetLng, targetLat)),
              zoom: 13.0,
              pitch: 45.0, // 3D aesthetic tilt
            ),
            MapAnimationOptions(duration: 1200),
          );
        }
      }
    });

    // Listen to static fallback map triggers
    ref.listen<MapState>(mapControllerProvider, (previous, next) {
      final journey = ref.read(journeyControllerProvider);
      if (!journey.hasActiveJourney) {
        _rebuildAnnotations();
        if (next.cameraOptions != null && mapboxMap != null) {
          mapboxMap?.flyTo(
            next.cameraOptions!,
            MapAnimationOptions(duration: 1000),
          );
        }
      }
    });

    if (publicToken == null ||
        publicToken.isEmpty ||
        publicToken.startsWith('mock')) {
      return ShimmerLoader(
        child: Container(
          color: const Color(0xFF1E293B),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, color: Colors.white54, size: 64),
                SizedBox(height: 16),
                Text(
                  'Loading Map Data...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    MapboxOptions.setAccessToken(publicToken);

    return MapWidget(
      key: const ValueKey("mapboxWidget"),
      styleUri: MapboxStyles.DARK,
      onMapCreated: _onMapCreated,
    );
  }
}
