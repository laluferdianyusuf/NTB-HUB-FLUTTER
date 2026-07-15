import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Placeholder screen untuk modul courier.
/// Struktur: features/courier/presentation/screens/
class CourierDashboardScreen extends StatelessWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courier Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Modul Courier - siap dikembangkan'),
      ),
    );
  }
}
