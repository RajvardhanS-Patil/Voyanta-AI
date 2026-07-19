import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final routingServiceProvider = Provider((ref) => RoutingService());

class RoutingService {
  final Dio _dio = Dio();

  /// Fetches a route between multiple coordinates using OSRM
  /// Points must be provided in order: [start, waypoint1, waypoint2, ..., end]
  Future<List<LatLng>> getRoute(List<LatLng> points) async {
    if (points.length < 2) return points;

    try {
      // OSRM expects coordinates in lon,lat format
      final coordinates = points
          .map((p) => '${p.longitude},${p.latitude}')
          .join(';');

      final url =
          'http://router.project-osrm.org/route/v1/driving/$coordinates?overview=full&geometries=polyline';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final routes = response.data['routes'] as List;
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'] as String;
          return _decodePolyline(geometry);
        }
      }
      // Fallback to straight lines if API fails
      return points;
    } catch (e) {
      debugPrint('OSRM Routing error: $e');
      // Fallback to straight lines
      return points;
    }
  }

  /// Decodes Google Polyline encoded string to a list of LatLng
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return polyline;
  }
}
