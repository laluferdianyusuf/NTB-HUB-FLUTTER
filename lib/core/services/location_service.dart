import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logger/app_logger.dart';
import '../storage/local_storage.dart';

class LocationService {
  LocationService({LocalStorage? storage}) : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;
  static const _permissionHandledKey = 'location_permission_handled';

  Future<bool> isPermissionHandled() async {
    return await _storage.read<bool>(_permissionHandledKey) ?? false;
  }

  Future<void> markPermissionHandled() async {
    await _storage.save(_permissionHandledKey, true);
  }

  Future<PermissionStatus> checkPermission() async {
    return Permission.locationWhenInUse.status;
  }

  Future<PermissionStatus> requestPermission() async {
    final status = await Permission.locationWhenInUse.request();
    AppLogger.info('Location permission status: $status');
    return status;
  }

  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppLogger.warning('Location service disabled');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }

  Future<bool> openLocationSettings() => openAppSettings();
}
