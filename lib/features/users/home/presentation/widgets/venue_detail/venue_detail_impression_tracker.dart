import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/venue_detail_provider.dart';

class VenueDetailImpressionTracker extends ConsumerWidget {
  const VenueDetailImpressionTracker({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(venueImpressionProvider(venueId));
    return const SizedBox.shrink();
  }
}
