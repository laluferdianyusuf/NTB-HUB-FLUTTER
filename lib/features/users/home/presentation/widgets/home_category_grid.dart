import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';

class HomeCategoryItem {
  const HomeCategoryItem({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

abstract final class HomeCategories {
  static const items = [
    HomeCategoryItem(
      label: 'Venue',
      icon: Iconsax.buildings,
      color: AppColors.primary,
    ),
    HomeCategoryItem(
      label: 'Event',
      icon: Iconsax.calendar,
      color: AppColors.secondary,
    ),
    HomeCategoryItem(
      label: 'Public Place',
      icon: Iconsax.tree,
      color: Colors.blue,
    ),
    HomeCategoryItem(
      label: 'Booking',
      icon: Iconsax.ticket,
      color: Colors.purple,
    ),
    HomeCategoryItem(
      label: 'Wisata',
      icon: Iconsax.map,
      color: Colors.teal,
    ),
    HomeCategoryItem(
      label: 'Kuliner',
      icon: Iconsax.coffee,
      color: Colors.orange,
    ),
    HomeCategoryItem(
      label: 'UMKM',
      icon: Iconsax.shop,
      color: Colors.indigo,
    ),
    HomeCategoryItem(
      label: 'Transport',
      icon: Iconsax.car,
      color: Colors.brown,
    ),
  ];
}

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key, this.onCategoryTap});

  final ValueChanged<HomeCategoryItem>? onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.8,
        ),
        itemCount: HomeCategories.items.length,
        itemBuilder: (context, index) {
          final category = HomeCategories.items[index];
          return _CategoryTile(
            category: category,
            onTap: () => onCategoryTap?.call(category),
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, this.onTap});

  final HomeCategoryItem category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(category.icon, color: category.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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
