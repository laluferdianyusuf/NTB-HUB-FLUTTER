import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../models/home_event_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';
import '../../../../../models/venue_service_model.dart';
import '../../../../../repository/event_repository.dart';
import '../../../../../repository/public_place_repository.dart';
import '../../../../../repository/venue_repository.dart';

final venueRepositoryProvider = Provider<VenueRepository>(
  (ref) => VenueRepository(client: ref.watch(dioClientProvider)),
);

final publicPlaceRepositoryProvider = Provider<PublicPlaceRepository>(
  (ref) => PublicPlaceRepository(client: ref.watch(dioClientProvider)),
);

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => EventRepository(client: ref.watch(dioClientProvider)),
);

final venueListProvider = FutureProvider<Result<List<VenueModel>>>((ref) async {
  return ref.read(venueRepositoryProvider).getAllVenues();
});

final publicPlaceListProvider = FutureProvider<Result<List<PublicPlaceModel>>>((
  ref,
) async {
  return ref.read(publicPlaceRepositoryProvider).getAllPublicPlaces();
});

final eventListProvider = FutureProvider<Result<List<HomeEventModel>>>((
  ref,
) async {
  return ref.read(eventRepositoryProvider).getAllEvents();
});

final venueDetailProvider = FutureProvider.family<Result<VenueModel>, String>((
  ref,
  id,
) async {
  return ref.read(venueRepositoryProvider).getVenueDetail(id);
});

final venueServicesProvider =
    FutureProvider.family<Result<List<VenueServiceModel>>, String>((
      ref,
      venueId,
    ) async {
      final result = await ref
          .read(venueRepositoryProvider)
          .getVenueServices(venueId);

      switch (result) {
        case Success(:final data):
          debugPrint('VENUE SERVICES ($venueId): ${data.length} item');

          for (final service in data) {
            debugPrint('${service.id} | ${jsonEncode(data)}');
          }
        case Error(:final failure):
          debugPrint('VENUE SERVICES ERROR ($venueId): ${failure.message}');
      }

      return result;
    });

final publicPlaceDetailProvider =
    FutureProvider.family<Result<PublicPlaceModel>, String>((ref, id) async {
      return ref.read(publicPlaceRepositoryProvider).getPublicPlaceDetail(id);
    });

final eventDetailProvider =
    FutureProvider.family<Result<HomeEventModel>, String>((ref, id) async {
      return ref.read(eventRepositoryProvider).getEventDetail(id);
    });
