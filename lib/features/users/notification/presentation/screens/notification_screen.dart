import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/enums/app_enums.dart';
import '../../../../../models/notification_model.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';

final notificationsProvider = FutureProvider<List<NotificationModel>>((
  ref,
) async {
  await Future<void>.delayed(const Duration(milliseconds: 700));
  return MockDataService.notifications;
});

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return AppPageScaffold(
      title: 'Notifikasi',
      actions: [
        TextButton(onPressed: () {}, child: const Text('Tandai dibaca')),
      ],
      body: notificationsAsync.when(
        loading: () => const AppListSkeleton(itemCount: 6),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(
                'Belum ada notifikasi',
                style: TextStyle(color: context.adaptiveTextSecondary),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return _NotificationCard(notification: notifications[index]);
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationModel notification;

  IconData get _icon => switch (notification.type) {
    AppNotificationType.booking => Iconsax.ticket,
    AppNotificationType.order => Iconsax.shopping_cart,
    AppNotificationType.withdraw => Iconsax.wallet_2,
    AppNotificationType.system => Iconsax.setting_2,
  };

  Color _iconColor(BuildContext context) => switch (notification.type) {
    AppNotificationType.booking => context.primaryColor,
    AppNotificationType.order => const Color(0xFF3282B8),
    AppNotificationType.withdraw => AppColors.secondary,
    AppNotificationType.system => context.adaptiveTextSecondary,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? context.cardColor
            : context.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notification.isRead
              ? context.adaptiveDivider
              : context.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _iconColor(context).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_icon, color: _iconColor(context), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    height: 1.4,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatTime(notification.createdAt ?? DateTime.now()),
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return DateFormatter.formatDate(date);
  }
}
