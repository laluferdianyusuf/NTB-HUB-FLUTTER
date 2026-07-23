import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../models/news_model.dart';

class NewsFeaturedCard extends StatelessWidget {
  const NewsFeaturedCard({super.key, required this.news, this.onTap});

  final NewsModel news;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _NewsImage(
                  imageUrl: news.imageUrl,
                  borderRadius: BorderRadius.zero,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.15),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          news.category ?? "",
                          style: context.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        news.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        news.summary ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Iconsax.user, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              news.author ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Iconsax.clock, size: 14, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatRelative(
                              news.publishedAt ?? DateTime.now(),
                            ),
                            style: context.textTheme.labelSmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class NewsListTileCard extends StatelessWidget {
  const NewsListTileCard({super.key, required this.news, this.onTap});

  final NewsModel news;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.adaptiveDivider),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _NewsImage(
                imageUrl: news.imageUrl,
                width: 96,
                height: 88,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.category ?? "",
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: context.adaptiveTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.summary ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.adaptiveTextSecondary,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${news.author} · ${DateFormatter.formatRelative(news.publishedAt!)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.adaptiveTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewsImage extends StatelessWidget {
  const _NewsImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  BorderRadius get _radius => borderRadius ?? BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: _radius,
      child: Container(
        width: width,
        height: height,
        color: context.primaryColor.withValues(alpha: 0.08),
        child: hasImage
            ? Image.network(
                imageUrl!,
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    _Placeholder(width: width, height: height),
              )
            : _Placeholder(width: width, height: height),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.18),
            AppColors.secondary.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Icon(
        Iconsax.image,
        color: context.primaryColor.withValues(alpha: 0.55),
        size: width == null ? 42 : 28,
      ),
    );
  }
}
