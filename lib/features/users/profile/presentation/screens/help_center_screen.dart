import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      ('Bagaimana cara booking venue?', 'Buka menu Booking, pilih venue, lalu ikuti langkah pembayaran.'),
      ('Bagaimana reset password?', 'Profile > Password & Security > Ubah Password.'),
      ('Bagaimana mengaktifkan biometric?', 'Profile > Enable Biometric.'),
      ('Hubungi support?', 'Email: support@ntbhub.id atau WhatsApp: 0812-0000-0000.'),
    ];

    return AppPageScaffold(
      title: 'Help Center',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Iconsax.message_question, color: AppColors.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Temukan jawaban atau hubungi tim support kami.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...faqs.map(
            (faq) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text(
                  faq.$1,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        faq.$2,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => context.showSnackBar('Membuka chat support...'),
              icon: const Icon(Iconsax.messages_2),
              label: const Text('Hubungi Support'),
            ),
          ),
        ],
      ),
    );
  }
}
