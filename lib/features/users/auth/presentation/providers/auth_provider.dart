import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/google_auth_service.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/auth_model.dart';
import '../../../../../repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
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
    return repository.getCurrentAuth();
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
        state = AsyncData(data);
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
      case result.Success(:final data):
        state = AsyncData(data);
      case result.Error():
        state = const AsyncData(null);
    }

    return registerResult;
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
        return const result.Error(
          UnknownFailure('Login Google dibatalkan'),
        );
      }

      state = const AsyncLoading();
      final repository = ref.read(authRepositoryProvider);
      final loginResult = await repository.loginWithGoogle(
        payload: credential.toBackendPayload(),
      );

      switch (loginResult) {
        case result.Success(:final data):
          state = AsyncData(data);
        case result.Error():
          state = previousState;
      }

      return loginResult;
    } catch (_) {
      state = previousState;
      return const result.Error(
        UnknownFailure('Gagal login dengan Google'),
      );
    }
  }

  Future<result.Result<AuthModel>> loginWithGoogle() async {
    final previousState = state;

    try {
      final googleService = ref.read(googleAuthServiceProvider);
      final credential = await googleService.signIn();

      if (credential == null) {
        state = previousState;
        return const result.Error(
          UnknownFailure('Login Google dibatalkan'),
        );
      }

      state = const AsyncLoading();
      final repository = ref.read(authRepositoryProvider);
      final loginResult = await repository.loginWithGoogle(
        payload: credential.toBackendPayload(),
      );

      switch (loginResult) {
        case result.Success(:final data):
          state = AsyncData(data);
        case result.Error():
          state = previousState;
      }

      return loginResult;
    } catch (_) {
      state = previousState;
      return const result.Error(
        UnknownFailure('Gagal login dengan Google'),
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthModel?>(AuthNotifier.new);
