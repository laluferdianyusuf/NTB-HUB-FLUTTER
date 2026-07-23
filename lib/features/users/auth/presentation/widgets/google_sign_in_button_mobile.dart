import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import 'google_account_picker_sheet.dart';
import '../../../../../core/extensions/context_extensions.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => GoogleAccountPickerSheet.show(context),
        icon: const _GoogleLogo(),
        label: Text(
          'Lanjutkan dengan Google',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: context.adaptiveTextPrimary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.adaptiveDivider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.adaptiveDivider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('atau', style: TextStyle(color: context.adaptiveTextSecondary)),
        ),
        Expanded(child: Divider(color: context.adaptiveDivider)),
      ],
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
