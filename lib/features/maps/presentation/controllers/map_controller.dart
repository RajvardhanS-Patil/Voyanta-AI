import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../trip_planner/domain/entities/trip_itinerary.dart';

class MapMarker {
  final LatLng point;
  final String title;
  final int colorValue;
  final double size;
  final String prefix;

  const MapMarker({
    required this.point,
    required this.title,
    this.colorValue = 0xFFFFFFFF,
    this.size = 1.5,
    this.prefix = '',
  });
}

class MapState {
  final List<MapMarker> markers;
  final LatLng? center;
  final double zoom;

  const MapState({this.markers = const [], this.center, this.zoom = 12.0});

  MapState copyWith({List<MapMarker>? markers, LatLng? center, double? zoom}) {
    return MapState(
      markers: markers ?? this.markers,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }
}

class VoyantaMapController extends Notifier<MapState> {
  @override
  MapState build() {
    return const MapState();
  }

  void loadItinerary(TripItinerary itinerary) {
    if (itinerary.activities.isEmpty) return;

    final markers = itinerary.activities.map((activity) {
      return MapMarker(
        point: LatLng(activity.latitude, activity.longitude),
        title: activity.title,
      );
    }).toList();

    final first = itinerary.activities.first;
    state = state.copyWith(
      markers: markers,
      center: LatLng(first.latitude, first.longitude),
      zoom: 12.0,
    );
  }
}

final mapControllerProvider =
    NotifierProvider<VoyantaMapController, MapState>(() {
  return VoyantaMapController();
});
