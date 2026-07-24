import 'package:flutter/material.dart';
import 'package:ntbhub_flutter/core/constants/app_strings.dart';
import 'package:ntbhub_flutter/core/extensions/context_extensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.textColor,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final Color? textColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final primary = color ?? context.primaryColor;
    final onPrimary = textColor ?? Colors.white;

    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isOutlined ? primary : onPrimary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: isOutlined ? primary : onPrimary),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isOutlined ? primary : onPrimary,
                ),
              ),
            ],
          );

    if (isOutlined) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: BorderSide(color: primary.withValues(alpha: 0.35)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppStrings.buttonBorderRadius,
              ),
            ),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStrings.buttonBorderRadius),
          ),
        ),
        child: child,
      ),
    );
  }
}
