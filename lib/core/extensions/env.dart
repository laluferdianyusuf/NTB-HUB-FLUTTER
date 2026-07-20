import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiUrl =>
      kReleaseMode ? dotenv.get('PROD_API_URL') : dotenv.get('DEV_API_URL');

  static String? get googleClientId {
    final value = dotenv.maybeGet('GOOGLE_CLIENT_ID');
    if (value == null || value.trim().isEmpty) return null;

    var cleaned = value.trim();
    if ((cleaned.startsWith('"') && cleaned.endsWith('"')) ||
        (cleaned.startsWith("'") && cleaned.endsWith("'"))) {
      cleaned = cleaned.substring(1, cleaned.length - 1);
    }
    return cleaned;
  }
}
