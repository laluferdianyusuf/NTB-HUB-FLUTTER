import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(
      label: 'Home',
      outlineIcon: Iconsax.home,
      filledIcon: Iconsax.home_1,
    ),
    _NavItem(
      label: 'News',
      outlineIcon: Iconsax.document_text,
      filledIcon: Iconsax.document_text_1,
    ),
    _NavItem(
      label: 'Groups',
      outlineIcon: Iconsax.people,
      filledIcon: Iconsax.people,
    ),
    _NavItem(
      label: 'Activity',
      outlineIcon: Iconsax.activity,
      filledIcon: Iconsax.activity,
    ),
    _NavItem(
      label: 'Profile',
      outlineIcon: Iconsax.profile_circle,
      filledIcon: Iconsax.profile_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSelected ? item.filledIcon : item.outlineIcon,
                        size: 22,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.outlineIcon,
    required this.filledIcon,
  });

  final String label;
  final IconData outlineIcon;
  final IconData filledIcon;
}
