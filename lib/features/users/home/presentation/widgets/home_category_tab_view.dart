import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../models/home_event_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';
import '../../data/datasources/home_content_datasource.dart';
import '../models/home_tab_item.dart';
import 'home_event_list_item.dart';
import 'home_nested_paged_tab.dart';
import 'public_place_list_item.dart';
import 'venue_list_item.dart';

List<HomeTabItem> buildHomeTabs() {
  return [
    HomeTabItem(label: 'Venue', builder: (_) => const _VenuePagedTab()),
    HomeTabItem(label: 'Event', builder: (_) => const _EventPagedTab()),
    HomeTabItem(
      label: 'Public Place',
      builder: (_) => const _PublicPlacePagedTab(),
    ),
    HomeTabItem(label: 'Kuliner', builder: (_) => const _KulinerPagedTab()),
    HomeTabItem(label: 'Wisata', builder: (_) => const _WisataPagedTab()),
    HomeTabItem(label: 'UMKM', builder: (_) => const _UmkmPagedTab()),
  ];
}

class _VenuePagedTab extends StatefulWidget {
  const _VenuePagedTab();

  @override
  State<_VenuePagedTab> createState() => _VenuePagedTabState();
}

class _VenuePagedTabState extends State<_VenuePagedTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = HomeContentDatasource.pageSize;
  final _datasource = HomeContentDatasource();

  late final PagingController<int, VenueModel> _controller =
      PagingController<int, VenueModel>(
    getNextPageKey: (state) {
      if (state.items == null) return 1;
      if (state.items!.isEmpty) return null;
      if (state.items!.length % _pageSize != 0) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) async {
      final result = await _datasource.getVenuesPage(pageKey);
      return result.items;
    },
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedTab<VenueModel>(
      storageKey: 'venue_tab',
      controller: _controller,
      emptyMessage: 'Belum ada venue',
      itemBuilder: (context, venue, index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: VenueListItem(venue: venue),
      ),
    );
  }
}

class _EventPagedTab extends StatefulWidget {
  const _EventPagedTab();

  @override
  State<_EventPagedTab> createState() => _EventPagedTabState();
}

class _EventPagedTabState extends State<_EventPagedTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = HomeContentDatasource.pageSize;
  final _datasource = HomeContentDatasource();

  late final PagingController<int, HomeEventModel> _controller =
      PagingController<int, HomeEventModel>(
    getNextPageKey: (state) {
      if (state.items == null) return 1;
      if (state.items!.isEmpty) return null;
      if (state.items!.length % _pageSize != 0) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) async {
      final result = await _datasource.getEventsPage(pageKey);
      return result.items;
    },
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedTab<HomeEventModel>(
      storageKey: 'event_tab',
      controller: _controller,
      emptyMessage: 'Belum ada event',
      itemBuilder: (context, event, index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: HomeEventListItem(event: event),
      ),
    );
  }
}

class _PublicPlacePagedTab extends StatefulWidget {
  const _PublicPlacePagedTab();

  @override
  State<_PublicPlacePagedTab> createState() => _PublicPlacePagedTabState();
}

class _PublicPlacePagedTabState extends State<_PublicPlacePagedTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = HomeContentDatasource.pageSize;
  final _datasource = HomeContentDatasource();

  late final PagingController<int, PublicPlaceModel> _controller =
      PagingController<int, PublicPlaceModel>(
    getNextPageKey: (state) {
      if (state.items == null) return 1;
      if (state.items!.isEmpty) return null;
      if (state.items!.length % _pageSize != 0) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) async {
      final result = await _datasource.getPublicPlacesPage(pageKey);
      return result.items;
    },
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedTab<PublicPlaceModel>(
      storageKey: 'public_place_tab',
      controller: _controller,
      emptyMessage: 'Belum ada public place',
      itemBuilder: (context, place, index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: PublicPlaceListItem(place: place),
      ),
    );
  }
}

class _KulinerPagedTab extends StatelessWidget {
  const _KulinerPagedTab();

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPagedTab(
      storageKey: 'kuliner_tab',
      category: 'Kuliner',
    );
  }
}

class _WisataPagedTab extends StatelessWidget {
  const _WisataPagedTab();

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPagedTab(
      storageKey: 'wisata_tab',
      category: 'Wisata',
    );
  }
}

class _UmkmPagedTab extends StatelessWidget {
  const _UmkmPagedTab();

  @override
  Widget build(BuildContext context) {
    return _PlaceholderPagedTab(
      storageKey: 'umkm_tab',
      category: 'UMKM',
    );
  }
}

class _PlaceholderPagedTab extends StatefulWidget {
  const _PlaceholderPagedTab({
    required this.storageKey,
    required this.category,
  });

  final String storageKey;
  final String category;

  @override
  State<_PlaceholderPagedTab> createState() => _PlaceholderPagedTabState();
}

class _PlaceholderPagedTabState extends State<_PlaceholderPagedTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 8;

  late final PagingController<int, String> _controller =
      PagingController<int, String>(
    getNextPageKey: (state) {
      if (state.items == null) return 1;
      if (state.items!.isEmpty) return null;
      if (state.items!.length % _pageSize != 0) return null;
      return state.keys!.last + 1;
    },
    fetchPage: (pageKey) async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (pageKey > 3) return [];
      return List.generate(
        _pageSize,
        (i) => '${widget.category} item ${(pageKey - 1) * _pageSize + i + 1}',
      );
    },
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedTab<String>(
      storageKey: widget.storageKey,
      controller: _controller,
      emptyMessage: 'Belum ada ${widget.category.toLowerCase()}',
      itemBuilder: (context, item, index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(title: Text(item)),
        ),
      ),
    );
  }
}
