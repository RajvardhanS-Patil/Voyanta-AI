import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:voyanta_ai/features/journey/presentation/controllers/journey_controller.dart';
import 'package:voyanta_ai/core/services/routing_service.dart';
import '../controllers/map_controller.dart' as voyanta_map;

final activeRouteProvider = FutureProvider.autoDispose<List<LatLng>>((ref) async {
  final journey = ref.watch(journeyControllerProvider);
  if (!journey.hasActiveJourney) return [];
  
  final points = <LatLng>[];
  // Add live location as starting point if available
  if (journey.currentLatitude != 0.0 && journey.currentLongitude != 0.0) {
    points.add(LatLng(journey.currentLatitude, journey.currentLongitude));
  }
  
  // Add all remaining activities in the itinerary
  for (int i = journey.currentActivityIndex; i < journey.activeItinerary!.activities.length; i++) {
    final act = journey.activeItinerary!.activities[i];
    points.add(LatLng(act.latitude, act.longitude));
  }
  
  if (points.length < 2) return points;
  
  final routing = ref.read(routingServiceProvider);
  return routing.getRoute(points);
});

class ItineraryMapView extends ConsumerStatefulWidget {
  const ItineraryMapView({super.key});

  @override
  ConsumerState<ItineraryMapView> createState() => _ItineraryMapViewState();
}

class _ItineraryMapViewState extends ConsumerState<ItineraryMapView> {
  final MapController _flutterMapController = MapController();

  @override
  Widget build(BuildContext context) {
    final journey = ref.watch(journeyControllerProvider);
    final mapState = ref.watch(voyanta_map.mapControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build markers from journey state or static map state
    final markers = <Marker>[];
    LatLng center = const LatLng(20.5937, 78.9629); // Default: India center
    double zoom = 5.0;

    if (journey.hasActiveJourney) {
      final itinerary = journey.activeItinerary!;

      // User location marker
      if (journey.currentLatitude != 0.0 && journey.currentLongitude != 0.0) {
        markers.add(
          Marker(
            point: LatLng(journey.currentLatitude, journey.currentLongitude),
            width: 40,
            height: 40,
            child: const _PulsingDot(color: Color(0xFF2DD4BF)),
          ),
        );
      }

      // Activity markers
      for (int i = 0; i < itinerary.activities.length; i++) {
        final act = itinerary.activities[i];
        final isCompleted = i < journey.currentActivityIndex;
        final isActive = i == journey.currentActivityIndex;

        Color markerColor;
        String prefix;
        double size;

        if (isCompleted) {
          markerColor = const Color(0xFF64748B);
          prefix = '✓';
          size = 32;
        } else if (isActive) {
          markerColor = const Color(0xFF2DD4BF);
          prefix = '🎯';
          size = 44;
        } else {
          markerColor = const Color(0xFFD8B4FE);
          prefix = '⏳';
          size = 36;
        }

        markers.add(
          Marker(
            point: LatLng(act.latitude, act.longitude),
            width: size + 80,
            height: size + 20,
            child: _ActivityMarker(
              title: act.title,
              prefix: prefix,
              color: markerColor,
              size: size,
              isActive: isActive,
            ),
          ),
        );
      }

      // Center on active activity
      final currentAct = journey.currentActivity;
      if (currentAct != null) {
        if (journey.currentLatitude != 0.0 && journey.currentLongitude != 0.0) {
          center = LatLng(
            (currentAct.latitude + journey.currentLatitude) / 2,
            (currentAct.longitude + journey.currentLongitude) / 2,
          );
        } else {
          center = LatLng(currentAct.latitude, currentAct.longitude);
        }
        zoom = 13.0;
      }
    } else if (mapState.markers.isNotEmpty) {
      // Static itinerary mode
      for (final m in mapState.markers) {
        markers.add(
          Marker(
            point: m.point,
            width: 120,
            height: 50,
            child: _ActivityMarker(
              title: m.title,
              prefix: '📍',
              color: const Color(0xFF2DD4BF),
              size: 36,
              isActive: false,
            ),
          ),
        );
      }
      if (mapState.center != null) {
        center = mapState.center!;
        zoom = mapState.zoom;
      }
    }

    // Draw polyline connecting activities
    final routeAsync = ref.watch(activeRouteProvider);
    final polylinePoints = routeAsync.value ?? <LatLng>[];

    return FlutterMap(
      mapController: _flutterMapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: zoom,
        maxZoom: 18.0,
        minZoom: 3.0,
      ),
      children: [
        TileLayer(
          urlTemplate: isDark
              ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
              : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.voyanta.ai',
        ),
        if (polylinePoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: polylinePoints,
                color: const Color(0xFF2DD4BF).withValues(alpha: 0.6),
                strokeWidth: 3,
              ),
            ],
          ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

// ─── Pulsing GPS Dot ─────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.5);
        final opacity = 1.0 - _controller.value;
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse ring
            Transform.scale(
              scale: scale,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: opacity * 0.3),
                ),
              ),
            ),
            // Core dot
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Activity Map Marker ─────────────────────────────────────────
class _ActivityMarker extends StatelessWidget {
  final String title;
  final String prefix;
  final Color color;
  final double size;
  final bool isActive;

  const _ActivityMarker({
    required this.title,
    required this.prefix,
    required this.color,
    required this.size,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withValues(alpha: 0.6),
              width: isActive ? 2 : 1,
            ),
          ),
          child: Text(
            '$prefix $title',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(Icons.location_on, color: color, size: size * 0.5),
      ],
    );
  }
}
