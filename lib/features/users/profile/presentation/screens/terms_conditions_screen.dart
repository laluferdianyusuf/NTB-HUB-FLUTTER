import 'package:flutter/material.dart';

import '../../../../../widgets/common/app_page_scaffold.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const _content =
      'Syarat dan Ketentuan NTB Hub\n\n'
      '1. Penerimaan Syarat\n'
      'Dengan menggunakan NTB Hub, Anda setuju terhadap syarat ini.\n\n'
      '2. Akun Pengguna\n'
      'Pengguna bertanggung jawab menjaga kerahasiaan akun dan password.\n\n'
      '3. Penggunaan Layanan\n'
      'Dilarang menggunakan platform untuk konten ilegal atau merugikan pihak lain.\n\n'
      '4. Booking & Transaksi\n'
      'Kebijakan refund mengikuti ketentuan masing-masing venue/event.\n\n'
      'Terakhir diperbarui: Juli 2026';

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(
      title: 'Terms and Conditions',
      content: _content,
    );
  }
}
