import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/map_place_style.dart';
import '../../../../../core/helpers/map_tile_helper.dart';
import '../../../../../models/map_place_model.dart';
import '../../../auth/presentation/providers/location_provider.dart';
import '../providers/map_places_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _mapController = MapController();
  MapPlaceFilter _selectedFilter = MapPlaceFilter.all;
  MapPlaceModel? _selectedPlace;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _focusPlace(MapPlaceModel place) {
    setState(() => _selectedPlace = place);
    _mapController.move(place.location, 15);
  }

  List<MapPlaceModel> _filterPlaces(List<MapPlaceModel> places) {
    return places
        .where((place) => MapPlaceStyle.matchesFilter(place, _selectedFilter))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final userLocation = ref.watch(locationProvider);
    final placesAsync = ref.watch(mapPlacesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: placesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(
            'Gagal memuat tempat di peta',
            style: TextStyle(color: context.adaptiveTextSecondary),
          ),
        ),
        data: (allPlaces) {
          final places = _filterPlaces(allPlaces);

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: MapPlaces.mataramCenter,
                  initialZoom: 13,
                  minZoom: 8,
                  maxZoom: 18,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  onTap: (_, _) {
                    if (_selectedPlace != null) {
                      setState(() => _selectedPlace = null);
                    }
                  },
                ),
                children: [
                  MapTileHelper.tileLayer(context),
                  MarkerLayer(
                    markers: [
                      ...places.map(
                        (place) => _buildPlaceMarker(context, place),
                      ),
                      if (userLocation != null)
                        Marker(
                          point: LatLng(
                            userLocation.latitude,
                            userLocation.longitude,
                          ),
                          width: 48,
                          height: 48,
                          child: const _UserLocationMarker(),
                        ),
                    ],
                  ),
                ],
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MapHeader(
                        placeCount: places.length,
                        hasUserLocation: userLocation != null,
                      ),
                      const SizedBox(height: 12),
                      _CategoryFilterBar(
                        selected: _selectedFilter,
                        onSelected: (filter) {
                          setState(() {
                            _selectedFilter = filter;
                            _selectedPlace = null;
                          });
                        },
                      ),
                      const Spacer(),
                      if (_selectedPlace != null)
                        _SelectedPlaceCard(
                          place: _selectedPlace!,
                          onClose: () => setState(() => _selectedPlace = null),
                          onOpen: () {
                            final route = _selectedPlace!.routePath;
                            if (route != null) context.push(route);
                          },
                        )
                      else
                        SizedBox(
                          height: 130,
                          child: places.isEmpty
                              ? Center(
                                  child: Text(
                                    'Tidak ada tempat di kategori ini',
                                    style: TextStyle(
                                      color: context.adaptiveTextSecondary,
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: places.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final place = places[index];
                                    return _PlaceCard(
                                      place: place,
                                      onTap: () => _focusPlace(place),
                                    );
                                  },
                                ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: userLocation == null
          ? FloatingActionButton.extended(
              backgroundColor: context.primaryColor,
              onPressed: () {
                ref.read(locationProvider.notifier).fetchCurrentLocation();
              },
              icon: const Icon(Iconsax.location, color: Colors.white),
              label: const Text(
                'Lokasi Saya',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  Marker _buildPlaceMarker(BuildContext context, MapPlaceModel place) {
    final isSelected = _selectedPlace?.id == place.id;
    final color = MapPlaceStyle.colorFor(place.kind);
    final icon = MapPlaceStyle.iconFor(place.kind);

    return Marker(
      point: place.location,
      width: isSelected ? 130 : 110,
      height: isSelected ? 78 : 68,
      child: GestureDetector(
        onTap: () => _focusPlace(place),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: isSelected ? 42 : 36,
              height: isSelected ? 42 : 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: isSelected ? 8 : 4,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isSelected ? 20 : 17,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              constraints: const BoxConstraints(maxWidth: 108),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.cardColor.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected ? color : context.adaptiveDivider,
                ),
              ),
              child: Text(
                place.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: context.adaptiveTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({required this.placeCount, required this.hasUserLocation});

  final int placeCount;
  final bool hasUserLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.map, color: context.primaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            hasUserLocation
                ? 'Peta NTB · $placeCount tempat · Lokasi aktif'
                : 'Peta NTB · $placeCount tempat',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({required this.selected, required this.onSelected});

  final MapPlaceFilter selected;
  final ValueChanged<MapPlaceFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MapPlaceFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = MapPlaceFilter.values[index];
          final isSelected = filter == selected;

          return FilterChip(
            label: Text(MapPlaceStyle.filterLabel(filter)),
            selected: isSelected,
            onSelected: (_) => onSelected(filter),
            selectedColor: context.primaryColor.withValues(alpha: 0.15),
            checkmarkColor: context.primaryColor,
            labelStyle: TextStyle(
              color: isSelected
                  ? context.primaryColor
                  : context.adaptiveTextSecondary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
            side: BorderSide(
              color: isSelected
                  ? context.primaryColor
                  : context.adaptiveDivider,
            ),
            backgroundColor: context.cardColor,
          );
        },
      ),
    );
  }
}

class _SelectedPlaceCard extends StatelessWidget {
  const _SelectedPlaceCard({
    required this.place,
    required this.onClose,
    required this.onOpen,
  });

  final MapPlaceModel place;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final color = MapPlaceStyle.colorFor(place.kind);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  place.category,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Iconsax.close_circle, size: 20),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            place.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (place.address != null) ...[
            const SizedBox(height: 4),
            Text(
              place.address!,
              style: TextStyle(
                color: context.adaptiveTextSecondary,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            place.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 12,
            ),
          ),
          if (place.routePath != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onOpen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Lihat Detail'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UserLocationMarker extends StatelessWidget {
  const _UserLocationMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({required this.place, required this.onTap});

  final MapPlaceModel place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = MapPlaceStyle.colorFor(place.kind);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    place.category,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(MapPlaceStyle.iconFor(place.kind), size: 16, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              place.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              place.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.adaptiveTextSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
