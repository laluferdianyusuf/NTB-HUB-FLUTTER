import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../models/news_model.dart';
import '../../../../../repository/news_repository.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  static const _pageSize = NewsRepository.pageSize;
  final _repository = NewsRepository();

  late final PagingController<int, NewsModel> _pagingController =
      PagingController<int, NewsModel>(
    getNextPageKey: (state) {
      if (state.items == null) return 1;
      if (state.items!.isEmpty) return null;
      if (state.items!.length % _pageSize != 0) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) async {
      final result = await _repository.getNewsPage(pageKey);
      if (!result.hasNextPage && result.items.isEmpty && pageKey > 1) {
        return [];
      }
      return result.items;
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: PagingListener<int, NewsModel>(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, NewsModel>(
              state: state,
              fetchNextPage: fetchNextPage,
              padding: const EdgeInsets.all(16),
              builderDelegate: PagedChildBuilderDelegate<NewsModel>(
                itemBuilder: (context, news, index) => _NewsCard(news: news),
                firstPageErrorIndicatorBuilder: (context) => _ErrorView(
                  message: 'Gagal memuat berita',
                  onRetry: () => _pagingController.refresh(),
                ),
                newPageErrorIndicatorBuilder: (context) => _ErrorView(
                  message: 'Gagal memuat halaman berikutnya',
                  onRetry: fetchNextPage,
                ),
                noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text('Belum ada berita'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.news});

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                news.category,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              news.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              news.summary,
              style: const TextStyle(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${news.author} · ${DateFormatter.formatRelative(news.publishedAt)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}
