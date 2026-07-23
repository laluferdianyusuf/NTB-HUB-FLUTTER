import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../core/services/profile_settings_service.dart';
import '../../../../../models/venue_model.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';

final favoriteVenuesProvider = FutureProvider<List<VenueModel>>((ref) async {
  final ids = await ProfileSettingsService().getFavoriteVenueIds();
  return MockDataService.allVenues.where((v) => ids.contains(v.id)).toList();
});

class FavoriteVenuesScreen extends ConsumerWidget {
  const FavoriteVenuesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteVenuesProvider);

    return AppPageScaffold(
      title: 'Favorite Venues',
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (venues) {
          if (venues.isEmpty) {
            return Center(
              child: Text(
                'Belum ada venue favorit',
                style: TextStyle(color: context.adaptiveTextSecondary),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: venues.length,
            itemBuilder: (context, index) =>
                _FavoriteVenueCard(venue: venues[index]),
          );
        },
      ),
    );
  }
}

class _FavoriteVenueCard extends StatelessWidget {
  const _FavoriteVenueCard({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.adaptiveDivider),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Iconsax.buildings, color: context.primaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            venue.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            venue.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.adaptiveTextSecondary,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Iconsax.star, size: 14, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(
                venue.averageRating.toStringAsFixed(1),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
