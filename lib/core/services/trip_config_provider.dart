import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripConfigNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setDestination(String destination) {
    // Sanitize input to prevent LLM prompt injection tags
    final sanitized = destination.replaceAll(RegExp(r'\[.*?\]'), '').trim();
    state = sanitized;
  }
}

final tripConfigProvider = NotifierProvider<TripConfigNotifier, String>(() {
  return TripConfigNotifier();
});
