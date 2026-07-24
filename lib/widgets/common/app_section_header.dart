import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';

enum AppSectionHeaderStyle { standard, compact }

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.style = AppSectionHeaderStyle.standard,
    this.padding,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final AppSectionHeaderStyle style;
  final EdgeInsetsGeometry? padding;
  final Widget? trailing;

  const AppSectionHeader.compact({
    super.key,
    required this.title,
    this.padding,
  })  : subtitle = null,
        style = AppSectionHeaderStyle.compact,
        trailing = null;

  @override
  Widget build(BuildContext context) {
    if (style == AppSectionHeaderStyle.compact) {
      return Padding(
        padding:
            padding ?? const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
        child: Text(
          title,
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.adaptiveTextSecondary,
          ),
        ),
      );
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: context.adaptiveTextPrimary,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );

    if (trailing == null) return content;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: content),
        trailing!,
      ],
    );
  }
}
