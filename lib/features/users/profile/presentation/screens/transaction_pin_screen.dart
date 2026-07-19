import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_text_field.dart';
import '../providers/profile_settings_provider.dart';

class TransactionPinScreen extends ConsumerStatefulWidget {
  const TransactionPinScreen({super.key});

  @override
  ConsumerState<TransactionPinScreen> createState() =>
      _TransactionPinScreenState();
}

class _TransactionPinScreenState extends ConsumerState<TransactionPinScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSaving = false;
  bool _hasExistingPin = false;

  @override
  void initState() {
    super.initState();
    _loadPinStatus();
  }

  Future<void> _loadPinStatus() async {
    final pin = await ref.read(profileSettingsServiceProvider).getTransactionPin();
    if (mounted) setState(() => _hasExistingPin = pin != null);
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    if (_pinController.text.length != 6) {
      context.showSnackBar('PIN harus 6 digit', isError: true);
      return;
    }
    if (_pinController.text != _confirmController.text) {
      context.showSnackBar('Konfirmasi PIN tidak cocok', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    await ref.read(profileSettingsServiceProvider).setTransactionPin(
      _pinController.text,
    );
    await ref.read(profileSettingsProvider.notifier).refreshPinStatus();

    if (!mounted) return;
    setState(() => _isSaving = false);
    context.showSnackBar('Transaction PIN berhasil disimpan');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Transaction PIN',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Iconsax.password_check,
                    size: 48,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _hasExistingPin ? 'Ubah Transaction PIN' : 'Atur Transaction PIN',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'PIN digunakan untuk konfirmasi transaksi booking dan pembayaran.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _pinController,
              label: 'PIN Baru',
              hint: '6 digit angka',
              prefixIcon: Iconsax.lock,
              keyboardType: TextInputType.number,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _confirmController,
              label: 'Konfirmasi PIN',
              hint: 'Ulangi PIN',
              prefixIcon: Iconsax.lock,
              keyboardType: TextInputType.number,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _savePin,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Simpan PIN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
