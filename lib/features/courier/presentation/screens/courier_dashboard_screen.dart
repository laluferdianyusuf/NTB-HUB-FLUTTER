import 'package:flutter/material.dart';

import '../../../../widgets/common/app_page_scaffold.dart';
import '../../../../widgets/common/app_status_message.dart';

class CourierDashboardScreen extends StatelessWidget {
  const CourierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Courier Dashboard',
      body: const AppStatusMessage(
        icon: Icons.local_shipping_outlined,
        message: 'Modul Courier - siap dikembangkan',
      ),
    );
  }
}
