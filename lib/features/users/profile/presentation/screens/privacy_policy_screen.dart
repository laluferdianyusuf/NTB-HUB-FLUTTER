import 'package:flutter/material.dart';

import '../../../../../widgets/common/app_page_scaffold.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _content =
      'Kebijakan Privasi NTB Hub\n\n'
      '1. Informasi yang Kami Kumpulkan\n'
      'Kami mengumpulkan data akun, lokasi (dengan izin), dan data penggunaan aplikasi.\n\n'
      '2. Penggunaan Data\n'
      'Data digunakan untuk autentikasi, rekomendasi, booking, dan komunikasi layanan.\n\n'
      '3. Keamanan Data\n'
      'Kami menerapkan enkripsi dan standar keamanan industri.\n\n'
      '4. Hak Pengguna\n'
      'Pengguna dapat meminta akses, koreksi, atau penghapusan data via support@ntbhub.id.\n\n'
      'Terakhir diperbarui: Juli 2026';

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'Privacy and Policy',
      content: _content,
    );
  }
}
