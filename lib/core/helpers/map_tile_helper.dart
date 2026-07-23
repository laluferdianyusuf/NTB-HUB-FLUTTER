import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// Tile map yang menyesuaikan tema terang/gelap aplikasi.
abstract final class MapTileHelper {
  static const _lightUrl =
      'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
  static const _darkUrl =
      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';
  static const _subdomains = ['a', 'b', 'c', 'd'];

  static TileLayer tileLayer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final url = isDark ? _darkUrl : _lightUrl;

    return TileLayer(
      urlTemplate: url,
      subdomains: _subdomains,
      userAgentPackageName: 'com.ntbhub.flutter',
      retinaMode: RetinaMode.isHighDensity(context),
    );
  }
}
