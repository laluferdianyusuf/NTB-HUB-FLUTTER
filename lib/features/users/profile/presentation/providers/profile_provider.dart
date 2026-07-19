import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/user_model.dart';
import '../../../../../repository/user_repository.dart';

final profileProvider = FutureProvider<result.Result<UserModel>>((ref) async {
  return UserRepository().getCurrentUser();
});
