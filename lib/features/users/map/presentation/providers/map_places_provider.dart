import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/helpers/map_place_style.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../models/map_place_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';
import '../../../home/presentation/providers/home_content_provider.dart';

final mapPlacesProvider = FutureProvider<List<MapPlaceModel>>((ref) async {
  final places = <MapPlaceModel>[...MapPlaces.places];

  final venueResult = await ref.read(venueRepositoryProvider).getAllVenues();
  if (venueResult case Success(:final data)) {
    places.addAll(_mapVenues(data));
  } else {
    places.addAll(_mapVenues(MockDataService.allVenues));
  }

  final publicPlaceResult =
      await ref.read(publicPlaceRepositoryProvider).getAllPublicPlaces();
  if (publicPlaceResult case Success(:final data)) {
    places.addAll(_mapPublicPlaces(data));
  } else {
    places.addAll(_mapPublicPlaces(MockDataService.allPublicPlaces));
  }

  return _dedupePlaces(places);
});

List<MapPlaceModel> _mapVenues(List<VenueModel> venues) {
  return venues.asMap().entries.map((entry) {
    final index = entry.key;
    final venue = entry.value;
    final location = _resolveLocation(
      latitude: venue.latitude,
      longitude: venue.longitude,
      seed: venue.id,
      city: venue.city,
      index: index,
    );

    return MapPlaceModel(
      id: 'venue-${venue.id}',
      name: venue.name,
      description: venue.displayDescription,
      location: location,
      category: 'Venue',
      kind: MapPlaceKind.venue,
      routePath: '/venue/${venue.id}',
      address: venue.location,
    );
  }).toList();
}

List<MapPlaceModel> _mapPublicPlaces(List<PublicPlaceModel> publicPlaces) {
  return publicPlaces.asMap().entries.map((entry) {
    final index = entry.key;
    final place = entry.value;
    final kind = MapPlaceStyle.fromPublicPlaceType(place.type);
    final location = _resolveLocation(
      latitude: place.latitude,
      longitude: place.longitude,
      seed: place.id,
      city: place.address,
      index: index,
    );

    return MapPlaceModel(
      id: 'public-${place.id}',
      name: place.name,
      description: place.displayDescription,
      location: location,
      category: place.typeLabel,
      kind: kind,
      routePath: '/public-place/${place.id}',
      address: place.address,
    );
  }).toList();
}

LatLng _resolveLocation({
  required double? latitude,
  required double? longitude,
  required String seed,
  required String city,
  required int index,
}) {
  if (latitude != null && longitude != null) {
    return LatLng(latitude, longitude);
  }

  final base = switch (city.toLowerCase()) {
    final value when value.contains('sumbawa') =>
      const LatLng(-8.4917, 117.4236),
    final value when value.contains('lombok') => const LatLng(-8.6500, 116.2000),
    _ => MapPlaces.mataramCenter,
  };

  return MapPlaces.fallbackCoordinate(seed: seed, base: base, index: index);
}

List<MapPlaceModel> _dedupePlaces(List<MapPlaceModel> places) {
  final seen = <String>{};
  final result = <MapPlaceModel>[];

  for (final place in places) {
    final key = '${place.name.toLowerCase()}@${place.location.latitude.toStringAsFixed(4)}';
    if (seen.add(key)) {
      result.add(place);
    }
  }

  return result;
}
