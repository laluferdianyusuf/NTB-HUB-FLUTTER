class PaginationResult<T> {
  const PaginationResult({
    required this.items,
    required this.hasNextPage,
  });

  final List<T> items;
  final bool hasNextPage;
}

class PaginationHelper {
  const PaginationHelper._();

  static PaginationResult<T> paginate<T>(
    List<T> allItems, {
    required int page,
    int pageSize = 10,
  }) {
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= allItems.length) {
      return const PaginationResult(items: [], hasNextPage: false);
    }

    final endIndex = startIndex + pageSize;
    final items = allItems.sublist(
      startIndex,
      endIndex > allItems.length ? allItems.length : endIndex,
    );

    return PaginationResult(
      items: items,
      hasNextPage: endIndex < allItems.length,
    );
  }
}
