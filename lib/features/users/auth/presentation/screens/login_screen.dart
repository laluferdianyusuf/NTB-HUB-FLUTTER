import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../providers/auth_provider.dart';
import '../widgets/auth_form_field.dart';
import '../widgets/google_sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;

    final formData = _formKey.currentState!.value;
    setState(() => _isLoading = true);

    final loginResult = await ref
        .read(authProvider.notifier)
        .login(
          email: (formData['email'] as String).trim(),
          password: formData['password'] as String,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    switch (loginResult) {
      case result.Success(:final data):
        if (data.requiresEmailVerification || !data.isAuthenticated) {
          final query = Uri(
            path: '/verify-email',
            queryParameters: {
              'userId': data.userId,
              'email': (formData['email'] as String).trim(),
            },
          ).toString();
          context.go(query);
          return;
        }
        context.go('/home');
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.login,
                      size: 48,
                      color: context.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.adaptiveTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Selamat datang kembali di ${AppStrings.appName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.adaptiveTextSecondary),
                ),
                const SizedBox(height: 40),
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
                  hint: 'Minimal 8 karakter',
                  icon: Iconsax.lock,
                  isPassword: true,
                  validators: [
                    FormBuilderValidators.required(
                      errorText: 'Password wajib diisi',
                    ),
                    FormBuilderValidators.minLength(
                      8,
                      errorText: 'Password minimal 8 karakter',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Lupa Password?'),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
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
                            'Masuk',
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
                    Text(
                      'Belum punya akun?',
                      style: TextStyle(color: context.adaptiveTextSecondary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: const Text(
                        'Daftar',
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
