import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyanta_ai/core/services/weather_service.dart';
import 'package:voyanta_ai/core/services/trip_config_provider.dart';

/// Watches the active destination and auto-fetches live weather.
/// Returns null while loading or if no destination is set.
class DestinationWeatherNotifier extends AsyncNotifier<DestinationWeather?> {
  @override
  Future<DestinationWeather?> build() async {
    final destination = ref.watch(tripConfigProvider);
    if (destination.isEmpty) return null;
    return await DestinationWeather.fetch(destination);
  }

  /// Force refresh weather data.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final destinationWeatherProvider =
    AsyncNotifierProvider<DestinationWeatherNotifier, DestinationWeather?>(() {
      return DestinationWeatherNotifier();
    });
