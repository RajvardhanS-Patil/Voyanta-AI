import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../trip_planner/domain/entities/trip_itinerary.dart';

class MapState {
  final List<PointAnnotationOptions> annotations;
  final CameraOptions? cameraOptions;

  const MapState({this.annotations = const [], this.cameraOptions});

  MapState copyWith({
    List<PointAnnotationOptions>? annotations,
    CameraOptions? cameraOptions,
  }) {
    return MapState(
      annotations: annotations ?? this.annotations,
      cameraOptions: cameraOptions ?? this.cameraOptions,
    );
  }
}

class MapController extends Notifier<MapState> {
  @override
  MapState build() {
    return const MapState();
  }

  void loadItinerary(TripItinerary itinerary) {
    if (itinerary.activities.isEmpty) return;

    final annotations = itinerary.activities.map((activity) {
      return PointAnnotationOptions(
        geometry: Point(
          coordinates: Position(activity.longitude, activity.latitude),
        ),
        textField: activity.title,
        textColor: 0xFFFFFFFF,
        iconImage: 'marker-15', // Default mapbox marker
        iconSize: 1.5,
      );
    }).toList();

    // Center camera on first activity
    final first = itinerary.activities.first;
    final camera = CameraOptions(
      center: Point(coordinates: Position(first.longitude, first.latitude)),
      zoom: 12.0,
      pitch: 45.0, // 3D aesthetic tilt
    );

    state = state.copyWith(annotations: annotations, cameraOptions: camera);
  }
}

final mapControllerProvider = NotifierProvider<MapController, MapState>(() {
  return MapController();
});
