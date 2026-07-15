import '../core/services/mock_data_service.dart';
import '../models/activity_model.dart';
import '../models/group_model.dart';
import '../models/news_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  List<PostModel> get posts => List.unmodifiable(MockDataService.allPosts);
  List<NewsModel> get news => List.unmodifiable(MockDataService.allNews);
  List<GroupModel> get groups => List.unmodifiable(MockDataService.groups);
  List<ActivityModel> get activities =>
      List.unmodifiable(MockDataService.activities);
  UserModel get currentUser => MockDataService.currentUser;
}
