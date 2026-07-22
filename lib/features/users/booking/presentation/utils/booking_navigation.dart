import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/venue_service_model.dart';

void openServiceBooking(
  BuildContext context, {
  required String serviceId,
  required String venueId,
  VenueServiceModel? service,
}) {
  context.push(
    '/booking/service/$serviceId?venueId=$venueId',
    extra: service,
  );
}
