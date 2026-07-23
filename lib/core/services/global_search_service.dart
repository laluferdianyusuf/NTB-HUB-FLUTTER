import '../../models/search_result_item.dart';
import '../storage/local_storage.dart';
import 'mock_data_service.dart';

class GlobalSearchService {
  GlobalSearchService({LocalStorage? storage})
    : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;
  static const _recentSearchesKey = 'recent_searches';

  List<SearchResultItem> search(String query, {SearchResultType? filter}) {
    final keyword = query.trim().toLowerCase();
    if (keyword.isEmpty) return [];

    final results = <SearchResultItem>[];

    if (filter == null || filter == SearchResultType.venue) {
      results.addAll(
        MockDataService.allVenues
            .where(
              (item) =>
                  item.name.toLowerCase().contains(keyword) ||
                  item.location.toLowerCase().contains(keyword) ||
                  item.city.toLowerCase().contains(keyword) ||
                  item.province.toLowerCase().contains(keyword) ||
                  item.address.toLowerCase().contains(keyword),
            )
            .map(
              (item) => SearchResultItem(
                id: item.id,
                title: item.name,
                subtitle: item.city.isNotEmpty
                    ? '${item.city}, ${item.province}'
                    : item.location,
                location: item.location,
                type: SearchResultType.venue,
                rating: item.averageRating,
                badge: item.totalReviews > 0
                    ? '${item.totalReviews} ulasan'
                    : null,
              ),
            ),
      );
    }

    if (filter == null || filter == SearchResultType.event) {
      results.addAll(
        MockDataService.allHomeEvents
            .where(
              (item) =>
                  item.title.toLowerCase().contains(keyword) ||
                  item.location.toLowerCase().contains(keyword) ||
                  item.category.toLowerCase().contains(keyword),
            )
            .map(
              (item) => SearchResultItem(
                id: item.id,
                title: item.title,
                subtitle: item.category,
                location: item.location,
                type: SearchResultType.event,
                badge: '${item.attendees} peserta',
              ),
            ),
      );
    }

    if (filter == null || filter == SearchResultType.publicPlace) {
      results.addAll(
        MockDataService.allPublicPlaces
            .where(
              (item) =>
                  item.name.toLowerCase().contains(keyword) ||
                  item.location.toLowerCase().contains(keyword) ||
                  item.typeLabel.toLowerCase().contains(keyword),
            )
            .map(
              (item) => SearchResultItem(
                id: item.id,
                title: item.name,
                subtitle: item.type.name,
                location: item.location,
                type: SearchResultType.publicPlace,
                rating: item.rating,
                badge: item.isOpen ? 'Buka' : 'Tutup',
              ),
            ),
      );
    }

    return results;
  }

  Future<List<String>> getRecentSearches() async {
    final items = await _storage.read<List<dynamic>>(_recentSearchesKey);
    if (items == null) return [];
    return items.map((e) => e.toString()).toList();
  }

  Future<void> addRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final current = await getRecentSearches();
    final updated = [
      trimmed,
      ...current.where((item) => item != trimmed),
    ].take(8).toList();
    await _storage.save(_recentSearchesKey, updated);
  }

  Future<void> clearRecentSearches() async {
    await _storage.remove(_recentSearchesKey);
  }
}
