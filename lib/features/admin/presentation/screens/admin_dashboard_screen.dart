import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';

/// Placeholder screen untuk modul admin.
/// Struktur: features/admin/presentation/screens/
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: context.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Modul Admin - siap dikembangkan'),
      ),
    );
  }
}
