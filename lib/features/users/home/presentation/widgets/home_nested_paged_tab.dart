import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class HomeNestedPagedTab<T> extends StatelessWidget {
  const HomeNestedPagedTab({
    super.key,
    required this.storageKey,
    required this.controller,
    required this.itemBuilder,
    this.emptyMessage = 'Belum ada data',
  });

  final String storageKey;
  final PagingController<int, T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: PagingListener<int, T>(
        controller: controller,
        builder: (context, state, fetchNextPage) {
          return PagedListView<int, T>(
            key: PageStorageKey<String>(storageKey),
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: itemBuilder,
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
