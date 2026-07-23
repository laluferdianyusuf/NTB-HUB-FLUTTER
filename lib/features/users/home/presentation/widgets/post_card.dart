import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../domain/entities/post_entity.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.adaptiveDivider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    post.authorName[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        DateFormatter.formatRelative(post.createdAt),
                        style: TextStyle(
                          color: context.adaptiveTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Iconsax.heart,
                  size: 18,
                  color: context.adaptiveTextSecondary,
                ),
                const SizedBox(width: 4),
                Text('${post.likes}'),
                const SizedBox(width: 16),
                Icon(
                  Iconsax.message,
                  size: 18,
                  color: context.adaptiveTextSecondary,
                ),
                const SizedBox(width: 4),
                Text('${post.comments}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
