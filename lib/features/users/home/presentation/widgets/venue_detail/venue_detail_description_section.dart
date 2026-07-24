import 'package:flutter/material.dart';
import '../../../../../../models/venue_model.dart';
import '../venue_detail_hero.dart';

class VenueDetailDescriptionSection extends StatelessWidget {
  const VenueDetailDescriptionSection({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VenueDetailSectionHeader(title: 'Deskripsi'),
        const SizedBox(height: 12),
        Text(
          venue.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Theme.of(context).hintColor,
          ),
        ),
      ],
    );
  }
}
