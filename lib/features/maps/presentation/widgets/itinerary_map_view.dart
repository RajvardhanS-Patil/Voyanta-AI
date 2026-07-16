import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../controllers/map_controller.dart';

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
    _updateAnnotations(ref.read(mapControllerProvider).annotations);
  }

  void _updateAnnotations(List<PointAnnotationOptions> newAnnotations) {
    if (annotationManager == null) return;
    annotationManager?.deleteAll();
    if (newAnnotations.isNotEmpty) {
      annotationManager?.createMulti(newAnnotations);
    }
  }

  @override
  Widget build(BuildContext context) {
    final publicToken = dotenv.env['MAPBOX_PUBLIC_TOKEN'];

    // Update markers when state changes
    ref.listen<MapState>(mapControllerProvider, (previous, next) {
      if (previous?.annotations != next.annotations) {
        _updateAnnotations(next.annotations);
      }
      if (next.cameraOptions != null && mapboxMap != null) {
        mapboxMap?.flyTo(
          next.cameraOptions!,
          MapAnimationOptions(duration: 1000),
        );
      }
    });

    if (publicToken == null ||
        publicToken.isEmpty ||
        publicToken.startsWith('mock')) {
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.map_outlined, color: Colors.white54, size: 48),
              SizedBox(height: 16),
              Text(
                'Mapbox Token Required',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    MapboxOptions.setAccessToken(publicToken);

    return MapWidget(
      key: const ValueKey("mapboxWidget"),
      styleUri: MapboxStyles.DARK, // Applying aesthetic dark style
      onMapCreated: _onMapCreated,
    );
  }
}
