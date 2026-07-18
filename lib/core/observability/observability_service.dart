import 'package:logger/logger.dart';

enum Environment { dev, prod }

class ObservabilityService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  static Environment _environment = Environment.dev;

  static void initialize(Environment env) {
    _environment = env;
    _logger.i('ObservabilityService initialized in $_environment mode');
  }

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logWarning(String message) {
    _logger.w(message);
  }

  static void logError(
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    // In a real prod environment, this would be sent to Crashlytics or Sentry.
    if (_environment == Environment.prod) {
      _logger.d('CRASH REPORT DISPATCHED TO SENTRY/FIREBASE (MOCK)');
    }
  }

  static void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
    _logger.d('ANALYTICS EVENT: $eventName | $properties');
    // In a real prod environment, this would be sent to Firebase Analytics.
  }
}
