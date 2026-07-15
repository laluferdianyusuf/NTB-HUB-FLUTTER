import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/google_sign_in_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _formKey.currentState!.value;
    setState(() => _isLoading = true);

    final registerResult = await ref.read(authProvider.notifier).register(
          name: (formData['name'] as String).trim(),
          email: (formData['email'] as String).trim(),
          password: formData['password'] as String,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (registerResult) {
      case result.Success():
        context.go('/home');
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.user_add,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Daftar Akun',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bergabung dengan komunitas ${AppStrings.appName}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),
                AuthFormField(
                  name: 'name',
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Iconsax.user,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Nama wajib diisi',
                    ),
                    FormBuilderValidators.minLength(
                      3,
                      errorText: 'Nama minimal 3 karakter',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthFormField(
                  name: 'email',
                  label: 'Email',
                  hint: 'nama@email.com',
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Email wajib diisi',
                    ),
                    FormBuilderValidators.email(
                      errorText: 'Format email tidak valid',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthFormField(
                  name: 'password',
                  label: 'Password',
                  hint: 'Minimal 6 karakter',
                  icon: Iconsax.lock,
                  isPassword: true,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Password wajib diisi',
                    ),
                    FormBuilderValidators.minLength(
                      6,
                      errorText: 'Password minimal 6 karakter',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AuthFormField(
                  name: 'confirmPassword',
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password',
                  icon: Iconsax.lock,
                  isPassword: true,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Konfirmasi password wajib diisi',
                    ),
                    FormBuilderValidators.equal(
                      'password',
                      errorText: 'Password tidak cocok',
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Daftar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                const AuthDivider(),
                const SizedBox(height: 24),
                const GoogleSignInButton(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun?',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
