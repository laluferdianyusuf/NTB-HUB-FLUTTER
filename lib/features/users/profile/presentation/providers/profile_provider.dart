import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/failure.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final profileProvider = FutureProvider<result.Result<UserModel>>((ref) async {
  final auth = await ref.watch(authProvider.future);
  if (auth == null || !auth.isAuthenticated) {
    return const result.Error(UnknownFailure('Belum login'));
  }

  final meResult = await ref.read(authRepositoryProvider).fetchMeUser();

  return switch (meResult) {
    result.Success() => meResult,
    result.Error() => result.Success(UserModel.fromAuth(auth)),
  };
});
