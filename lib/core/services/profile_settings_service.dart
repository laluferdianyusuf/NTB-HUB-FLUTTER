import '../storage/local_storage.dart';

class ProfileSettingsService {
  ProfileSettingsService({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;

  static const _biometricEnabledKey = 'biometric_enabled';
  static const _transactionPinKey = 'transaction_pin';
  static const _favoriteVenueIdsKey = 'favorite_venue_ids';

  Future<bool> isBiometricEnabled() async {
    return await _storage.read<bool>(_biometricEnabledKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _storage.save(_biometricEnabledKey, value);
  }

  Future<String?> getTransactionPin() async {
    return await _storage.read<String>(_transactionPinKey);
  }

  Future<void> setTransactionPin(String pin) async {
    await _storage.save(_transactionPinKey, pin);
  }

  Future<List<String>> getFavoriteVenueIds() async {
    final ids = await _storage.read<List<dynamic>>(_favoriteVenueIdsKey);
    if (ids == null) return ['1', '3', '5', '7'];
    return ids.map((e) => e.toString()).toList();
  }
}
