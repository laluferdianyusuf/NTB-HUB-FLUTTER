import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../widgets/common/app_page_scaffold.dart';

class PasswordSecurityScreen extends StatelessWidget {
  const PasswordSecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Password & Security',
      body: ListView(
        children: [
          ProfileMenuTile(
            icon: Iconsax.lock,
            title: 'Ubah Password',
            subtitle: 'Perbarui password akun Anda',
            onTap: () => context.push('/profile/change-password'),
          ),
          ProfileMenuTile(
            icon: Iconsax.shield_tick,
            title: 'Keamanan Akun',
            subtitle: 'Akun dilindungi dengan enkripsi',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
