import 'dart:ui';

class AppConstants {
  static const String appName = 'AppHIDS';

  // API endpoints
  static const String baseUrl = 'https://apphid-detection-api.onrender.com';
  static const String pestDetectionEndpoint = '/aphids';
  static const String irrigationEndpoint = '/irrigation';

  // Storage keys
  static const String authTokenKey = 'auth_token';
  static const String userPrefsKey = 'user_preferences';

  // Timeouts
  static const int apiTimeoutSeconds = 30;
  static const int sensorPollingIntervalSeconds = 5;

  // Feature flags
  static const bool enablePestDetection = true;
  static const bool enableChemigation = true;
  static const bool enableIrrigation = true;

  // Colors
  static const kDarkBackground = Color(0xFF1E1E1E);
  static const kCardColor = Color(0xFF252525);
}
