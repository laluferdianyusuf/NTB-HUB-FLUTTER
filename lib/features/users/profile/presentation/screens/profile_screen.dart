import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/theme_settings_service.dart';
import '../../../../../core/theme/theme_provider.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../../../widgets/common/app_confirm_dialog.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_status_message.dart';
import '../../../../../widgets/common/app_tab_page_header.dart';
import '../../../../../widgets/common/user_avatar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/profile_settings_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => AppStatusMessage(
            message: error.toString(),
            actionLabel: 'Coba Lagi',
            onAction: () => ref.invalidate(profileProvider),
          ),
          data: (resultValue) => switch (resultValue) {
            result.Success(:final data) => _ProfileContent(user: data),
            result.Error(:final failure) => AppStatusMessage(
              message: failure.message,
              actionLabel: failure.message == 'Belum login'
                  ? 'Masuk'
                  : 'Coba Lagi',
              onAction: () {
                if (failure.message == 'Belum login') {
                  context.go('/login');
                } else {
                  ref.invalidate(profileProvider);
                }
              },
            ),
          },
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  const _ProfileContent({required this.user});

  final UserModel user;

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Keluar dari Akun',
      message: 'Apakah Anda yakin ingin keluar dari NTB Hub?',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
      isDestructive: true,
    );

    if (confirmed != true || !context.mounted) return;
    await ref.read(authProvider.notifier).logout();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(profileSettingsProvider);
    final themeState = ref.watch(appThemeProvider);

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.section),
      children: [
        const AppTabPageHeader(title: 'Profile'),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatar(name: user.name, imageUrl: user.avatarUrl, radius: 48),
              const SizedBox(height: 16),
              Text(
                user.name.isNotEmpty ? user.name : 'Pengguna',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.adaptiveTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              UnconstrainedBox(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () => context.push('/profile/manage'),
                  child: const Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
        const ProfileSectionHeader(title: 'Dompet'),
        ProfileMenuTile(
          icon: Iconsax.wallet,
          title: 'Dompet',
          subtitle: _themeSubtitle(themeState),
          onTap: () => context.push('/profile/theme'),
        ),
        const ProfileSectionHeader(title: 'Tampilan'),
        ProfileMenuTile(
          icon: Iconsax.colorfilter,
          title: 'Tema Aplikasi',
          subtitle: _themeSubtitle(themeState),
          onTap: () => context.push('/profile/theme'),
        ),
        const ProfileSectionHeader(title: 'Akun'),
        ProfileMenuTile(
          icon: Iconsax.user_edit,
          title: 'Manage Profile',
          onTap: () => context.push('/profile/manage'),
        ),
        ProfileMenuTile(
          icon: Iconsax.lock,
          title: 'Password & Security',
          onTap: () => context.push('/profile/password-security'),
        ),
        ProfileMenuTile(
          icon: Iconsax.password_check,
          title: 'Transaction PIN',
          subtitle: settingsAsync.maybeWhen(
            data: (s) =>
                s.hasTransactionPin ? 'PIN sudah diatur' : 'Belum diatur',
            orElse: () => null,
          ),
          onTap: () => context.push('/profile/transaction-pin'),
        ),
        settingsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (state) => SwitchListTile(
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Iconsax.finger_scan, color: context.primaryColor),
            ),
            title: const Text('Enable Biometric'),
            subtitle: const Text(
              'Login cepat dengan sidik jari / Face ID',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            value: state.biometricEnabled,
            activeThumbColor: context.primaryColor,
            onChanged: (value) {
              ref.read(profileSettingsProvider.notifier).toggleBiometric(value);
              context.showSnackBar(
                value ? 'Biometric diaktifkan' : 'Biometric dinonaktifkan',
              );
            },
          ),
        ),
        const ProfileSectionHeader(title: 'Aktivitas'),
        ProfileMenuTile(
          icon: Iconsax.heart,
          title: 'Favorite Venues',
          onTap: () => context.push('/profile/favorite-venues'),
        ),
        ProfileMenuTile(
          icon: Iconsax.receipt,
          title: 'Transaction',
          onTap: () => context.push('/profile/transactions'),
        ),
        const ProfileSectionHeader(title: 'Informasi'),
        ProfileMenuTile(
          icon: Iconsax.info_circle,
          title: 'About Us',
          onTap: () => context.push('/profile/about'),
        ),
        ProfileMenuTile(
          icon: Iconsax.message_question,
          title: 'Help Center',
          onTap: () => context.push('/profile/help'),
        ),
        ProfileMenuTile(
          icon: Iconsax.shield,
          title: 'Privacy and Policy',
          onTap: () => context.push('/profile/privacy'),
        ),
        ProfileMenuTile(
          icon: Iconsax.document,
          title: 'Terms and Conditions',
          onTap: () => context.push('/profile/terms'),
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Iconsax.logout, color: Colors.red),
          title: const Text('Logout', style: TextStyle(color: Colors.red)),
          onTap: () => _handleLogout(context, ref),
        ),
        const SizedBox(height: AppSpacing.section),
      ],
    );
  }

  String _themeSubtitle(AppThemeState themeState) {
    final modeLabel = switch (themeState.preference) {
      AppThemePreference.light => 'Terang',
      AppThemePreference.dark => 'Gelap',
      AppThemePreference.system => 'Sistem',
    };
    return 'Theme · $modeLabel';
  }
}
