import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/change_password_form.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;

  Future<void> _handleSubmit({
    required String currentPassword,
    required String newPassword,
  }) async {
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (currentPassword.length < 6) {
      context.showSnackBar('Password saat ini tidak valid', isError: true);
      return;
    }

    context.showSnackBar('Password berhasil diubah');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Ubah Password',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ChangePasswordForm(
          isLoading: _isLoading,
          onSubmit: _handleSubmit,
        ),
      ),
    );
  }
}
