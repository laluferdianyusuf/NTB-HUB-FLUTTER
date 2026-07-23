import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/router.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/network/session_expired_handler.dart';
import '../../../../../core/services/google_auth_service.dart';
import '../../../../../core/storage/storage_provider.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/auth_model.dart';
import '../../../../../repository/auth_repository.dart';
import '../providers/interest_provider.dart';
import '../providers/onboarding_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    client: ref.watch(dioClientProvider),
    storage: ref.watch(localStorageProvider),
  ),
);

final googleAuthServiceProvider = Provider<GoogleAuthService>(
  (ref) => GoogleAuthService(),
);

class AuthNotifier extends AsyncNotifier<AuthModel?> {
  @override
  Future<AuthModel?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final isLoggedIn = await repository.isLoggedIn();
    if (!isLoggedIn) return null;

    final cachedAuth = await repository.getCurrentAuth();
    final meResult = await repository.getMe();

    switch (meResult) {
      case result.Success(:final data):
        await _syncPendingInterestsIfNeeded();
        return data;
      case result.Error():
        return cachedAuth;
    }
  }

  Future<void> _syncPendingInterestsIfNeeded() async {
    final onboardingService = ref.read(onboardingServiceProvider);
    if (!await onboardingService.hasPendingInterestsToSync()) return;

    final interests = await onboardingService.getUserInterests();
    final updateResult = await ref
        .read(interestRepositoryProvider)
        .updateMyInterests(interests);

    if (updateResult case result.Success()) {
      await onboardingService.markInterestsSynced();
    }
  }

  Future<result.Result<AuthModel>> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final loginResult = await repository.login(
      email: email,
      password: password,
    );

    switch (loginResult) {
      case result.Success(:final data):
        if (data.isAuthenticated) {
          state = AsyncData(data);
          await _syncPendingInterestsIfNeeded();
        } else {
          state = const AsyncData(null);
        }
      case result.Error():
        state = const AsyncData(null);
    }

    return loginResult;
  }

  Future<result.Result<AuthModel>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final registerResult = await repository.register(
      name: name,
      email: email,
      password: password,
    );

    switch (registerResult) {
      case result.Success():
        state = const AsyncData(null);
      case result.Error():
        state = const AsyncData(null);
    }

    return registerResult;
  }

  Future<result.Result<AuthModel>> verifyEmail({
    required String userId,
    required String pin,
  }) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    final verifyResult = await repository.verifyEmail(userId: userId, pin: pin);

    switch (verifyResult) {
      case result.Success(:final data):
        state = AsyncData(data);
        await _syncPendingInterestsIfNeeded();
      case result.Error():
        state = const AsyncData(null);
    }

    return verifyResult;
  }

  Future<result.Result<void>> resendVerification({required String email}) {
    return ref.read(authRepositoryProvider).resendVerification(email: email);
  }

  Future<result.Result<AuthModel>> fetchMe() async {
    final repository = ref.read(authRepositoryProvider);
    final meResult = await repository.getMe();

    switch (meResult) {
      case result.Success(:final data):
        state = AsyncData(data);
      case result.Error():
        state = const AsyncData(null);
    }

    return meResult;
  }

  Future<result.Result<AuthModel>> loginWithGoogleCredential(
    GoogleUserCredential credential,
  ) async {
    final previousState = state;
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    final loginResult = await repository.loginWithGoogle(
      payload: credential.toBackendPayload(),
    );

    switch (loginResult) {
      case result.Success(:final data):
        state = AsyncData(data);
        await _syncPendingInterestsIfNeeded();
      case result.Error():
        state = previousState;
    }

    return loginResult;
  }

  bool shouldNavigateToHome(result.Result<AuthModel> loginResult) {
    return switch (loginResult) {
      result.Success(:final data) => data.isAuthenticated,
      result.Error() => false,
    };
  }

  Future<result.Result<AuthModel>> loginWithGoogleAccount(
    GoogleAccountInfo account,
  ) async {
    final previousState = state;

    try {
      final googleService = ref.read(googleAuthServiceProvider);
      final credential = await googleService.signInWithAccount(account);

      if (credential == null) {
        state = previousState;
        return const result.Error(UnknownFailure('Login Google dibatalkan'));
      }

      return loginWithGoogleCredential(credential);
    } catch (error) {
      state = previousState;
      return result.Error(UnknownFailure(_googleSignInErrorMessage(error)));
    }
  }

  Future<result.Result<AuthModel>> loginWithGoogle({
    bool forceAccountPicker = true,
  }) async {
    final previousState = state;

    try {
      final googleService = ref.read(googleAuthServiceProvider);
      final credential = await googleService.signIn(
        forceAccountPicker: forceAccountPicker,
      );

      if (credential == null) {
        state = previousState;
        return const result.Error(UnknownFailure('Login Google dibatalkan'));
      }

      return loginWithGoogleCredential(credential);
    } catch (error) {
      state = previousState;
      return result.Error(UnknownFailure(_googleSignInErrorMessage(error)));
    }
  }

  String _googleSignInErrorMessage(Object error) {
    if (error is StateError) return error.message;
    if (error is UnsupportedError) {
      return error.message ??
          'Metode login Google tidak didukung di platform ini';
    }

    final message = error.toString().toLowerCase();
    if (message.contains('popup_closed') ||
        message.contains('cancel') ||
        message.contains('sign_in_canceled')) {
      return 'Login Google dibatalkan';
    }

    return 'Gagal login dengan Google';
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    try {
      await ref.read(googleAuthServiceProvider).signOut();
    } catch (_) {
      // Lanjut clear session app meski Google SDK gagal sign out.
    }
    state = const AsyncData(null);
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthModel?>(
  AuthNotifier.new,
);

final sessionBootstrapProvider = Provider<void>((ref) {
  onSessionExpired = () async {
    await ref.read(authProvider.notifier).logout();
    appRouter.go('/login');
  };

  ref.onDispose(() {
    onSessionExpired = null;
  });
});
