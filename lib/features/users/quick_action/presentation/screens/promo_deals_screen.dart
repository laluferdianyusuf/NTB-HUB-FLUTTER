import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/quick_action_models.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';

final promoDealsProvider = FutureProvider<List<PromoDealModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 550));
  return MockDataService.promoDeals;
});

class PromoDealsScreen extends ConsumerWidget {
  const PromoDealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final promosAsync = ref.watch(promoDealsProvider);

    return AppPageScaffold(
      title: 'Promo Deals',
      body: promosAsync.when(
        loading: () => const AppListSkeleton(itemCount: 4),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (promos) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: promos.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final promo = promos[index];
            return _PromoCard(
              promo: promo,
              onClaim: () =>
                  context.showSnackBar('Promo "${promo.title}" diklaim'),
            );
          },
        ),
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  const _PromoCard({required this.promo, required this.onClaim});

  final PromoDealModel promo;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.adaptiveDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primaryColor.withValues(alpha: 0.9),
                  const Color(0xFF6A0572).withValues(alpha: 0.85),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    promo.discountLabel,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Iconsax.gift, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  promo.title,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  promo.description,
                  style: TextStyle(
                    color: context.adaptiveTextSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Iconsax.tag,
                      size: 14,
                      color: context.adaptiveTextSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      promo.category,
                      style: TextStyle(
                        color: context.adaptiveTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Berlaku s/d ${DateFormatter.formatDate(promo.validUntil)}',
                      style: TextStyle(
                        color: context.adaptiveTextSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onClaim,
                    child: const Text('Klaim Promo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
