import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Iconsax.home_2),
      selectedIcon: Icon(Iconsax.home_25),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Iconsax.document_text),
      selectedIcon: Icon(Iconsax.document_text5),
      label: 'News',
    ),
    NavigationDestination(
      icon: Icon(Iconsax.people),
      selectedIcon: Icon(Iconsax.people5),
      label: 'Groups',
    ),
    NavigationDestination(
      icon: Icon(Iconsax.activity),
      selectedIcon: Icon(Iconsax.activity5),
      label: 'Activity',
    ),
    NavigationDestination(
      icon: Icon(Iconsax.user),
      selectedIcon: Icon(Iconsax.user_octagon),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: _destinations,
    );
  }
}
