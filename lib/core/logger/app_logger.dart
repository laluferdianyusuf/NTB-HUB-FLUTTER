import 'package:flutter/foundation.dart';

class AppLogger {
  const AppLogger._();

  static void info(String message, [Object? data]) {
    if (kDebugMode) {
      debugPrint('[INFO] $message${data != null ? ' | $data' : ''}');
    }
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('[WARN] $message');
    }
  }
}
