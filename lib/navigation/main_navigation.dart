import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/users/activity/presentation/screens/activity_screen.dart';
import '../features/users/home/presentation/screens/home_screen.dart';
import '../features/users/map/presentation/screens/map_screen.dart';
import '../features/users/news/presentation/screens/news_screen.dart';
import '../features/users/profile/presentation/screens/profile_screen.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class MainNavigationPage extends ConsumerWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    const pages = [
      HomeScreen(),
      NewsScreen(),
      MapScreen(),
      ActivityScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).changeIndex(index);
        },
      ),
    );
  }
}
