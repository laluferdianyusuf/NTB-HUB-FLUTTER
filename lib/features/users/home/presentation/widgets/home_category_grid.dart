import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/category_icon_mapper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/venue_category_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../../../../../widgets/common/category_svg_icon.dart';
import '../../../venue_category/presentation/providers/venue_category_provider.dart';

class HomeCategoryGrid extends ConsumerWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(venueCategoriesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: categoriesAsync.when(
        loading: () => const SizedBox(
          height: 220,
          child: AppGridSkeleton(itemCount: 8, crossAxisCount: 4),
        ),
        error: (error, _) => _CategoryError(
          onRetry: () => ref.invalidate(venueCategoriesProvider),
        ),
        data: (resultValue) => switch (resultValue) {
          result.Success(:final data) => _CategoryGridContent(categories: data),
          result.Error(:final failure) => _CategoryError(
            message: failure.message,
            onRetry: () => ref.invalidate(venueCategoriesProvider),
          ),
        },
      ),
    );
  }
}

class _CategoryGridContent extends StatelessWidget {
  const _CategoryGridContent({required this.categories});

  final List<VenueCategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'Kategori belum tersedia',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          onTap: () {
            final query = Uri(
              queryParameters: {
                'name': category.name,
                'icon': category.icon,
                'code': category.code,
              },
            ).query;
            context.push('/venue-category/${category.id}?$query');
          },
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final VenueCategoryModel category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = CategoryIconMapper.accentColor(
      icon: category.icon,
      code: category.code,
    );

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CategorySvgIcon(
                  icon: category.icon,
                  code: category.code,
                  name: category.name,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.15,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryError extends StatelessWidget {
  const _CategoryError({this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'Gagal memuat kategori',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
