import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/helpers/pagination_helper.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/home_event_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';
import '../models/home_tab_item.dart';
import '../providers/home_content_provider.dart';
import 'home_grid_card.dart';
import 'home_nested_paged_grid_tab.dart';

const _pageSize = 8;

List<HomeTabItem> buildHomeTabs() {
  return [
    HomeTabItem(label: 'Venue', builder: (_) => const _VenuePagedTab()),
    HomeTabItem(label: 'Event', builder: (_) => const _EventPagedTab()),
    HomeTabItem(
      label: 'Public Place',
      builder: (_) => const _PublicPlacePagedTab(),
    ),
  ];
}

class _VenuePagedTab extends ConsumerStatefulWidget {
  const _VenuePagedTab();

  @override
  ConsumerState<_VenuePagedTab> createState() => _VenuePagedTabState();
}

class _VenuePagedTabState extends ConsumerState<_VenuePagedTab>
    with AutomaticKeepAliveClientMixin {
  List<VenueModel>? _cachedVenues;

  late final PagingController<int, VenueModel> _controller =
      PagingController<int, VenueModel>(
        getNextPageKey: (state) {
          if (state.items == null) return 1;
          if (state.items!.isEmpty) return null;
          if (state.items!.length % _pageSize != 0) return null;
          return state.keys!.last + 1;
        },
        fetchPage: _fetchPage,
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<VenueModel>> _loadAllVenues() async {
    if (_cachedVenues != null) return _cachedVenues!;

    final listResult = await ref.read(venueListProvider.future);
    return switch (listResult) {
      result.Success(:final data) => _cachedVenues = data,
      result.Error(:final failure) => throw Exception(failure.message),
    };
  }

  Future<List<VenueModel>> _fetchPage(int pageKey) async {
    final allVenues = await _loadAllVenues();
    return PaginationHelper.paginate(
      allVenues,
      page: pageKey,
      pageSize: _pageSize,
    ).items;
  }

  Future<void> _refresh() async {
    _cachedVenues = null;
    ref.invalidate(venueListProvider);
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedGridTab<VenueModel>(
      storageKey: 'venue_tab',
      controller: _controller,
      onRefresh: _refresh,
      emptyMessage: 'Belum ada venue',
      itemBuilder: (context, venue, index) => HomeGridCard(
        title: venue.name,
        subtitle: '${venue.category} · ${venue.capacity} orang',
        location: venue.location,
        type: HomeGridCardType.venue,
        rating: venue.rating,
        badge: venue.priceRange,
        imageUrl: venue.imageUrl,
        onTap: () => context.push('/venue/${venue.id}', extra: venue),
      ),
    );
  }
}

class _EventPagedTab extends ConsumerStatefulWidget {
  const _EventPagedTab();

  @override
  ConsumerState<_EventPagedTab> createState() => _EventPagedTabState();
}

class _EventPagedTabState extends ConsumerState<_EventPagedTab>
    with AutomaticKeepAliveClientMixin {
  List<HomeEventModel>? _cachedEvents;

  late final PagingController<int, HomeEventModel> _controller =
      PagingController<int, HomeEventModel>(
        getNextPageKey: (state) {
          if (state.items == null) return 1;
          if (state.items!.isEmpty) return null;
          if (state.items!.length % _pageSize != 0) return null;
          return state.keys!.last + 1;
        },
        fetchPage: _fetchPage,
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<HomeEventModel>> _loadAllEvents() async {
    if (_cachedEvents != null) return _cachedEvents!;

    final listResult = await ref.read(eventListProvider.future);
    return switch (listResult) {
      result.Success(:final data) => _cachedEvents = data,
      result.Error(:final failure) => throw Exception(failure.message),
    };
  }

  Future<List<HomeEventModel>> _fetchPage(int pageKey) async {
    final allEvents = await _loadAllEvents();
    return PaginationHelper.paginate(
      allEvents,
      page: pageKey,
      pageSize: _pageSize,
    ).items;
  }

  Future<void> _refresh() async {
    _cachedEvents = null;
    ref.invalidate(eventListProvider);
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedGridTab<HomeEventModel>(
      storageKey: 'event_tab',
      controller: _controller,
      onRefresh: _refresh,
      emptyMessage: 'Belum ada event',
      itemBuilder: (context, event, index) => HomeGridCard(
        title: event.title,
        subtitle: event.category,
        location: event.location,
        type: HomeGridCardType.event,
        badge: '${event.attendees} peserta',
        imageUrl: event.imageUrl,
        onTap: () => context.push('/event/${event.id}', extra: event),
      ),
    );
  }
}

class _PublicPlacePagedTab extends ConsumerStatefulWidget {
  const _PublicPlacePagedTab();

  @override
  ConsumerState<_PublicPlacePagedTab> createState() =>
      _PublicPlacePagedTabState();
}

class _PublicPlacePagedTabState extends ConsumerState<_PublicPlacePagedTab>
    with AutomaticKeepAliveClientMixin {
  List<PublicPlaceModel>? _cachedPlaces;

  late final PagingController<int, PublicPlaceModel> _controller =
      PagingController<int, PublicPlaceModel>(
        getNextPageKey: (state) {
          if (state.items == null) return 1;
          if (state.items!.isEmpty) return null;
          if (state.items!.length % _pageSize != 0) return null;
          return state.keys!.last + 1;
        },
        fetchPage: _fetchPage,
      );

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<PublicPlaceModel>> _loadAllPlaces() async {
    if (_cachedPlaces != null) return _cachedPlaces!;

    final listResult = await ref.read(publicPlaceListProvider.future);
    return switch (listResult) {
      result.Success(:final data) => _cachedPlaces = data,
      result.Error(:final failure) => throw Exception(failure.message),
    };
  }

  Future<List<PublicPlaceModel>> _fetchPage(int pageKey) async {
    final allPlaces = await _loadAllPlaces();
    return PaginationHelper.paginate(
      allPlaces,
      page: pageKey,
      pageSize: _pageSize,
    ).items;
  }

  Future<void> _refresh() async {
    _cachedPlaces = null;
    ref.invalidate(publicPlaceListProvider);
    _controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeNestedPagedGridTab<PublicPlaceModel>(
      storageKey: 'public_place_tab',
      controller: _controller,
      onRefresh: _refresh,
      emptyMessage: 'Belum ada public place',
      itemBuilder: (context, place, index) => HomeGridCard(
        title: place.name,
        subtitle: place.type,
        location: place.location,
        type: HomeGridCardType.publicPlace,
        rating: place.rating,
        badge: place.isOpen ? 'Buka' : 'Tutup',
        imageUrl: place.imageUrl,
        onTap: () => context.push('/public-place/${place.id}', extra: place),
      ),
    );
  }
}
