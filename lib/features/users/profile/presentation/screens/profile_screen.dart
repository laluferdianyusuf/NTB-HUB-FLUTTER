import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../../../repository/user_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final profileProvider = FutureProvider<result.Result<UserModel>>((ref) async {
  final repository = UserRepository();
  return repository.getCurrentUser();
});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.name[0],
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user.location != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.location!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          _ProfileMenuItem(
            icon: Iconsax.sms,
            title: user.email,
          ),
          if (user.bio != null)
            _ProfileMenuItem(
              icon: Iconsax.document_text,
              title: user.bio!,
            ),
          _ProfileMenuItem(
            icon: Iconsax.calendar,
            title: 'Bergabung ${DateFormatter.formatDate(user.joinedAt)}',
          ),
          const Divider(height: 32),
          _ProfileMenuItem(
            icon: Iconsax.ticket,
            title: 'Booking Venue',
            onTap: () => context.push('/booking'),
          ),
          _ProfileMenuItem(
            icon: Iconsax.calendar,
            title: 'Lihat Event',
            onTap: () => context.push('/events'),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Iconsax.logout, color: AppColors.error),
            title: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title),
      trailing: const Icon(
        Iconsax.arrow_right_3,
        color: AppColors.textSecondary,
        size: 18,
      ),
      onTap: onTap,
    );
  }
}

