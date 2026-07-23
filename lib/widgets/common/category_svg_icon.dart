import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/helpers/category_icon_mapper.dart';

class CategorySvgIcon extends StatelessWidget {
  const CategorySvgIcon({
    super.key,
    required this.icon,
    this.code,
    this.name,
    this.size = 24,
  });

  final String? icon;
  final String? code;
  final String? name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final assetPath = CategoryIconMapper.svgAsset(
      icon: icon,
      code: code,
      name: name,
    );

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      placeholderBuilder: (_) => Icon(
        CategoryIconMapper.fallbackIcon(icon: icon),
        size: size,
        color: context.adaptiveTextSecondary,
      ),
    );
  }
}
