import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../../../widgets/common/app_confirm_dialog.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
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
      backgroundColor: AppColors.background,
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (resultValue) => switch (resultValue) {
          result.Success(:final data) => _ProfileContent(user: data),
          result.Error(:final failure) => Center(child: Text(failure.message)),
        },
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),

            child: Row(
              children: [
                UserAvatar(
                  name: user.name,
                  imageUrl: user.avatarUrl,
                  radius: 22,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
              secondary: const Icon(
                Iconsax.finger_scan,
                color: AppColors.primary,
              ),
              title: const Text('Enable Biometric'),
              subtitle: const Text('Login cepat dengan sidik jari / Face ID'),
              value: state.biometricEnabled,
              activeThumbColor: AppColors.primary,
              onChanged: (value) {
                ref
                    .read(profileSettingsProvider.notifier)
                    .toggleBiometric(value);
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
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _handleLogout(context, ref),
                icon: const Icon(Iconsax.logout, color: AppColors.error),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
