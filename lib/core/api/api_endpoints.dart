abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google';
  static const String profile = '/auth/profile';
  static const String userInterests = '/users/interests';
  static const String interests = '/interests';
  static const String posts = '/posts';
  static const String news = '/news';
  static const String groups = '/groups';
  static const String users = '/users';
  static const String events = '/events';
  static const String bookings = '/bookings';
  static const String venueCategories = '/venue-category/categories';
  static const String listTasks = '/tasks/all/list-tasks';
  static const String allNews = '/news/all-news';
  static String venueSubCategoriesByCategory(String categoryId) =>
      '/venue-sub-category/by-category/$categoryId';
}
