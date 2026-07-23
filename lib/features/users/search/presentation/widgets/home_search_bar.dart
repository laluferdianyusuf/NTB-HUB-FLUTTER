import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Material(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => context.push('/search'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.adaptiveDivider),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.search_normal,
                  color: context.adaptiveTextSecondary,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cari venue, event, public place...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.adaptiveTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
