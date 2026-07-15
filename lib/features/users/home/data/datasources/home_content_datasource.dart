import '../../../../../core/helpers/pagination_helper.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/carousel_item_model.dart';
import '../../../../../models/home_event_model.dart';
import '../../../../../models/public_place_model.dart';
import '../../../../../models/venue_model.dart';

class HomeContentDatasource {
  HomeContentDatasource();

  static const int pageSize = 8;

  List<CarouselItemModel> getCarouselItems() {
    return MockDataService.carouselItems;
  }

  Future<PaginationResult<VenueModel>> getVenuesPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaginationHelper.paginate(
      MockDataService.allVenues,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<PaginationResult<HomeEventModel>> getEventsPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaginationHelper.paginate(
      MockDataService.allHomeEvents,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<PaginationResult<PublicPlaceModel>> getPublicPlacesPage(
    int page,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return PaginationHelper.paginate(
      MockDataService.allPublicPlaces,
      page: page,
      pageSize: pageSize,
    );
  }
}
