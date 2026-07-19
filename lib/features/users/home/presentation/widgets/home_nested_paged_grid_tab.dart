import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../widgets/common/app_skeleton.dart';

class HomeNestedPagedGridTab<T> extends StatelessWidget {
  const HomeNestedPagedGridTab({
    super.key,
    required this.storageKey,
    required this.controller,
    required this.itemBuilder,
    this.emptyMessage = 'Belum ada data',
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.72,
  });

  final String storageKey;
  final PagingController<int, T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: PagingListener<int, T>(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          return PagedGridView<int, T>(
            key: PageStorageKey<String>(storageKey),
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: itemBuilder,
              firstPageProgressIndicatorBuilder: (_) =>
                  const AppGridSkeleton(itemCount: 6),
              newPageProgressIndicatorBuilder: (_) => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              firstPageErrorIndicatorBuilder: (context) =>
                  _ErrorBox(onRetry: controller.refresh),
              newPageErrorIndicatorBuilder: (context) =>
                  _ErrorBox(onRetry: fetchNextPage),
              noItemsFoundIndicatorBuilder: (context) =>
                  Center(child: Text(emptyMessage)),
            ),
          );
        },
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.errorGeneric),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
