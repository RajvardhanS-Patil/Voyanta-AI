import 'package:voyanta_ai/core/constants/indian_cities.dart';

/// Smart city search that returns results prioritized by relevance:
/// 1. Cities whose name STARTS WITH the query (highest priority)
/// 2. Cities whose name CONTAINS the query (secondary)
/// Results are capped at [maxResults] to keep the UI snappy.
List<String> searchCities(String query, {int maxResults = 15}) {
  if (query.isEmpty) return [];

  final lowerQuery = query.toLowerCase().trim();
  if (lowerQuery.isEmpty) return [];

  final List<String> startsWithMatches = [];
  final List<String> containsMatches = [];

  for (final city in indianCities) {
    final lowerCity = city.toLowerCase();
    // Extract just the city name (before the comma)
    final cityName = lowerCity.split(',').first.trim();

    if (cityName.startsWith(lowerQuery)) {
      startsWithMatches.add(city);
    } else if (lowerCity.contains(lowerQuery)) {
      containsMatches.add(city);
    }
  }

  // Prioritize "starts with" matches, then append "contains" matches
  final results = [...startsWithMatches, ...containsMatches];
  return results.take(maxResults).toList();
}
