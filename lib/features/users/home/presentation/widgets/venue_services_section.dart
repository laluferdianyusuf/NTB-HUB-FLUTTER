import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/venue_service_model.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../providers/home_content_provider.dart';
import '../../../booking/presentation/utils/booking_navigation.dart';
import 'venue_detail_hero.dart';

class VenueServicesSection extends ConsumerWidget {
  const VenueServicesSection({
    super.key,
    required this.venueId,
  });

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(venueServicesProvider(venueId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VenueDetailSectionHeader(
          title: 'Layanan Venue',
          subtitle: 'Pilih layanan yang tersedia di venue ini',
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: servicesAsync.when(
            loading: () => const _VenueServicesLoading(key: ValueKey('loading')),
            error: (error, _) => _VenueServicesError(
              key: const ValueKey('error'),
              message: error.toString(),
              onRetry: () => ref.invalidate(venueServicesProvider(venueId)),
            ),
            data: (resultValue) => switch (resultValue) {
              result.Success(:final data) => data.isEmpty
                  ? const _VenueServicesEmpty(key: ValueKey('empty'))
                  : _VenueServicesList(
                      key: const ValueKey('list'),
                      venueId: venueId,
                      services: data,
                    ),
              result.Error(:final failure) => _VenueServicesError(
                key: const ValueKey('failure'),
                message: failure.message,
                onRetry: () => ref.invalidate(venueServicesProvider(venueId)),
              ),
            },
          ),
        ),
      ],
    );
  }
}

class _VenueServicesList extends StatelessWidget {
  const _VenueServicesList({
    super.key,
    required this.venueId,
    required this.services,
  });

  final String venueId;
  final List<VenueServiceModel> services;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < services.length; i++) ...[
          _VenueServiceCard(
            venueId: venueId,
            service: services[i],
          ),
          if (i < services.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _VenueServiceCard extends StatelessWidget {
  const _VenueServiceCard({
    required this.venueId,
    required this.service,
  });

  final String venueId;
  final VenueServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: service.id.isEmpty
            ? null
            : () => openServiceBooking(
                  context,
                  serviceId: service.id,
                  venueId: venueId,
                  service: service,
                ),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ServiceThumbnail(imageUrl: service.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (service.displayCategory.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          service.displayCategory,
                          style: TextStyle(
                            color: AppColors.primary.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (service.description.trim().isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          service.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.45,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ServiceChip(
                  icon: Iconsax.wallet_2,
                  label: service.displayPrice,
                  highlighted: true,
                ),
                if (service.bookingType != null &&
                    service.bookingType!.trim().isNotEmpty)
                  _ServiceChip(
                    icon: Iconsax.calendar,
                    label: service.bookingType!,
                  ),
                if (service.unitType != null &&
                    service.unitType!.trim().isNotEmpty)
                  _ServiceChip(
                    icon: Iconsax.box,
                    label: service.unitType!,
                  ),
                if (service.units.isNotEmpty)
                  _ServiceChip(
                    icon: Iconsax.layer,
                    label: '${service.units.length} unit',
                  ),
              ],
            ),
          ),
          if (service.units.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.7),
                border: Border(
                  top: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Unit tersedia',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...service.units.map(
                    (unit) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              unit.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (unit.capacity != null)
                            Text(
                              '${unit.capacity} kap.',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceThumbnail extends StatelessWidget {
  const _ServiceThumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        image: url != null && url.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: url == null || url.isEmpty
          ? const Icon(Iconsax.box, color: AppColors.primary, size: 24)
          : null,
    );
  }
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: highlighted
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.divider,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: highlighted ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: highlighted ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueServicesLoading extends StatelessWidget {
  const _VenueServicesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 1 ? 0 : 12),
          child: const AppSkeleton(
            height: 132,
            width: double.infinity,
            borderRadius: 18,
          ),
        ),
      ),
    );
  }
}

class _VenueServicesEmpty extends StatelessWidget {
  const _VenueServicesEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Iconsax.box, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Belum ada layanan untuk venue ini.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueServicesError extends StatelessWidget {
  const _VenueServicesError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Iconsax.refresh, size: 16),
            label: const Text('Muat Ulang'),
          ),
        ],
      ),
    );
  }
}
