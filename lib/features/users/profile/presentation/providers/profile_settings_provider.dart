import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/profile_settings_service.dart';

final profileSettingsServiceProvider = Provider<ProfileSettingsService>(
  (ref) => ProfileSettingsService(),
);

class ProfileSettingsNotifier extends AsyncNotifier<ProfileSettingsState> {
  @override
  Future<ProfileSettingsState> build() async {
    final service = ref.read(profileSettingsServiceProvider);
    return ProfileSettingsState(
      biometricEnabled: await service.isBiometricEnabled(),
      hasTransactionPin: (await service.getTransactionPin()) != null,
    );
  }

  Future<void> toggleBiometric(bool value) async {
    await ref.read(profileSettingsServiceProvider).setBiometricEnabled(value);
    state = AsyncData(state.requireValue.copyWith(biometricEnabled: value));
  }

  Future<void> refreshPinStatus() async {
    final pin = await ref.read(profileSettingsServiceProvider).getTransactionPin();
    state = AsyncData(
      state.requireValue.copyWith(hasTransactionPin: pin != null),
    );
  }
}

class ProfileSettingsState {
  const ProfileSettingsState({
    required this.biometricEnabled,
    required this.hasTransactionPin,
  });

  final bool biometricEnabled;
  final bool hasTransactionPin;

  ProfileSettingsState copyWith({bool? biometricEnabled, bool? hasTransactionPin}) {
    return ProfileSettingsState(
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      hasTransactionPin: hasTransactionPin ?? this.hasTransactionPin,
    );
  }
}

final profileSettingsProvider =
    AsyncNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      ProfileSettingsNotifier.new,
    );
