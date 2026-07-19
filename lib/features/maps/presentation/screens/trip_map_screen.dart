import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/ux/animated_background.dart';
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
              theme: 'Delhi Highlights',
              activities: [
                Activity(
                  time: '10:00 AM',
                  title: 'India Gate',
                  description: 'Observation deck',
                  latitude: 28.6129,
                  longitude: 77.2295,
                ),
                Activity(
                  time: '1:00 PM',
                  title: 'Red Fort',
                  description: 'Lunch and walk',
                  latitude: 28.6562,
                  longitude: 77.2410,
                ),
              ],
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
      ),
    );
  }
}
