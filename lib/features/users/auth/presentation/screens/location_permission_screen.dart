import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../providers/auth_provider.dart';
import '../providers/location_provider.dart';

class LocationPermissionScreen extends ConsumerStatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  ConsumerState<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends ConsumerState<LocationPermissionScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkAndSkip();
  }

  Future<void> _checkAndSkip() async {
    final handled = await ref
        .read(locationServiceProvider)
        .isPermissionHandled();
    if (handled && mounted) {
      await _navigateNext();
    }
  }

  Future<void> _navigateNext() async {
    final user = await ref.read(authProvider.future);
    if (!mounted) return;
    context.go(user != null ? '/home' : '/login');
  }

  Future<void> _requestLocation() async {
    setState(() => _isLoading = true);

    final service = ref.read(locationServiceProvider);
    final status = await service.requestPermission();
    await service.markPermissionHandled();

    if (status.isGranted || status.isLimited) {
      await ref.read(locationProvider.notifier).fetchCurrentLocation();
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
    await _navigateNext();
  }

  Future<void> _skip() async {
    await ref.read(locationServiceProvider).markPermissionHandled();
    await _navigateNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.location,
                  size: 72,
                  color: context.primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Aktifkan Lokasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.adaptiveTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'NTB Hub membutuhkan akses lokasi untuk menampilkan peta, '
                'event terdekat, dan rekomendasi wisata di sekitar Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.adaptiveTextSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const _FeatureRow(
                icon: Iconsax.map,
                text: 'Lihat destinasi wisata di peta NTB',
              ),
              SizedBox(height: 12),
              const _FeatureRow(
                icon: Iconsax.calendar,
                text: 'Temukan event terdekat dari lokasi Anda',
              ),
              SizedBox(height: 12),
              const _FeatureRow(
                icon: Iconsax.people,
                text: 'Hubungkan dengan komunitas lokal sekitar',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _requestLocation,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Iconsax.location, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Memproses...' : 'Aktifkan Lokasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _isLoading ? null : _skip,
                child: Text(
                  'Lewati untuk Sekarang',
                  style: TextStyle(color: context.adaptiveTextSecondary),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: context.primaryColor, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: context.adaptiveTextPrimary),
          ),
        ),
      ],
    );
  }
}
