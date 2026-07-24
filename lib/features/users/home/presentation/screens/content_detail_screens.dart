import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/helpers/date_formatter.dart';
import '../../../../../core/utils/result.dart' as result;
import '../../../../../models/home_event_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';
import '../../../../../widgets/common/AppButton.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_section_header.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../../../../../widgets/common/app_status_message.dart';
import '../../../../../widgets/common/app_surface_card.dart';
import '../providers/home_content_provider.dart';
import '../widgets/venue_detail/venue_detail_body.dart';

class VenueDetailScreen extends ConsumerWidget {
  const VenueDetailScreen({
    super.key,
    required this.venueId,
    this.initialVenue,
  });

  final String venueId;
  final VenueModel? initialVenue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(venueDetailProvider(venueId));

    return detailAsync.when(
      loading: () {
        if (initialVenue != null) {
          return VenueDetailBody(venueId: venueId, venue: initialVenue!);
        }
        return AppPageScaffold(
          title: 'Detail Venue',
          body: const AppDetailSkeleton(),
        );
      },
      error: (error, _) {
        if (initialVenue != null) {
          return VenueDetailBody(venueId: venueId, venue: initialVenue!);
        }
        return _DetailErrorScaffold(
          title: 'Detail Venue',
          message: error.toString(),
          onRetry: () => ref.invalidate(venueDetailProvider(venueId)),
        );
      },
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => VenueDetailBody(
          venueId: venueId,
          venue: data.mergeWith(initialVenue),
        ),
        result.Error(:final failure) =>
          initialVenue != null
              ? VenueDetailBody(venueId: venueId, venue: initialVenue!)
              : _DetailErrorScaffold(
                  title: 'Detail Venue',
                  message: failure.message,
                  onRetry: () => ref.invalidate(venueDetailProvider(venueId)),
                ),
      },
    );
  }
}

class EventDetailScreen extends ConsumerWidget {
  const EventDetailScreen({
    super.key,
    required this.eventId,
    this.initialEvent,
  });

  final String eventId;
  final HomeEventModel? initialEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(eventDetailProvider(eventId));

    return detailAsync.when(
      loading: () {
        if (initialEvent != null) {
          return _EventDetailBody(
            event: initialEvent!,
            onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
          );
        }
        return AppPageScaffold(
          title: 'Detail Event',
          body: const AppDetailSkeleton(),
        );
      },
      error: (error, _) {
        if (initialEvent != null) {
          return _EventDetailBody(
            event: initialEvent!,
            onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
          );
        }
        return _DetailErrorScaffold(
          title: 'Detail Event',
          message: error.toString(),
          onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
        );
      },
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => _EventDetailBody(
          event: data.mergeWith(initialEvent),
          onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
        ),
        result.Error(:final failure) =>
          initialEvent != null
              ? _EventDetailBody(
                  event: initialEvent!,
                  onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
                )
              : _DetailErrorScaffold(
                  title: 'Detail Event',
                  message: failure.message,
                  onRetry: () => ref.invalidate(eventDetailProvider(eventId)),
                ),
      },
    );
  }
}

class PublicPlaceDetailScreen extends ConsumerWidget {
  const PublicPlaceDetailScreen({
    super.key,
    required this.placeId,
    this.initialPlace,
  });

  final String placeId;
  final PublicPlaceModel? initialPlace;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(publicPlaceDetailProvider(placeId));

    return detailAsync.when(
      loading: () {
        if (initialPlace != null) {
          return _PublicPlaceDetailBody(
            place: initialPlace!,
            onRetry: () => ref.invalidate(publicPlaceDetailProvider(placeId)),
          );
        }
        return AppPageScaffold(
          title: 'Detail Public Place',
          body: const AppDetailSkeleton(),
        );
      },
      error: (error, _) {
        if (initialPlace != null) {
          return _PublicPlaceDetailBody(
            place: initialPlace!,
            onRetry: () => ref.invalidate(publicPlaceDetailProvider(placeId)),
          );
        }
        return _DetailErrorScaffold(
          title: 'Detail Public Place',
          message: error.toString(),
          onRetry: () => ref.invalidate(publicPlaceDetailProvider(placeId)),
        );
      },
      data: (resultValue) => switch (resultValue) {
        result.Success(:final data) => _PublicPlaceDetailBody(
          place: data.mergeWith(initialPlace),
          onRetry: () => ref.invalidate(publicPlaceDetailProvider(placeId)),
        ),
        result.Error(:final failure) =>
          initialPlace != null
              ? _PublicPlaceDetailBody(
                  place: initialPlace!,
                  onRetry: () =>
                      ref.invalidate(publicPlaceDetailProvider(placeId)),
                )
              : _DetailErrorScaffold(
                  title: 'Detail Public Place',
                  message: failure.message,
                  onRetry: () =>
                      ref.invalidate(publicPlaceDetailProvider(placeId)),
                ),
      },
    );
  }
}

class _EventDetailBody extends StatelessWidget {
  const _EventDetailBody({required this.event, required this.onRetry});

  final HomeEventModel event;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Detail Event',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroBanner(
              icon: Iconsax.calendar,
              label: 'Event',
              title: event.title,
              colors: const [Color(0xFF0F4C75), Color(0xFF3282B8)],
              imageUrl: event.imageUrl,
            ),
            const SizedBox(height: AppSpacing.xl),
            _InfoRow(icon: Iconsax.location, text: event.location),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Iconsax.calendar_1,
              text: DateFormatter.formatDate(event.date),
            ),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(icon: Iconsax.tag, text: event.category),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Iconsax.people,
              text: '${event.attendees} peserta terdaftar',
            ),
            const SizedBox(height: AppSpacing.section),
            const AppSectionHeader(title: 'Tentang Event'),
            const SizedBox(height: AppSpacing.md),
            AppSurfaceCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                event.displayDescription,
                style: TextStyle(
                  color: context.adaptiveTextSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            AppButton(
              label: 'Daftar Event',
              icon: Iconsax.user_add,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _PublicPlaceDetailBody extends StatelessWidget {
  const _PublicPlaceDetailBody({required this.place, required this.onRetry});

  final PublicPlaceModel place;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: 'Detail Public Place',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroBanner(
              icon: Iconsax.tree,
              label: 'Public Place',
              title: place.name,
              colors: const [Color(0xFF6A0572), Color(0xFFAB83A1)],
              imageUrl: place.imageUrl,
            ),
            const SizedBox(height: AppSpacing.xl),
            _InfoRow(icon: Iconsax.location, text: place.location),
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(icon: Iconsax.tag, text: place.typeLabel),
            if (place.rating > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(
                icon: Iconsax.star,
                text: 'Rating ${place.rating.toStringAsFixed(1)}',
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              icon: Iconsax.clock,
              text: place.isOpen ? 'Sedang buka' : 'Tutup sementara',
            ),
            const SizedBox(height: AppSpacing.section),
            const AppSectionHeader(title: 'Informasi'),
            const SizedBox(height: AppSpacing.md),
            AppSurfaceCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                place.displayDescription,
                style: TextStyle(
                  color: context.adaptiveTextSecondary,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.section),
            AppButton(
              label: 'Lihat di Peta',
              icon: Iconsax.map,
              isOutlined: true,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailErrorScaffold extends StatelessWidget {
  const _DetailErrorScaffold({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      title: title,
      body: AppStatusMessage(
        message: message,
        actionLabel: AppStrings.retry,
        onAction: onRetry,
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
    this.imageUrl,
  });

  final IconData icon;
  final String label;
  final String title;
  final List<Color> colors;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: imageUrl == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              )
            : null,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.35),
                  BlendMode.darken,
                ),
              )
            : null,
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
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
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
        Icon(icon, size: 18, color: context.primaryColor),
        const SizedBox(width: 10),
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
