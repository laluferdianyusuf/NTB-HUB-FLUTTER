import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../models/enums/app_enums.dart';
import '../../models/map_place_model.dart';

abstract final class MapPlaceStyle {
  static IconData iconFor(MapPlaceKind kind) {
    return switch (kind) {
      MapPlaceKind.tourism => Iconsax.global,
      MapPlaceKind.restaurant => Iconsax.coffee,
      MapPlaceKind.shop => Iconsax.shop,
      MapPlaceKind.mall => Iconsax.buildings,
      MapPlaceKind.hospital => Iconsax.hospital,
      MapPlaceKind.school => Iconsax.book,
      MapPlaceKind.venue => Iconsax.calendar,
      MapPlaceKind.terminal => Iconsax.bus,
      MapPlaceKind.park => Iconsax.tree,
      MapPlaceKind.mosque => Iconsax.building,
      MapPlaceKind.market => Iconsax.bag,
      MapPlaceKind.hotel => Iconsax.home,
      MapPlaceKind.city => Iconsax.location,
    };
  }

  static Color colorFor(MapPlaceKind kind) {
    return switch (kind) {
      MapPlaceKind.tourism => const Color(0xFF1B5E4B),
      MapPlaceKind.restaurant => const Color(0xFFE76F51),
      MapPlaceKind.shop => const Color(0xFF457B9D),
      MapPlaceKind.mall => const Color(0xFF6A0572),
      MapPlaceKind.hospital => const Color(0xFFDC2626),
      MapPlaceKind.school => const Color(0xFF2563EB),
      MapPlaceKind.venue => const Color(0xFF0F4C75),
      MapPlaceKind.terminal => const Color(0xFF64748B),
      MapPlaceKind.park => const Color(0xFF16A34A),
      MapPlaceKind.mosque => const Color(0xFF059669),
      MapPlaceKind.market => const Color(0xFFD97706),
      MapPlaceKind.hotel => const Color(0xFF7C3AED),
      MapPlaceKind.city => const Color(0xFF334155),
    };
  }

  static MapPlaceKind fromPublicPlaceType(PublicPlaceType type) {
    return switch (type) {
      PublicPlaceType.tourism => MapPlaceKind.tourism,
      PublicPlaceType.hospital => MapPlaceKind.hospital,
      PublicPlaceType.school => MapPlaceKind.school,
      PublicPlaceType.park => MapPlaceKind.park,
      PublicPlaceType.mall => MapPlaceKind.mall,
      PublicPlaceType.terminal => MapPlaceKind.terminal,
      PublicPlaceType.other => MapPlaceKind.shop,
    };
  }

  static String filterLabel(MapPlaceFilter filter) {
    return switch (filter) {
      MapPlaceFilter.all => 'Semua',
      MapPlaceFilter.tourism => 'Wisata',
      MapPlaceFilter.food => 'Kuliner',
      MapPlaceFilter.shop => 'Toko & Mall',
      MapPlaceFilter.facility => 'Fasilitas',
      MapPlaceFilter.venue => 'Venue',
    };
  }

  static bool matchesFilter(MapPlaceModel place, MapPlaceFilter filter) {
    return switch (filter) {
      MapPlaceFilter.all => true,
      MapPlaceFilter.tourism =>
        place.kind == MapPlaceKind.tourism || place.kind == MapPlaceKind.park,
      MapPlaceFilter.food => place.kind == MapPlaceKind.restaurant,
      MapPlaceFilter.shop =>
        place.kind == MapPlaceKind.shop ||
            place.kind == MapPlaceKind.mall ||
            place.kind == MapPlaceKind.market,
      MapPlaceFilter.facility =>
        place.kind == MapPlaceKind.hospital ||
            place.kind == MapPlaceKind.school ||
            place.kind == MapPlaceKind.mosque ||
            place.kind == MapPlaceKind.terminal ||
            place.kind == MapPlaceKind.hotel ||
            place.kind == MapPlaceKind.city,
      MapPlaceFilter.venue => place.kind == MapPlaceKind.venue,
    };
  }
}

enum MapPlaceFilter { all, tourism, food, shop, facility, venue }
