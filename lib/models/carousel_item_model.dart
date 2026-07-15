import 'package:flutter/material.dart';

class CarouselItemModel {
  const CarouselItemModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.gradientColors,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final List<Color> gradientColors;
}
