import 'dart:io';

/// Central API Configuration for identity server communication.
class ApiConfig {
  /// Default base URL for identity & auth API.
  /// Uses loopback on physical device/desktop, and 10.0.2.2 on Android emulator.
  static String get defaultBaseUrl {
    // If running in test environment or custom override
    const configured = String.fromEnvironment('BACKEND_URL');
    if (configured.isNotEmpty) return configured;

    try {
      if (Platform.isAndroid) {
        // Fallback for standard Android emulator
        // (If using adb reverse or physical device, 127.0.0.1 is forwarded)
        return 'http://127.0.0.1:8000';
      }
    } catch (_) {}
    return 'http://127.0.0.1:8000';
  }

  /// Default Google Web Client ID for token audience validation if needed.
  static const String googleClientId = String.fromEnvironment('GOOGLE_CLIENT_ID', defaultValue: '');
}

