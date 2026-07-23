import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/google_auth_service.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/auth_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/auth_provider.dart';

class GoogleAccountPickerSheet extends ConsumerStatefulWidget {
  const GoogleAccountPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GoogleAccountPickerSheet(),
    );
  }

  @override
  ConsumerState<GoogleAccountPickerSheet> createState() =>
      _GoogleAccountPickerSheetState();
}

class _GoogleAccountPickerSheetState
    extends ConsumerState<GoogleAccountPickerSheet> {
  List<GoogleAccountInfo> _accounts = [];
  bool _loading = true;
  bool _signingIn = false;
  String? _selectedEmail;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final service = ref.read(googleAuthServiceProvider);
    final accounts = await service.getAvailableAccounts();
    if (!mounted) return;
    setState(() {
      _accounts = accounts;
      _loading = false;
    });
  }

  void _handleGoogleLoginResult(result.Result<AuthModel> loginResult) {
    final authNotifier = ref.read(authProvider.notifier);

    if (authNotifier.shouldNavigateToHome(loginResult)) {
      if (!mounted) return;
      Navigator.of(context).pop();
      context.go('/home');
      return;
    }

    switch (loginResult) {
      case result.Success(:final data):
        if (data.requiresEmailVerification || !data.isAuthenticated) {
          if (!mounted) return;
          Navigator.of(context).pop();
          final query = Uri(
            path: '/verify-email',
            queryParameters: {'userId': data.userId, 'email': data.email},
          ).toString();
          context.go(query);
          return;
        }
      case result.Error(:final failure):
        context.showSnackBar(failure.message, isError: true);
    }
  }

  Future<void> _signInWithAccount(GoogleAccountInfo account) async {
    setState(() {
      _signingIn = true;
      _selectedEmail = account.email;
    });

    final loginResult = await ref
        .read(authProvider.notifier)
        .loginWithGoogleAccount(account);

    if (!mounted) return;
    setState(() => _signingIn = false);

    _handleGoogleLoginResult(loginResult);
  }

  Future<void> _pickAnotherAccount() async {
    if (kIsWeb) {
      context.showSnackBar(
        'Gunakan tombol "Continue with Google" di layar login.',
        isError: true,
      );
      return;
    }

    if (!GoogleAuthService.isConfigured) {
      context.showSnackBar(
        'Atur GOOGLE_CLIENT_ID di file .env terlebih dahulu.',
        isError: true,
      );
      return;
    }

    setState(() => _signingIn = true);
    final loginResult = await ref.read(authProvider.notifier).loginWithGoogle();
    if (!mounted) return;
    setState(() => _signingIn = false);

    _handleGoogleLoginResult(loginResult);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? context.adaptiveSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.paddingOf(context).bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: context.adaptiveDivider,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih Akun Google',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Lanjutkan ke NTB Hub dengan akun Google Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: context.adaptiveTextSecondary),
          ),
          const SizedBox(height: 20),
          if (_loading)
            const AppListSkeleton(itemCount: 3)
          else ...[
            if (_accounts.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Belum ada akun Google tersimpan. Pilih akun Google Anda di bawah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.adaptiveTextSecondary),
                ),
              ),
            ..._accounts.map((account) {
              final isLoadingThis =
                  _signingIn && _selectedEmail == account.email;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _signingIn
                        ? null
                        : () => _signInWithAccount(account),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: context.primaryColor.withValues(
                              alpha: 0.12,
                            ),
                            child: Text(
                              account.initial,
                              style: TextStyle(
                                color: context.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.displayName,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  account.email,
                                  style: TextStyle(
                                    color: context.adaptiveTextSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isLoadingThis)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
                            Icon(
                              Iconsax.arrow_right_3,
                              size: 18,
                              color: context.adaptiveTextSecondary,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: _signingIn ? null : _pickAnotherAccount,
              icon: const _GoogleLogo(),
              label: const Text('Gunakan akun Google lain'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: BorderSide(color: context.adaptiveDivider),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
