import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../search/presentation/widgets/home_search_bar.dart';
import '../../data/datasources/home_content_datasource.dart';
import '../models/home_tab_item.dart';
import '../widgets/home_carousel.dart';
import '../widgets/home_category_grid.dart';
import '../widgets/home_category_tab_view.dart';
import '../widgets/home_quick_actions.dart';
import '../widgets/home_sticky_tab_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<HomeTabItem> _tabs;
  final _datasource = HomeContentDatasource();

  @override
  void initState() {
    super.initState();
    _tabs = buildHomeTabs();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carouselItems = _datasource.getCarouselItems();
    final int item = 10;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HomeTopHeader(
              taskCount: item,
              onTaskTap: () => context.push('/task'),
              onNotificationTap: () => context.push('/notification-user'),
            ),
            const HomeSearchBar(),
            const SizedBox(height: 12),
            Expanded(
              child: ExtendedNestedScrollView(
                onlyOneScrollInBody: true,
                pinnedHeaderSliverHeightBuilder: () =>
                    HomeStickyTabBarDelegate.tabBarHeight,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const HomeCategoryGrid(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: HomeCarousel(items: carouselItems),
                          ),
                          const HomeQuickActions(),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: HomeStickyTabBarDelegate(
                        tabController: _tabController,
                        tabs: _tabs,
                        forceElevated: innerBoxIsScrolled,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: List.generate(_tabs.length, (index) {
                    return Builder(
                      builder: (context) {
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: _tabs[index].builder(context),
                        );
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTopHeader extends StatelessWidget {
  const _HomeTopHeader({
    required this.taskCount,
    required this.onTaskTap,
    required this.onNotificationTap,
  });

  final int taskCount;
  final VoidCallback onTaskTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      foregroundColor: AppColors.primary,
                    ),
                    onPressed: () {},
                    icon: const Icon(Iconsax.people),
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lalu Ferdian Yusuf',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'nama@gmail.com',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onTaskTap,
                  icon: Badge.count(
                    count: taskCount,
                    child: const Icon(Iconsax.task),
                  ),
                ),
                IconButton(
                  onPressed: onNotificationTap,
                  icon: Badge.count(
                    count: taskCount,
                    child: const Icon(Iconsax.notification),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
