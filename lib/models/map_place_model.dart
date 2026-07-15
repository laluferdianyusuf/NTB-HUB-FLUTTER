import 'package:latlong2/latlong.dart';

class MapPlaceModel {
  const MapPlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
  });

  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String category;
}

abstract final class MapPlaces {
  static const mataramCenter = LatLng(-8.5833, 116.1167);

  static const places = [
    MapPlaceModel(
      id: '1',
      name: 'Mataram',
      description: 'Ibu kota Provinsi NTB',
      location: LatLng(-8.5833, 116.1167),
      category: 'Kota',
    ),
    MapPlaceModel(
      id: '2',
      name: 'Pantai Tanjung Aan',
      description: 'Pantai berpasir putih di Lombok',
      location: LatLng(-8.8972, 116.2769),
      category: 'Wisata',
    ),
    MapPlaceModel(
      id: '3',
      name: 'Gili Trawangan',
      description: 'Pulau populer untuk snorkeling & diving',
      location: LatLng(-8.3515, 116.0405),
      category: 'Wisata',
    ),
    MapPlaceModel(
      id: '4',
      name: 'Sumbawa Besar',
      description: 'Kota utama di Pulau Sumbawa',
      location: LatLng(-8.4917, 117.4236),
      category: 'Kota',
    ),
    MapPlaceModel(
      id: '5',
      name: 'Bukit Merese',
      description: 'Spot sunset terbaik di Lombok',
      location: LatLng(-8.8947, 116.3247),
      category: 'Wisata',
    ),
  ];
}
