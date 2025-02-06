/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:28:54
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

// ignore_for_file: avoid_print
import 'package:flutter/foundation.dart';

class LogHelper {
  static const String _prefix = "cinema-booking";

  static void logDebug({required String tag, required String message}) =>
      _log("DEBUG", tag, message);
  static void logInfo({required String tag, required String message}) => _log("INFO", tag, message);
  static void logWarning({required String tag, required String message}) =>
      _log("WARNING", tag, message);

  static void logError({
    required String tag,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _log("ERROR", tag, message);
    if (kDebugMode && error != null) print("$_prefix [ERROR] $tag: Error: $error");
    if (stackTrace != null && kDebugMode) print("$_prefix [ERROR] $tag: StackTrace: $stackTrace");
  }

  static void _log(String level, String tag, String message) {
    if (kDebugMode) {
      print("$_prefix [$level] $tag: $message");
    }
  }
}
