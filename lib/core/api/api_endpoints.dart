abstract final class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String googleLogin = '/auth/google';
  static const String me = '/auth/me';
  static const String refresh = '/auth/refresh';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  static const String userInterests = '/users/interests';
  static const String interests = '/interests';
  static const String updateMyInterests = '/interests/update/me';
  static const String posts = '/posts';
  static const String news = '/news';
  static const String groups = '/groups';
  static const String users = '/users';
  static const String events = '/events';
  static const String bookings = '/bookings';
  static const String venueCategories = '/venue-category/categories';
  static const String listTasks = '/tasks/all/list-tasks';
  static const String allNews = '/news/all-news';
  static String newsDetail(String id) => '/news/detail-news/$id';
  static const String allVenues = '/venues/venue/venues';
  static String venueDetail(String id) => '/venues/venue/$id';
  static const String allPublicPlaces = '/public-places/list-places';
  static String publicPlaceDetail(String id) => '/public-places/detail-place/$id';
  static const String allEvents = '/events/list-events';
  static String eventDetail(String id) => '/events/detail-event/$id';
  static String venueSubCategoriesByCategory(String categoryId) =>
      '/venue-sub-category/by-category/$categoryId';
}
