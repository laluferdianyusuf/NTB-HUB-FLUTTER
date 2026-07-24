import 'package:flutter/material.dart';
import 'package:ntbhub_flutter/widgets/common/AppButton.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../models/venue_model.dart';
import '../venue_detail_hero.dart';
import '../venue_services_section.dart';
import 'venue_detail_description_section.dart';
import 'venue_detail_impression_tracker.dart';
import 'venue_detail_operational_section.dart';
import 'venue_detail_overview_section.dart';
import 'venue_detail_reviews_section.dart';

class VenueDetailBody extends StatelessWidget {
  const VenueDetailBody({
    super.key,
    required this.venueId,
    required this.venue,
  });

  final String venueId;
  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          VenueDetailSliverHeader(venue: venue),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.detailSheetRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageHorizontal,
                  AppSpacing.section,
                  AppSpacing.pageHorizontal,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VenueDetailImpressionTracker(venueId: venueId),
                    VenueDetailOverviewSection(venue: venue),
                    const SizedBox(height: AppSpacing.section),
                    VenueDetailOperationalSection(venueId: venueId),
                    const SizedBox(height: AppSpacing.section),
                    VenueDetailDescriptionSection(venue: venue),
                    const SizedBox(height: AppSpacing.section),
                    VenueServicesSection(venueId: venueId),
                    const SizedBox(height: AppSpacing.section),
                    VenueDetailReviewsSection(venueId: venueId),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
