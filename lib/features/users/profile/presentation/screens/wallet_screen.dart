import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/currency_formatter.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/wallet_model.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_status_message.dart';
import '../providers/wallet_provider.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(walletBalanceProvider);

    return AppPageScaffold(
      title: 'Dompet',
      actions: [
        IconButton(
          onPressed: () => ref.invalidate(walletBalanceProvider),
          icon: const Icon(Iconsax.refresh),
          tooltip: 'Perbarui saldo',
        ),
      ],
      body: balanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppStatusMessage(
          message: error.toString(),
          actionLabel: 'Coba Lagi',
          onAction: () => ref.invalidate(walletBalanceProvider),
        ),
        data: (balanceResult) => switch (balanceResult) {
          result.Success(:final data) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(walletBalanceProvider);
              await ref.read(walletBalanceProvider.future);
            },
            child: _WalletContent(wallet: data),
          ),
          result.Error(:final failure) => AppStatusMessage(
            message: failure.message,
            actionLabel: 'Coba Lagi',
            onAction: () => ref.invalidate(walletBalanceProvider),
          ),
        },
      ),
    );
  }
}

class _WalletContent extends StatelessWidget {
  const _WalletContent({required this.wallet});

  final WalletSnapshot wallet;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(
          width: double.infinity,
          // padding: const EdgeInsets.all(24),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       context.primaryColor,
          //       context.primaryColor.withValues(alpha: 0.75),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          //   borderRadius: BorderRadius.circular(20),
          //   boxShadow: [
          //     BoxShadow(
          //       color: context.primaryColor.withValues(alpha: 0.25),
          //       blurRadius: 16,
          //       offset: const Offset(0, 8),
          //     ),
          //   ],
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Iconsax.wallet_2, color: context.primaryColor),
                  ),
                  const Spacer(),
                  if (wallet.updatedAt != null)
                    Text(
                      'Diperbarui ${DateFormatter.formatRelative(wallet.updatedAt!)}',
                      style: TextStyle(
                        color: context.primaryColor.withValues(alpha: 0.8),
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Saldo NTB Hub',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.formatIdr(wallet.balance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Aksi Cepat',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _WalletActionTile(
          icon: Iconsax.wallet_add,
          title: 'Top Up Saldo',
          subtitle: 'Isi saldo dompet NTB Hub',
          onTap: () => context.push('/quick/top-up'),
        ),
        _WalletActionTile(
          icon: Iconsax.receipt,
          title: 'Riwayat Transaksi',
          subtitle: 'Lihat semua transaksi dompet',
          onTap: () => context.push('/profile/transactions'),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.adaptiveDivider),
          ),
          child: Row(
            children: [
              Icon(Iconsax.info_circle, color: context.primaryColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Saldo dompet dapat digunakan untuk booking venue, event, dan layanan di NTB Hub.',
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletActionTile extends StatelessWidget {
  const _WalletActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.adaptiveDivider),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: context.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: context.adaptiveTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Iconsax.arrow_right_3,
                  color: context.adaptiveTextSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
