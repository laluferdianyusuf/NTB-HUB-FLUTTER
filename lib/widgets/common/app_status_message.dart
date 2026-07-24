import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'AppButton.dart';
import 'app_surface_card.dart';

class AppStatusMessage extends StatelessWidget {
  const AppStatusMessage({
    super.key,
    required this.message,
    this.icon = Iconsax.info_circle,
    this.actionLabel,
    this.onAction,
    this.isCompact = false,
  });

  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: isCompact ? 32 : 48, color: context.adaptiveTextSecondary),
        const SizedBox(height: AppSpacing.md),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: context.adaptiveTextSecondary),
        ),
        if (actionLabel != null && onAction != null) ...[
          const SizedBox(height: AppSpacing.lg),
          if (isCompact)
            OutlinedButton.icon(
              onPressed: onAction,
              icon: Icon(Iconsax.refresh, size: 16),
              label: Text(actionLabel!),
            )
          else
            AppButton(
              label: actionLabel!,
              onPressed: onAction,
              height: 48,
            ),
        ],
      ],
    );

    if (isCompact) {
      return AppSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: content,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: content,
      ),
    );
  }
}
