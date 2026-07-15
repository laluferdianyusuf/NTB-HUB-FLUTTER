import 'package:go_router/go_router.dart';
import 'package:ntbhub_flutter/features/users/notification/presentation/screens/notification_screen.dart';
import 'package:ntbhub_flutter/features/users/task/presentation/screens/task_screen.dart';

import '../features/event/presentation/screens/event_list_screen.dart';
import '../features/users/auth/presentation/screens/onboarding_screen.dart';
import '../features/users/auth/presentation/screens/location_permission_screen.dart';
import '../features/users/auth/presentation/screens/login_screen.dart';
import '../features/users/auth/presentation/screens/register_screen.dart';
import '../features/users/auth/presentation/screens/splash_screen.dart';
import '../features/users/booking/presentation/screens/booking_screen.dart';
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
      path: '/home',
      builder: (context, state) => const MainNavigationPage(),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingScreen(),
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
  ],
);
