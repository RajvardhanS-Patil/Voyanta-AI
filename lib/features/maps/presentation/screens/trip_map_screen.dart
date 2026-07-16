import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/itinerary_map_view.dart';
import '../../../trip_planner/domain/entities/trip_itinerary.dart';
import '../../../trip_planner/domain/entities/activity.dart';
import '../controllers/map_controller.dart';

class TripMapScreen extends ConsumerStatefulWidget {
  const TripMapScreen({super.key});

  @override
  ConsumerState<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends ConsumerState<TripMapScreen> {
  @override
  void initState() {
    super.initState();
    // Load a dummy itinerary to test the map markers immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(mapControllerProvider.notifier)
          .loadItinerary(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Trip Map',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const ItineraryMapView(),
    );
  }
}
