import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/quick_action_models.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';

final topUpProvider = FutureProvider<List<TopUpPackageModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return MockDataService.topUpPackages;
});

class TopUpBalanceScreen extends ConsumerStatefulWidget {
  const TopUpBalanceScreen({super.key});

  @override
  ConsumerState<TopUpBalanceScreen> createState() => _TopUpBalanceScreenState();
}

class _TopUpBalanceScreenState extends ConsumerState<TopUpBalanceScreen> {
  String? _selectedId;
  bool _processing = false;

  Future<void> _topUp(TopUpPackageModel package) async {
    setState(() {
      _selectedId = package.id;
      _processing = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _processing = false);
    context.showSnackBar(
      'Top up ${package.formattedAmount} berhasil${package.bonus > 0 ? ' (+ bonus Rp ${package.bonus})' : ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(topUpProvider);
    final balance = MockDataService.walletBalance;

    return AppPageScaffold(
      title: 'Top Up Balance',
      body: packagesAsync.when(
        loading: () => const AppListSkeleton(itemCount: 4),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (packages) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A9D8F), Color(0xFF1B5E4B)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saldo NTB Hub',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${balance.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Pilih Nominal Top Up',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...packages.map((package) {
              final isSelected = _selectedId == package.id;
              final isLoading = _processing && isSelected;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: isLoading ? null : () => _topUp(package),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? context.primaryColor
                              : context.adaptiveDivider,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Iconsax.wallet_add,
                              color: context.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      package.formattedAmount,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (package.isPopular) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary.withValues(
                                            alpha: 0.15,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const Text(
                                          'Populer',
                                          style: TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                if (package.bonus > 0)
                                  Text(
                                    'Bonus Rp ${package.bonus}',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isLoading)
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          else
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
            }),
          ],
        ),
      ),
    );
  }
}
