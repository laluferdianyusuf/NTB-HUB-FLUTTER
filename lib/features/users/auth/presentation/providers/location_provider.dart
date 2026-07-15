import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/location_service.dart';
import '../../../../../models/location_model.dart';

final locationServiceProvider = Provider<LocationService>(
  (ref) => LocationService(),
);

class LocationNotifier extends Notifier<LocationModel?> {
  @override
  LocationModel? build() => null;

  Future<void> fetchCurrentLocation() async {
    final service = ref.read(locationServiceProvider);
    final position = await service.getCurrentPosition();

    if (position != null) {
      state = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    }
  }

  void clear() => state = null;
}

final locationProvider =
    NotifierProvider<LocationNotifier, LocationModel?>(LocationNotifier.new);
