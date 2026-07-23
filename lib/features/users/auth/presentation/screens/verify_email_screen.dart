import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  final String userId;
  final String email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendCooldown = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startResendCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _resendCooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendCooldown <= 1) {
        timer.cancel();
        setState(() => _resendCooldown = 0);
        return;
      }

      setState(() => _resendCooldown -= 1);
    });
  }

  Future<void> _handleVerify() async {
    final pin = _pinController.text.trim();
    if (pin.length != 6) {
      context.showSnackBar('PIN harus 6 digit', isError: true);
      return;
    }

    setState(() => _isVerifying = true);

    final verifyResult = await ref
        .read(authProvider.notifier)
        .verifyEmail(userId: widget.userId, pin: pin);

    if (!mounted) return;
    setState(() => _isVerifying = false);

    switch (verifyResult) {
      case result.Success():
        context.showSnackBar('Email berhasil diverifikasi');
        context.go('/home');
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
    }
  }

  Future<void> _handleResend() async {
    if (_resendCooldown > 0 || _isResending) return;

    setState(() => _isResending = true);

    final resendResult = await ref
        .read(authProvider.notifier)
        .resendVerification(email: widget.email);

    if (!mounted) return;
    setState(() => _isResending = false);

    switch (resendResult) {
      case result.Success():
        _startResendCooldown();
        context.showSnackBar(
          'Kode verifikasi telah dikirim ulang ke ${widget.email}',
        );
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: context.adaptiveTextPrimary,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_3),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.sms,
                    size: 48,
                    color: context.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Verifikasi Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.adaptiveTextPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan PIN 6 digit yang dikirim ke\n${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.adaptiveTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _pinController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                obscureText: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                  color: context.adaptiveTextPrimary,
                ),
                decoration: context.appInputDecoration(
                  counterText: '',
                  hintText: '••••••',
                ),
                onSubmitted: (_) => _handleVerify(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _handleVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Verifikasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _resendCooldown > 0 || _isResending
                    ? null
                    : _handleResend,
                child: _isResending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _resendCooldown > 0
                            ? 'Kirim ulang dalam $_resendCooldown detik'
                            : 'Kirim ulang kode verifikasi',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
