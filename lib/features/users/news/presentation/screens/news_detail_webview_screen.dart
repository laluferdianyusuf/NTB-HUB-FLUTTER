import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../core/webview/webview_support.dart';
import '../../../../../models/news_model.dart';
import '../providers/news_provider.dart';

class NewsDetailWebViewScreen extends ConsumerWidget {
  const NewsDetailWebViewScreen({
    super.key,
    required this.newsId,
    this.initialNews,
  });

  final String newsId;
  final NewsModel? initialNews;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(newsDetailProvider(newsId));
    final resolvedNews = _resolveNews(detailAsync, initialNews);

    if (resolvedNews != null && resolvedNews.hasValidExternalUrl) {
      return _NewsDetailContent(news: resolvedNews);
    }

    return detailAsync.when(
      loading: () => _NewsDetailScaffold(
        title: initialNews?.title ?? 'Berita',
        onOpenBrowser: null,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _NewsDetailScaffold(
        title: initialNews?.title ?? 'Berita',
        onOpenBrowser: null,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => ref.invalidate(newsDetailProvider(newsId)),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => () {
          final merged = data.mergeWith(initialNews);
          if (merged.hasValidExternalUrl) {
            return _NewsDetailContent(news: merged);
          }
          return _NewsDetailScaffold(
            title: merged.title,
            onOpenBrowser: null,
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'URL website berita tidak tersedia. '
                  'Pastikan backend mengirim field website/url.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }(),
        result.Error(:final failure) => _NewsDetailScaffold(
          title: initialNews?.title ?? 'Berita',
          onOpenBrowser: null,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(failure.message, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(newsDetailProvider(newsId)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      },
    );
  }

  NewsModel? _resolveNews(
    AsyncValue<result.Result<NewsModel>> detailAsync,
    NewsModel? initialNews,
  ) {
    return switch (detailAsync) {
      AsyncData(:final value) => switch (value) {
        result.Success(:final data) => data.mergeWith(initialNews),
        result.Error() => initialNews,
      },
      _ => initialNews,
    };
  }
}

class _NewsDetailContent extends StatelessWidget {
  const _NewsDetailContent({required this.news});

  final NewsModel news;

  @override
  Widget build(BuildContext context) {
    if (supportsInAppWebView) {
      return _NewsWebViewBody(news: news);
    }

    return _NewsNativeDetailBody(news: news);
  }
}

class _NewsWebViewBody extends StatefulWidget {
  const _NewsWebViewBody({required this.news});

  final NewsModel news;

  @override
  State<_NewsWebViewBody> createState() => _NewsWebViewBodyState();
}

class _NewsWebViewBodyState extends State<_NewsWebViewBody> {
  WebViewController? _controller;
  var _isLoading = true;
  var _hasError = false;

  NewsModel get _news => widget.news;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    final controller = WebViewController();

    if (!kIsWeb) {
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(Colors.white);
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
          },
          onWebResourceError: (_) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        ),
      );
    }

    setState(() => _controller = controller);
    await _loadContent(controller);
  }

  Future<void> _loadContent(WebViewController controller) async {
    if (!mounted) return;

    final url = _news.webViewUrl;
    if (url == null) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await controller.loadRequest(Uri.parse(url));

      if (!mounted) return;
      if (kIsWeb) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _openInBrowser() async {
    final launched = await launchNewsUrl(_news);
    if (!launched && mounted) {
      context.showSnackBar('Tidak dapat membuka browser', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return _NewsDetailScaffold(
      title: _news.title,
      onRefresh: controller == null || _isLoading
          ? null
          : () => _loadContent(controller),
      onOpenBrowser: _openInBrowser,
      body: controller == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                WebViewWidget(controller: controller),
                if (_isLoading)
                  const LinearProgressIndicator(
                    minHeight: 2,
                    color: AppColors.primary,
                    backgroundColor: AppColors.divider,
                  ),
                if (_hasError)
                  _NewsLoadError(
                    onRetry: () => _loadContent(controller),
                    onOpenBrowser: _news.hasValidExternalUrl
                        ? _openInBrowser
                        : null,
                  ),
              ],
            ),
    );
  }
}

class _NewsNativeDetailBody extends StatelessWidget {
  const _NewsNativeDetailBody({required this.news});

  final NewsModel news;

  Future<void> _openInBrowser(BuildContext context) async {
    final launched = await launchNewsUrl(news);
    if (!launched && context.mounted) {
      context.showSnackBar('Tidak dapat membuka browser', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _NewsDetailScaffold(
      title: news.title,
      onOpenBrowser: () => _openInBrowser(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                news.category,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (news.imageUrl != null && news.imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  news.imageUrl!,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              news.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1.25,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${news.author} · ${DateFormatter.formatRelative(news.publishedAt)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Text(
              news.displayBody.isNotEmpty
                  ? news.displayBody
                  : 'Konten berita belum tersedia.',
              style: const TextStyle(
                fontSize: 16,
                height: 1.7,
                color: AppColors.textPrimary,
              ),
            ),
            if (news.hasValidExternalUrl) ...[
              const SizedBox(height: 24),
              if (kIsWeb) ...[
                const Text(
                  'Artikel lengkap hanya bisa dibaca di website NTB Hub.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => _openInBrowser(context),
                  icon: const Icon(Iconsax.export_1),
                  label: Text(
                    kIsWeb ? 'Buka di Website' : 'Buka artikel lengkap',
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewsDetailScaffold extends StatelessWidget {
  const _NewsDetailScaffold({
    required this.title,
    required this.body,
    this.onRefresh,
    this.onOpenBrowser,
  });

  final String title;
  final Widget body;
  final VoidCallback? onRefresh;
  final VoidCallback? onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (onRefresh != null)
            IconButton(
              onPressed: onRefresh,
              icon: const Icon(Iconsax.refresh),
              tooltip: 'Muat ulang',
            ),
          if (onOpenBrowser != null)
            IconButton(
              onPressed: onOpenBrowser,
              icon: const Icon(Iconsax.export_1),
              tooltip: 'Buka di browser',
            ),
        ],
      ),
      body: body,
    );
  }
}

class _NewsLoadError extends StatelessWidget {
  const _NewsLoadError({required this.onRetry, this.onOpenBrowser});

  final VoidCallback onRetry;
  final VoidCallback? onOpenBrowser;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Iconsax.warning_2,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat berita',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kIsWeb
                    ? 'Website berita tidak bisa ditampilkan di dalam app. '
                          'Coba buka langsung di browser.'
                    : 'Periksa koneksi internet Anda lalu coba lagi.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Iconsax.refresh, color: Colors.white),
                label: const Text('Coba Lagi'),
              ),
              if (onOpenBrowser != null) ...[
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: onOpenBrowser,
                  icon: const Icon(Iconsax.export_1),
                  label: const Text('Buka di Browser'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> launchNewsUrl(NewsModel news) async {
  final url = news.webViewUrl;
  if (url == null) return false;

  return launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
}
