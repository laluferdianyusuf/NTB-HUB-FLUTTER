import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'app_section_header.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.padding,
    this.scrollable = false,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final content = padding == null
        ? body
        : Padding(padding: padding!, child: body);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
        actions: actions,
      ),
      body: scrollable
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
              child: content,
            )
          : content,
    );
  }
}

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? context.primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: titleColor ?? context.adaptiveTextPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.adaptiveTextSecondary,
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Iconsax.arrow_right_3,
            color: context.adaptiveTextSecondary,
            size: 18,
          ),
      onTap: onTap,
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppSectionHeader.compact(title: title);
  }
}

class StaticContentScreen extends StatelessWidget {
  const StaticContentScreen({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      scrollable: true,
      body: Text(
        content,
        style: context.textTheme.bodyMedium?.copyWith(
          color: context.adaptiveTextPrimary,
          height: 1.6,
        ),
      ),
    );
  }
}
