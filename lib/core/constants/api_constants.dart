import 'package:ntbhub_flutter/core/extensions/env.dart';

abstract final class ApiConstants {
  static final String baseUrl = Env.apiUrl;

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
