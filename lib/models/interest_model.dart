import 'package:flutter/material.dart';

import '../core/helpers/json_field_helper.dart';
import '../core/constants/app_colors.dart';

class InterestModel {
  const InterestModel({
    required this.id,
    required this.name,
    required this.color,
  });

  final String id;
  final String name;
  final Color color;

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      id: JsonFieldHelper.readString(json, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(json, ['name', 'title', 'label']) ??
          'Interest',
      color: _parseColor(
        JsonFieldHelper.readString(json, ['color', 'hexColor', 'hex']),
      ),
    );
  }

  static Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;

    var value = hex.replaceFirst('#', '').trim();
    if (value.length == 6) {
      value = 'FF$value';
    }
    if (value.length == 8) {
      final parsed = int.tryParse(value, radix: 16);
      if (parsed != null) return Color(parsed);
    }

    return AppColors.primary;
  }
}
