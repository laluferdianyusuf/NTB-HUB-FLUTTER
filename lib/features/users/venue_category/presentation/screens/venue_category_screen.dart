import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/category_icon_mapper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/venue_category_model.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../../../../../widgets/common/category_svg_icon.dart';
import '../providers/venue_category_provider.dart';

class VenueCategoryScreen extends ConsumerWidget {
  const VenueCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    this.categoryIcon,
    this.categoryCode,
  });

  final String categoryId;
  final String categoryName;
  final String? categoryIcon;
  final String? categoryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subCategoriesAsync = ref.watch(
      venueSubCategoriesProvider(categoryId),
    );
    final accent = CategoryIconMapper.accentColor(
      icon: categoryIcon,
      code: categoryCode,
    );

    return AppPageScaffold(
      title: categoryName,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: accent.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: CategorySvgIcon(
                    icon: categoryIcon,
                    code: categoryCode,
                    name: categoryName,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih sub kategori venue',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: subCategoriesAsync.when(
              loading: () => const AppGridSkeleton(itemCount: 6),
              error: (error, _) => _ErrorState(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(venueSubCategoriesProvider(categoryId)),
              ),
              data: (resultValue) => switch (resultValue) {
                result.Success(:final data) => _SubCategoryGrid(
                  subCategories: data,
                ),
                result.Error(:final failure) => _ErrorState(
                  message: failure.message,
                  onRetry: () =>
                      ref.invalidate(venueSubCategoriesProvider(categoryId)),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SubCategoryGrid extends StatelessWidget {
  const _SubCategoryGrid({required this.subCategories});

  final List<VenueSubCategoryModel> subCategories;

  @override
  Widget build(BuildContext context) {
    if (subCategories.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada sub kategori',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final item = subCategories[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => context.showSnackBar('Membuka ${item.name}'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Iconsax.category,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      item.description ?? item.code,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
