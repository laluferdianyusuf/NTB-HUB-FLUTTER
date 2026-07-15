import '../storage/local_storage.dart';

class OnboardingService {
  OnboardingService({LocalStorage? storage})
      : _storage = storage ?? LocalStorage();

  final LocalStorage _storage;

  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _userInterestsKey = 'user_interests';

  Future<bool> isOnboardingCompleted() async {
    return await _storage.read<bool>(_onboardingCompletedKey) ?? false;
  }

  Future<void> markOnboardingCompleted() async {
    await _storage.save(_onboardingCompletedKey, true);
  }

  Future<List<String>> getUserInterests() async {
    final interests = await _storage.read<List<dynamic>>(_userInterestsKey);
    if (interests == null) return [];
    return interests.map((e) => e.toString()).toList();
  }

  Future<void> saveUserInterests(List<String> interests) async {
    await _storage.save(_userInterestsKey, interests);
  }
}
