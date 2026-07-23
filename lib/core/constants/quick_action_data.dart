import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/app_colors.dart';

class QuickActionDefinition {
  const QuickActionDefinition({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    required this.color,
  });

  final String id;
  final String label;
  final IconData icon;
  final String route;
  final Color color;
}

abstract final class QuickActionData {
  static const actions = [
    QuickActionDefinition(
      id: 'order_food',
      label: 'Order Food',
      icon: Iconsax.coffee,
      route: '/quick/order-food',
      color: Color(0xFFE76F51),
    ),
    QuickActionDefinition(
      id: 'top_up',
      label: 'Top Up Balance',
      icon: Iconsax.wallet_add,
      route: '/quick/top-up',
      color: Color(0xFF2A9D8F),
    ),
    QuickActionDefinition(
      id: 'promo',
      label: 'Promo Deals',
      icon: Iconsax.gift,
      route: '/quick/promo-deals',
      color: Color(0xFF6A0572),
    ),
    QuickActionDefinition(
      id: 'new_products',
      label: 'New Products',
      icon: Iconsax.box,
      route: '/quick/new-products',
      color: AppColors.primary,
    ),
  ];
}
