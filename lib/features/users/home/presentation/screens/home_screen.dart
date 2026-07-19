import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../data/datasources/home_content_datasource.dart';
import '../models/home_tab_item.dart';
import '../widgets/home_carousel.dart';
import '../widgets/home_category_grid.dart';
import '../widgets/home_category_tab_view.dart';
import '../widgets/home_sticky_tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void _onCategoryTap(HomeCategoryItem category) {
    final index = _tabs.indexWhere((tab) => tab.label == category.label);
    if (index != -1) {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final carouselItems = _datasource.getCarouselItems();
    final int item = 10;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          pinnedHeaderSliverHeightBuilder: () =>
              HomeStickyTabBarDelegate.tabBarHeight,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: AppColors.primary,
                              ),
                              onPressed: () {},
                              icon: const Icon(Iconsax.people),
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.appName,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "nama@gmail.com",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13,
                                      ),
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
                            onPressed: () => context.push("/task"),
                            icon: Badge.count(
                              count: item,
                              child: const Icon(Iconsax.task),
                            ),
                            // color: AppColors.textPrimary,
                          ),
                          IconButton(
                            onPressed: () => context.push("/notification-user"),
                            icon: Badge.count(
                              count: item,
                              child: const Icon(Iconsax.notification),
                            ),
                            // color: AppColors.textPrimary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    HomeCategoryGrid(onCategoryTap: _onCategoryTap),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: HomeCarousel(items: carouselItems),
                    ),
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
    );
  }
}
