import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/extensions/context_extensions.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
        actions: actions,
      ),
      body: body,
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
      leading: Icon(icon, color: iconColor ?? context.primaryColor, size: 22),
      title: Text(
        title,
        style: context.textTheme.bodyLarge?.copyWith(
          color: titleColor ?? context.adaptiveTextPrimary,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: context.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.adaptiveTextSecondary,
        ),
      ),
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Text(
          content,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.adaptiveTextPrimary,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
