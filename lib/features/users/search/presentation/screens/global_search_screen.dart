import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/global_search_service.dart';
import '../../../../../models/search_result_item.dart';
import '../../../../../widgets/common/app_text_field.dart';
import '../widgets/search_result_grid_item.dart';

final globalSearchServiceProvider = Provider<GlobalSearchService>(
  (ref) => GlobalSearchService(),
);

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _searchController = TextEditingController();
  SearchResultType? _selectedFilter;
  List<SearchResultItem> _results = [];
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final recent = await ref.read(globalSearchServiceProvider).getRecentSearches();
    if (mounted) setState(() => _recentSearches = recent);
  }

  void _performSearch([String? query]) {
    final keyword = query ?? _searchController.text;
    final service = ref.read(globalSearchServiceProvider);
    setState(() {
      _results = service.search(keyword, filter: _selectedFilter);
    });
    if (keyword.trim().isNotEmpty) {
      service.addRecentSearch(keyword.trim());
      _loadRecentSearches();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.pop(),
        ),
        title: const Text('Pencarian'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: AppTextField(
              controller: _searchController,
              hint: 'Cari venue, event, public place...',
              prefixIcon: Iconsax.search_normal,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (_) => _performSearch(),
              onSubmitted: _performSearch,
              suffixIcon: hasQuery
                  ? IconButton(
                      icon: const Icon(Iconsax.close_circle, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: 'Semua',
                  selected: _selectedFilter == null,
                  onTap: () {
                    setState(() => _selectedFilter = null);
                    _performSearch();
                  },
                ),
                _FilterChip(
                  label: 'Venue',
                  selected: _selectedFilter == SearchResultType.venue,
                  onTap: () {
                    setState(() => _selectedFilter = SearchResultType.venue);
                    _performSearch();
                  },
                ),
                _FilterChip(
                  label: 'Event',
                  selected: _selectedFilter == SearchResultType.event,
                  onTap: () {
                    setState(() => _selectedFilter = SearchResultType.event);
                    _performSearch();
                  },
                ),
                _FilterChip(
                  label: 'Public Place',
                  selected: _selectedFilter == SearchResultType.publicPlace,
                  onTap: () {
                    setState(() => _selectedFilter = SearchResultType.publicPlace);
                    _performSearch();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: hasQuery ? _buildResults() : _buildRecentSearches(),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.search_status,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada hasil ditemukan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        return SearchResultGridItem(
          item: item,
          onTap: () {
            switch (item.type) {
              case SearchResultType.venue:
                context.push('/venue/${item.id}');
              case SearchResultType.event:
                context.push('/event/${item.id}');
              case SearchResultType.publicPlace:
                context.push('/public-place/${item.id}');
            }
          },
        );
      },
    );
  }

  Widget _buildRecentSearches() {
    if (_recentSearches.isEmpty) {
      return const Center(
        child: Text(
          'Ketik untuk mencari venue, event, dan public place',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Pencarian Terakhir',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(globalSearchServiceProvider).clearRecentSearches();
                await _loadRecentSearches();
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
        ..._recentSearches.map(
          (keyword) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Iconsax.clock, color: AppColors.textSecondary),
            title: Text(keyword),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              _searchController.text = keyword;
              _performSearch(keyword);
            },
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.divider,
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
