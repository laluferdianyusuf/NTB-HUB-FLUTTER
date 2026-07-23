import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/google_auth_service.dart';
import '../../../../../core/utils/result.dart' as result;
import '../providers/auth_provider.dart';

class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  StreamSubscription<GoogleUserCredential>? _signInSubscription;
  bool _isSigningIn = false;
  bool _isGoogleReady = false;
  String? _initError;

  @override
  void initState() {
    super.initState();
    _prepareGoogleSignIn();
  }

  Future<void> _prepareGoogleSignIn() async {
    if (!GoogleAuthService.isConfigured) return;

    final service = ref.read(googleAuthServiceProvider);

    try {
      await service.ensureWebInitialized();

      _signInSubscription?.cancel();
      _signInSubscription = service.webSignInEvents.listen(_onGoogleSignedIn);

      if (!mounted) return;
      setState(() {
        _isGoogleReady = true;
        _initError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isGoogleReady = false;
        _initError = error.toString();
      });
    }
  }

  Future<void> _onGoogleSignedIn(GoogleUserCredential credential) async {
    if (!mounted || _isSigningIn) return;

    setState(() => _isSigningIn = true);

    final authNotifier = ref.read(authProvider.notifier);
    final loginResult = await authNotifier.loginWithGoogleCredential(
      credential,
    );

    if (!mounted) return;
    setState(() => _isSigningIn = false);

    if (authNotifier.shouldNavigateToHome(loginResult)) {
      context.go('/home');
      return;
    }

    switch (loginResult) {
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
      case result.Success():
        break;
    }
  }

  @override
  void dispose() {
    _signInSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!GoogleAuthService.isConfigured) {
      return SizedBox(
        height: 52,
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            context.showSnackBar(
              'Atur GOOGLE_CLIENT_ID di file .env terlebih dahulu.',
              isError: true,
            );
          },
          child: const Text('Google Sign-In belum dikonfigurasi'),
        ),
      );
    }

    if (_initError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Gagal memuat Google Sign-In',
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _initError = null;
                _isGoogleReady = false;
              });
              _prepareGoogleSignIn();
            },
            child: const Text('Coba lagi'),
          ),
        ],
      );
    }

    if (!_isGoogleReady) {
      return const SizedBox(
        height: 52,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final buttonWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth.clamp(200.0, 400.0)
                : 400.0;

            return ClipRect(
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 52,
                  width: buttonWidth,
                  child: web.renderButton(
                    configuration: web.GSIButtonConfiguration(
                      type: web.GSIButtonType.standard,
                      theme: web.GSIButtonTheme.outline,
                      size: web.GSIButtonSize.large,
                      text: web.GSIButtonText.continueWith,
                      shape: web.GSIButtonShape.rectangular,
                      minimumWidth: buttonWidth,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (_isSigningIn) ...[
          const SizedBox(height: 12),
          const Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ],
      ],
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
