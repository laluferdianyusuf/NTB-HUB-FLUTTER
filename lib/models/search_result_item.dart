import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum SearchResultType { venue, event, publicPlace }

class SearchResultItem {
  const SearchResultItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.type,
    this.rating,
    this.badge,
  });

  final String id;
  final String title;
  final String subtitle;
  final String location;
  final SearchResultType type;
  final double? rating;
  final String? badge;

  String get typeLabel => switch (type) {
    SearchResultType.venue => 'Venue',
    SearchResultType.event => 'Event',
    SearchResultType.publicPlace => 'Public Place',
  };

  IconData get icon => switch (type) {
    SearchResultType.venue => Iconsax.buildings,
    SearchResultType.event => Iconsax.calendar,
    SearchResultType.publicPlace => Iconsax.tree,
  };

  List<Color> get gradientColors => switch (type) {
    SearchResultType.venue => [
      const Color(0xFF1B5E4B),
      const Color(0xFF2E8B6E),
    ],
    SearchResultType.event => [
      const Color(0xFF0F4C75),
      const Color(0xFF3282B8),
    ],
    SearchResultType.publicPlace => [
      const Color(0xFF6A0572),
      const Color(0xFFAB83A1),
    ],
  };
}
