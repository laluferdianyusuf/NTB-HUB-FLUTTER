import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';

class VenueDetailScreen extends StatefulWidget {
  const VenueDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final venue = MockDataService.allVenues.firstWhere(
      (v) => v.id == widget.venueId,
      orElse: () => MockDataService.allVenues.first,
    );

    return AppPageScaffold(
      title: 'Detail Venue',
      body: _loading
          ? const AppDetailSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(
                    icon: Iconsax.buildings,
                    label: 'Venue',
                    title: venue.name,
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(icon: Iconsax.location, text: venue.location),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.people,
                    text: 'Kapasitas ${venue.capacity} orang',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Iconsax.tag, text: venue.category),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Iconsax.wallet, text: venue.priceRange),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.star,
                    text: 'Rating ${venue.rating.toStringAsFixed(1)}',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${venue.name} adalah venue populer di ${venue.location} '
                    'dengan kapasitas ${venue.capacity} orang. Cocok untuk acara '
                    'komunitas, seminar, dan pertemuan.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/booking'),
                      icon: const Icon(Iconsax.ticket, color: Colors.white),
                      label: const Text(
                        'Booking Venue',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = MockDataService.allHomeEvents.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => MockDataService.allHomeEvents.first,
    );

    return AppPageScaffold(
      title: 'Detail Event',
      body: _loading
          ? const AppDetailSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(
                    icon: Iconsax.calendar,
                    label: 'Event',
                    title: event.title,
                    colors: const [Color(0xFF0F4C75), Color(0xFF3282B8)],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(icon: Iconsax.location, text: event.location),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.calendar_1,
                    text: DateFormatter.formatDate(event.date),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Iconsax.tag, text: event.category),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.people,
                    text: '${event.attendees} peserta terdaftar',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tentang Event',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${event.title} akan diselenggarakan di ${event.location}. '
                    'Bergabunglah dengan komunitas NTB Hub dan jangan lewatkan '
                    'event ${event.category.toLowerCase()} ini.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Iconsax.user_add, color: Colors.white),
                      label: const Text(
                        'Daftar Event',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class PublicPlaceDetailScreen extends StatefulWidget {
  const PublicPlaceDetailScreen({super.key, required this.placeId});

  final String placeId;

  @override
  State<PublicPlaceDetailScreen> createState() => _PublicPlaceDetailScreenState();
}

class _PublicPlaceDetailScreenState extends State<PublicPlaceDetailScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final place = MockDataService.allPublicPlaces.firstWhere(
      (p) => p.id == widget.placeId,
      orElse: () => MockDataService.allPublicPlaces.first,
    );

    return AppPageScaffold(
      title: 'Detail Public Place',
      body: _loading
          ? const AppDetailSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBanner(
                    icon: Iconsax.tree,
                    label: 'Public Place',
                    title: place.name,
                    colors: const [Color(0xFF6A0572), Color(0xFFAB83A1)],
                  ),
                  const SizedBox(height: 20),
                  _InfoRow(icon: Iconsax.location, text: place.location),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Iconsax.tag, text: place.type),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.star,
                    text: 'Rating ${place.rating.toStringAsFixed(1)}',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Iconsax.clock,
                    text: place.isOpen ? 'Sedang buka' : 'Tutup sementara',
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Informasi',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${place.name} adalah ${place.type.toLowerCase()} populer '
                    'di ${place.location}. Tempat ideal untuk bersantai dan '
                    'menikmati keindahan NTB.',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Iconsax.map),
                      label: const Text('Lihat di Peta'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.icon,
    required this.label,
    required this.title,
    this.colors = const [Color(0xFF1B5E4B), Color(0xFF2E8B6E)],
  });

  final IconData icon;
  final String label;
  final String title;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: const TextStyle(color: AppColors.textPrimary)),
        ),
      ],
    );
  }
}
