import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';

class AppTabPageHeader extends StatelessWidget {
  const AppTabPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.md,
      AppSpacing.lg,
      0,
    ),
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.adaptiveTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.adaptiveTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
