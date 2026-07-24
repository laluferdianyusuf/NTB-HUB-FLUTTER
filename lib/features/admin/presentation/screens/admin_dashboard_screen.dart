import 'package:flutter/material.dart';

import '../../../../widgets/common/app_page_scaffold.dart';
import '../../../../widgets/common/app_status_message.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Admin Dashboard',
      body: const AppStatusMessage(
        icon: Icons.admin_panel_settings_outlined,
        message: 'Modul Admin - siap dikembangkan',
      ),
    );
  }
}
