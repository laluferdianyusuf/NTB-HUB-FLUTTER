import 'package:flutter/material.dart';

class HomeTabItem {
  const HomeTabItem({
    required this.label,
    required this.builder,
  });

  final String label;
  final WidgetBuilder builder;
}
