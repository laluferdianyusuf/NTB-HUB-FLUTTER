import 'package:go_router/go_router.dart';
import 'package:ntbhub_flutter/features/users/notification/presentation/screens/notification_screen.dart';
import 'package:ntbhub_flutter/features/users/task/presentation/screens/task_screen.dart';

import '../models/venue_service_model.dart';
import '../features/event/presentation/screens/event_list_screen.dart';
import '../features/users/auth/presentation/screens/onboarding_screen.dart';
import '../features/users/auth/presentation/screens/location_permission_screen.dart';
import '../features/users/auth/presentation/screens/login_screen.dart';
import '../features/users/auth/presentation/screens/register_screen.dart';
import '../features/users/auth/presentation/screens/splash_screen.dart';
import '../features/users/auth/presentation/screens/verify_email_screen.dart';
import '../features/users/booking/presentation/screens/booking_screen.dart';
import '../features/users/booking/presentation/screens/service_booking_screen.dart';
import '../features/users/home/presentation/screens/content_detail_screens.dart';
import '../features/users/profile/presentation/screens/about_us_screen.dart';
import '../features/users/profile/presentation/screens/change_password_screen.dart';
import '../features/users/profile/presentation/screens/favorite_venues_screen.dart';
import '../features/users/profile/presentation/screens/help_center_screen.dart';
import '../features/users/profile/presentation/screens/manage_profile_screen.dart';
import '../features/users/profile/presentation/screens/password_security_screen.dart';
import '../features/users/profile/presentation/screens/privacy_policy_screen.dart';
import '../features/users/profile/presentation/screens/terms_conditions_screen.dart';
import '../features/users/profile/presentation/screens/theme_settings_screen.dart';
import '../features/users/profile/presentation/screens/transaction_history_screen.dart';
import '../features/users/profile/presentation/screens/transaction_pin_screen.dart';
import '../features/users/venue_category/presentation/screens/venue_category_screen.dart';
import '../features/users/quick_action/presentation/screens/new_products_screen.dart';
import '../features/users/quick_action/presentation/screens/order_food_screen.dart';
import '../features/users/quick_action/presentation/screens/promo_deals_screen.dart';
import '../features/users/quick_action/presentation/screens/top_up_balance_screen.dart';
import '../features/users/search/presentation/screens/global_search_screen.dart';
import '../features/users/news/presentation/screens/news_detail_webview_screen.dart';
import '../models/news_model.dart';
import '../models/home_event_model.dart';
import '../models/public_place_model.dart';
import '../models/venue_model.dart';
import '../navigation/main_navigation.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/location-permission',
      builder: (context, state) => const LocationPermissionScreen(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final query = state.uri.queryParameters;
        return VerifyEmailScreen(
          userId: query['userId'] ?? '',
          email: query['email'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      path: '/news/:id',
      builder: (context, state) {
        final newsId = state.pathParameters['id']!;
        final initialNews = state.extra as NewsModel?;
        return NewsDetailWebViewScreen(
          newsId: newsId,
          initialNews: initialNews,
        );
      },
    ),
    GoRoute(
      path: '/venue/:id',
      builder: (context, state) => VenueDetailScreen(
        venueId: state.pathParameters['id']!,
        initialVenue: state.extra as VenueModel?,
      ),
    ),
    GoRoute(
      path: '/event/:id',
      builder: (context, state) => EventDetailScreen(
        eventId: state.pathParameters['id']!,
        initialEvent: state.extra as HomeEventModel?,
      ),
    ),
    GoRoute(
      path: '/public-place/:id',
      builder: (context, state) => PublicPlaceDetailScreen(
        placeId: state.pathParameters['id']!,
        initialPlace: state.extra as PublicPlaceModel?,
      ),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      path: '/booking/service/:serviceId',
      builder: (context, state) {
        final query = state.uri.queryParameters;
        return ServiceBookingScreen(
          serviceId: state.pathParameters['serviceId']!,
          venueId: query['venueId'] ?? '',
          initialService: state.extra as VenueServiceModel?,
        );
      },
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '/notification-user',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(path: '/task', builder: (context, state) => const TaskScreen()),
    GoRoute(
      path: '/venue-category/:id',
      builder: (context, state) {
        final query = state.uri.queryParameters;
        return VenueCategoryScreen(
          categoryId: state.pathParameters['id']!,
          categoryName: query['name'] ?? 'Kategori',
          categoryIcon: query['icon'],
          categoryCode: query['code'],
        );
      },
    ),
    GoRoute(
      path: '/quick/order-food',
      builder: (context, state) => const OrderFoodScreen(),
    ),
    GoRoute(
      path: '/quick/top-up',
      builder: (context, state) => const TopUpBalanceScreen(),
    ),
    GoRoute(
      path: '/quick/promo-deals',
      builder: (context, state) => const PromoDealsScreen(),
    ),
    GoRoute(
      path: '/quick/new-products',
      builder: (context, state) => const NewProductsScreen(),
    ),
    GoRoute(
      path: '/profile/manage',
      builder: (context, state) => const ManageProfileScreen(),
    ),
    GoRoute(
      path: '/profile/password-security',
      builder: (context, state) => const PasswordSecurityScreen(),
    ),
    GoRoute(
      path: '/profile/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/profile/transaction-pin',
      builder: (context, state) => const TransactionPinScreen(),
    ),
    GoRoute(
      path: '/profile/favorite-venues',
      builder: (context, state) => const FavoriteVenuesScreen(),
    ),
    GoRoute(
      path: '/profile/transactions',
      builder: (context, state) => const TransactionHistoryScreen(),
    ),
    GoRoute(
      path: '/profile/theme',
      builder: (context, state) => const ThemeSettingsScreen(),
    ),
    GoRoute(
      path: '/profile/about',
      builder: (context, state) => const AboutUsScreen(),
    ),
    GoRoute(
      path: '/profile/help',
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/profile/privacy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: '/profile/terms',
      builder: (context, state) => const TermsConditionsScreen(),
    ),
  ],
);
