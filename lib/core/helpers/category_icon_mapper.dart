import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

abstract final class CategoryIconMapper {
  static const _assetBase = 'lib/core/assets/svg';

  static String svgAsset({required String? icon, String? code, String? name}) {
    final iconKey = (icon ?? '').toLowerCase().trim();
    if (iconKey.isNotEmpty) {
      final mapped = _iconMap[iconKey];
      if (mapped != null) return '$_assetBase/$mapped';
    }

    final codeKey = (code ?? '').toUpperCase().trim();
    if (codeKey.isNotEmpty) {
      final mapped = _codeMap[codeKey];
      if (mapped != null) return '$_assetBase/$mapped';
    }

    final nameKey = (name ?? '').toLowerCase();
    if (nameKey.contains('sport') || nameKey.contains('fitness')) {
      return '$_assetBase/sport.svg';
    }
    if (nameKey.contains('food')) return '$_assetBase/food.svg';
    if (nameKey.contains('entertain')) return '$_assetBase/fun.svg';
    if (nameKey.contains('meeting') || nameKey.contains('workspace')) {
      return '$_assetBase/meeting.svg';
    }
    if (nameKey.contains('beauty') || nameKey.contains('wellness')) {
      return '$_assetBase/beauty.svg';
    }
    if (nameKey.contains('education') || nameKey.contains('training')) {
      return '$_assetBase/education.svg';
    }
    if (nameKey.contains('travel') || nameKey.contains('tourism')) {
      return '$_assetBase/travel.svg';
    }
    if (nameKey.contains('health') || nameKey.contains('medical')) {
      return '$_assetBase/health.svg';
    }

    return '$_assetBase/venue.svg';
  }

  static Color accentColor({required String? icon, String? code}) {
    final iconKey = (icon ?? '').toLowerCase();
    return switch (iconKey) {
      'sport' => const Color(0xFF2A9D8F),
      'food' => const Color(0xFFE76F51),
      'entertainment' => const Color(0xFF6A0572),
      'meeting' => const Color(0xFF0F4C75),
      'beauty' => const Color(0xFFDB7093),
      'training' => const Color(0xFF457B9D),
      'travel' => const Color(0xFF1B5E4B),
      'health' => const Color(0xFF16A34A),
      _ => switch ((code ?? '').toUpperCase()) {
        'SPORT_FITNESS' => const Color(0xFF2A9D8F),
        'FOOD_BEVERAGE' => const Color(0xFFE76F51),
        'ENTERTAINMENT' => const Color(0xFF6A0572),
        'MEETING_WORKSPACE' => const Color(0xFF0F4C75),
        'WELLNESS_BEAUTY' => const Color(0xFFDB7093),
        'EDU_TRAINING' => const Color(0xFF457B9D),
        'TRAVEL_TOURISM' => const Color(0xFF1B5E4B),
        'HEALTH_MEDICAL' => const Color(0xFF16A34A),
        _ => const Color(0xFF1B5E4B),
      },
    };
  }

  static IconData fallbackIcon({required String? icon}) {
    return switch ((icon ?? '').toLowerCase()) {
      'sport' => Iconsax.activity,
      'food' => Iconsax.coffee,
      'entertainment' => Iconsax.music,
      'meeting' => Iconsax.people,
      'beauty' => Iconsax.brush_4,
      'training' => Iconsax.book,
      'travel' => Iconsax.global,
      'health' => Iconsax.hospital,
      _ => Iconsax.category,
    };
  }

  static const _iconMap = {
    'sport': 'sport.svg',
    'food': 'food.svg',
    'entertainment': 'fun.svg',
    'meeting': 'meeting.svg',
    'beauty': 'beauty.svg',
    'training': 'education.svg',
    'travel': 'travel.svg',
    'health': 'health.svg',
    'venue': 'venue.svg',
    'event': 'event.svg',
  };

  static const _codeMap = {
    'SPORT_FITNESS': 'sport.svg',
    'FOOD_BEVERAGE': 'food.svg',
    'ENTERTAINMENT': 'fun.svg',
    'MEETING_WORKSPACE': 'meeting.svg',
    'WELLNESS_BEAUTY': 'beauty.svg',
    'EDU_TRAINING': 'education.svg',
    'TRAVEL_TOURISM': 'travel.svg',
    'HEALTH_MEDICAL': 'health.svg',
  };
}
