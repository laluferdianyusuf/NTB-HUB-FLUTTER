import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../models/operational_hours_model.dart';
import '../../../../../models/venue_service_model.dart';
import '../../../../../repository/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(client: ref.watch(dioClientProvider)),
);

final serviceDetailProvider =
    FutureProvider.family<Result<VenueServiceModel>, String>((
  ref,
  serviceId,
) async {
  return ref.read(bookingRepositoryProvider).getServiceDetail(serviceId);
});

final operationalHoursProvider =
    FutureProvider.family<Result<OperationalScheduleModel>, String>((
  ref,
  venueId,
) async {
  return ref.read(bookingRepositoryProvider).getOperationalHours(venueId);
});

final serviceUnitsProvider =
    FutureProvider.family<Result<List<VenueServiceUnitModel>>, String>((
  ref,
  serviceId,
) async {
  return ref.read(bookingRepositoryProvider).getUnitsByService(serviceId);
});

typedef ServiceBookingArgs = ({String serviceId, String venueId});

final serviceBookingDataProvider = FutureProvider.family<
    Result<ServiceBookingData>,
    ServiceBookingArgs>((ref, args) async {
  final repository = ref.read(bookingRepositoryProvider);

  final results = await Future.wait([
    repository.getServiceDetail(args.serviceId),
    repository.getOperationalHours(args.venueId),
    repository.getUnitsByService(args.serviceId),
  ]);

  final detailResult = results[0] as Result<VenueServiceModel>;
  final hoursResult = results[1] as Result<OperationalScheduleModel>;
  final unitsResult = results[2] as Result<List<VenueServiceUnitModel>>;

  if (detailResult case Error(:final failure)) {
    return Error(failure);
  }
  if (hoursResult case Error(:final failure)) {
    return Error(failure);
  }
  if (unitsResult case Error(:final failure)) {
    return Error(failure);
  }

  return Success(
    ServiceBookingData(
      service: (detailResult as Success<VenueServiceModel>).data,
      schedule: (hoursResult as Success<OperationalScheduleModel>).data,
      units: (unitsResult as Success<List<VenueServiceUnitModel>>).data,
    ),
  );
});

class ServiceBookingData {
  const ServiceBookingData({
    required this.service,
    required this.schedule,
    required this.units,
  });

  final VenueServiceModel service;
  final OperationalScheduleModel schedule;
  final List<VenueServiceUnitModel> units;
}
