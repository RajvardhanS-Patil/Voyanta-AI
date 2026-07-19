import 'dart:convert';
import 'package:http/http.dart' as http;

/// Weather data for a destination, fetched from Open-Meteo (free, no API key).
class DestinationWeather {
  final String locationName;
  final double temperatureC;
  final double feelsLikeC;
  final int humidity;
  final double windSpeedKmh;
  final int weatherCode;
  final String description;
  final bool isDay;

  const DestinationWeather({
    required this.locationName,
    required this.temperatureC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windSpeedKmh,
    required this.weatherCode,
    required this.description,
    required this.isDay,
  });

  String get emoji {
    if (weatherCode == 0) return isDay ? '☀️' : '🌙';
    if (weatherCode <= 3) return isDay ? '⛅' : '☁️';
    if (weatherCode <= 48) return '🌫️';
    if (weatherCode <= 57) return '🌧️';
    if (weatherCode <= 67) return '🌧️';
    if (weatherCode <= 77) return '❄️';
    if (weatherCode <= 82) return '🌦️';
    if (weatherCode <= 86) return '🌨️';
    if (weatherCode <= 99) return '⛈️';
    return '🌤️';
  }

  static String _weatherCodeToDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 55) return 'Drizzle';
    if (code <= 57) return 'Freezing drizzle';
    if (code <= 65) return 'Rain';
    if (code <= 67) return 'Freezing rain';
    if (code <= 75) return 'Snowfall';
    if (code == 77) return 'Snow grains';
    if (code <= 82) return 'Rain showers';
    if (code <= 86) return 'Snow showers';
    if (code == 95) return 'Thunderstorm';
    if (code <= 99) return 'Thunderstorm with hail';
    return 'Unknown';
  }

  /// Fetches current weather for a destination name.
  /// Uses Open-Meteo geocoding + weather API (free, no key needed).
  static Future<DestinationWeather?> fetch(String destination) async {
    try {
      // Step 1: Geocode the destination name to lat/lng
      final geoUrl = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(destination)}&count=1&language=en&format=json',
      );
      final geoResponse = await http
          .get(geoUrl)
          .timeout(const Duration(seconds: 8));

      if (geoResponse.statusCode != 200) return null;

      final geoJson = jsonDecode(geoResponse.body);
      final results = geoJson['results'] as List<dynamic>?;
      if (results == null || results.isEmpty) return null;

      final place = results[0];
      final double lat = (place['latitude'] as num).toDouble();
      final double lng = (place['longitude'] as num).toDouble();
      final String name = place['name'] ?? destination;

      // Step 2: Fetch current weather for coordinates
      final weatherUrl = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,is_day',
      );
      final weatherResponse = await http
          .get(weatherUrl)
          .timeout(const Duration(seconds: 8));

      if (weatherResponse.statusCode != 200) return null;

      final weatherJson = jsonDecode(weatherResponse.body);
      final current = weatherJson['current'];
      if (current == null) return null;

      final code = (current['weather_code'] as num?)?.toInt() ?? 0;

      return DestinationWeather(
        locationName: name,
        temperatureC: (current['temperature_2m'] as num?)?.toDouble() ?? 0,
        feelsLikeC: (current['apparent_temperature'] as num?)?.toDouble() ?? 0,
        humidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
        windSpeedKmh: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0,
        weatherCode: code,
        description: _weatherCodeToDescription(code),
        isDay: (current['is_day'] as num?)?.toInt() == 1,
      );
    } catch (_) {
      return null;
    }
  }
}
