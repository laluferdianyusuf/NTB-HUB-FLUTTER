import 'package:flutter/material.dart';
import 'package:ntbhub_flutter/core/constants/app_colors.dart';

import '../../core/extensions/context_extensions.dart';
import '../../core/helpers/user_avatar_helper.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 22,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final primaryUrl = UserAvatarHelper.resolveUrl(
      name: name,
      imageUrl: imageUrl,
    );
    final fallbackUrl = UserAvatarHelper.fallbackUrl(name);
    final size = radius * 2;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      child: ClipOval(
        child: Image.network(
          primaryUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) {
            if (primaryUrl != fallbackUrl) {
              return Image.network(
                fallbackUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    _InitialsFallback(name: name, radius: radius),
              );
            }
            return _InitialsFallback(name: name, radius: radius);
          },
        ),
      ),
    );
  }
}

class _InitialsFallback extends StatelessWidget {
  const _InitialsFallback({required this.name, required this.radius});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return Container(
      width: radius * 2,
      height: radius * 2,
      color: context.primaryColor.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
          color: context.primaryColor,
        ),
      ),
    );
  }
}
