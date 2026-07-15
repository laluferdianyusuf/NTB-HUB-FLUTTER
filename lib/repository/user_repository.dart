import '../core/errors/failure.dart';
import '../core/utils/result.dart';
import '../database/app_database.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({AppDatabase? database})
      : _database = database ?? AppDatabase.instance;

  final AppDatabase _database;

  Future<Result<UserModel>> getCurrentUser() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      return Success(_database.currentUser);
    } catch (e) {
      return const Error(ServerFailure());
    }
  }
}
