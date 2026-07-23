import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../models/home_tab_item.dart';
import '../../../../../core/extensions/context_extensions.dart';

class HomeStickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  HomeStickyTabBarDelegate({
    required this.tabController,
    required this.tabs,
    this.forceElevated = false,
  });

  final TabController tabController;
  final List<HomeTabItem> tabs;
  final bool forceElevated;

  static const double tabBarHeight = 48;

  @override
  double get minExtent => tabBarHeight;

  @override
  double get maxExtent => tabBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: forceElevated || overlapsContent ? 2 : 0,
      shadowColor: Colors.black26,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        dividerColor: context.adaptiveDivider,
        labelColor: context.primaryColor,
        unselectedLabelColor: context.adaptiveTextSecondary,
        indicatorColor: context.primaryColor,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        tabs: tabs.map((tab) => Tab(text: tab.label)).toList(),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeStickyTabBarDelegate oldDelegate) {
    return oldDelegate.tabController != tabController ||
        oldDelegate.tabs != tabs ||
        oldDelegate.forceElevated != forceElevated;
  }
}
