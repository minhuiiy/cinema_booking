/*
 * API base URL config that works across platforms.
 */
import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Returns a platform-aware base URL for the local dev backend.
  ///
  /// - Web/iOS/macOS/Windows/Linux: `http://localhost:3000`
  /// - Android emulator: `http://10.0.2.2:3000` (Android maps host loopback)
  /// - Override via `--dart-define=API_BASE_URL=...` if needed.
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000';
      default:
        return 'http://localhost:3000';
    }
  }
}