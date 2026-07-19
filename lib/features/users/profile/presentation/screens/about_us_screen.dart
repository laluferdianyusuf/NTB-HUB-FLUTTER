import 'package:flutter/material.dart';

import '../../../../../widgets/common/app_page_scaffold.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const _content =
      'NTB Hub adalah platform komunitas digital untuk warga Nusa Tenggara Barat. '
      'Kami menghubungkan masyarakat, UMKM, pelaku wisata, dan pemerintah daerah '
      'dalam satu ekosistem.\n\n'
      'Visi kami adalah membuat NTB lebih terhubung, informatif, dan mudah dijelajahi '
      'melalui teknologi.\n\n'
      'Versi aplikasi: 1.0.0\n'
      'Dikembangkan oleh INSPIRA TECH';

  @override
  Widget build(BuildContext context) {
    return const StaticContentScreen(title: 'About Us', content: _content);
  }
}
