import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/constants/app_colors.dart';
import 'app_text_field.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
  });

  final Future<void> Function({
    required String currentPassword,
    required String newPassword,
  }) onSubmit;
  final bool isLoading;

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await widget.onSubmit(
      currentPassword: _currentController.text,
      newPassword: _newController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _currentController,
            label: 'Password Saat Ini',
            hint: 'Masukkan password saat ini',
            prefixIcon: Iconsax.lock,
            isPassword: true,
            validator: (v) =>
                v == null || v.isEmpty ? 'Password saat ini wajib diisi' : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _newController,
            label: 'Password Baru',
            hint: 'Minimal 8 karakter',
            prefixIcon: Iconsax.lock,
            isPassword: true,
            validator: (v) => v == null || v.length < 8
                ? 'Password baru minimal 8 karakter'
                : null,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _confirmController,
            label: 'Konfirmasi Password Baru',
            hint: 'Ulangi password baru',
            prefixIcon: Iconsax.lock,
            isPassword: true,
            validator: (v) =>
                v != _newController.text ? 'Password tidak cocok' : null,
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Simpan Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
