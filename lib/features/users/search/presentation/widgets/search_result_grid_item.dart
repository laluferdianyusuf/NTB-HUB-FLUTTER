import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../models/search_result_item.dart';

class SearchResultGridItem extends StatelessWidget {
  const SearchResultGridItem({super.key, required this.item, this.onTap});

  final SearchResultItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.adaptiveDivider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 92,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: item.gradientColors,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(item.icon, color: Colors.white, size: 32),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.typeLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: context.adaptiveTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 12,
                            color: context.adaptiveTextSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: context.adaptiveTextSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (item.rating != null || item.badge != null) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (item.rating != null) ...[
                              Icon(
                                Iconsax.star,
                                size: 12,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            if (item.rating != null && item.badge != null)
                              const SizedBox(width: 8),
                            if (item.badge != null)
                              Expanded(
                                child: Text(
                                  item.badge!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: context.primaryColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
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
