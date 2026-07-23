import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/news_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/news_provider.dart';
import '../utils/news_navigation.dart';
import '../widgets/news_cards.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: newsAsync.when(
          loading: () => const _NewsLoadingView(),
          error: (error, _) => _NewsErrorView(
            message: error.toString(),
            onRetry: () => ref.invalidate(newsListProvider),
          ),
          data: (resultValue) => switch (resultValue) {
            result.Success(:final data) => _NewsContent(
              newsList: data,
              onRefresh: () async => ref.invalidate(newsListProvider),
            ),
            result.Error(:final failure) => _NewsErrorView(
              message: failure.message,
              onRetry: () => ref.invalidate(newsListProvider),
            ),
          },
        ),
      ),
    );
  }
}

class _NewsContent extends StatelessWidget {
  const _NewsContent({required this.newsList, required this.onRefresh});

  final List<NewsModel> newsList;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 120),
            Icon(
              Iconsax.document,
              size: 48,
              color: context.adaptiveTextSecondary,
            ),
            SizedBox(height: 12),
            Center(child: Text('Belum ada berita')),
          ],
        ),
      );
    }

    final featured = newsList.first;
    final others = newsList.length > 1 ? newsList.sublist(1) : <NewsModel>[];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Berita',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: context.adaptiveTextPrimary,
                      ),
                    ),
                  ),
                  IconButton(onPressed: onRefresh, icon: Icon(Iconsax.refresh)),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                'Berita Terbaru',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: context.adaptiveTextPrimary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: NewsFeaturedCard(
                news: featured,
                onTap: () => openNewsDetail(context, featured),
              ),
            ),
          ),
          if (others.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Berita Lainnya',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.adaptiveTextPrimary,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList.separated(
                itemCount: others.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final news = others[index];
                  return NewsListTileCard(
                    news: news,
                    onTap: () => openNewsDetail(context, news),
                  );
                },
              ),
            ),
          ] else
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class _NewsLoadingView extends StatelessWidget {
  const _NewsLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        AppSkeleton(height: 28, width: 120),
        SizedBox(height: 20),
        AppSkeleton(height: 260, width: double.infinity, borderRadius: 20),
        SizedBox(height: 24),
        AppSkeleton(height: 18, width: 140),
        SizedBox(height: 12),
        AppSkeleton(height: 110, width: double.infinity, borderRadius: 16),
        SizedBox(height: 12),
        AppSkeleton(height: 110, width: double.infinity, borderRadius: 16),
      ],
    );
  }
}

class _NewsErrorView extends StatelessWidget {
  const _NewsErrorView({required this.message, required this.onRetry});

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
