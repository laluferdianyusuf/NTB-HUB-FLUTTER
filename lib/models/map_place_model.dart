import 'package:latlong2/latlong.dart';

enum MapPlaceKind {
  tourism,
  restaurant,
  shop,
  mall,
  hospital,
  school,
  venue,
  terminal,
  park,
  mosque,
  market,
  hotel,
  city,
}

class MapPlaceModel {
  const MapPlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.category,
    required this.kind,
    this.routePath,
    this.address,
  });

  final String id;
  final String name;
  final String description;
  final LatLng location;
  final String category;
  final MapPlaceKind kind;
  final String? routePath;
  final String? address;
}

abstract final class MapPlaces {
  static const mataramCenter = LatLng(-8.5833, 116.1167);

  static const places = [
    MapPlaceModel(
      id: 'city-mataram',
      name: 'Mataram',
      description: 'Ibu kota Provinsi NTB',
      location: LatLng(-8.5833, 116.1167),
      category: 'Kota',
      kind: MapPlaceKind.city,
    ),
    MapPlaceModel(
      id: 'mall-epicentrum',
      name: 'Epicentrum Mall Mataram',
      description: 'Pusat perbelanjaan modern di Mataram',
      location: LatLng(-8.5789, 116.1067),
      category: 'Mall',
      kind: MapPlaceKind.mall,
      address: 'Jl. Pejanggik, Mataram',
    ),
    MapPlaceModel(
      id: 'mall-mataram',
      name: 'Mataram Mall',
      description: 'Mall populer dengan tenant fashion & kuliner',
      location: LatLng(-8.5852, 116.1184),
      category: 'Mall',
      kind: MapPlaceKind.mall,
      address: 'Jl. Panca Usaha, Mataram',
    ),
    MapPlaceModel(
      id: 'market-cakranegara',
      name: 'Pasar Cakranegara',
      description: 'Pasar tradisional dan pusat oleh-oleh NTB',
      location: LatLng(-8.5836, 116.1288),
      category: 'Pasar',
      kind: MapPlaceKind.market,
      address: 'Cakranegara, Mataram',
    ),
    MapPlaceModel(
      id: 'market-bertais',
      name: 'Pasar Bertais',
      description: 'Pasar sayur, buah, dan kebutuhan harian',
      location: LatLng(-8.5668, 116.1342),
      category: 'Pasar',
      kind: MapPlaceKind.market,
      address: 'Bertais, Mataram',
    ),
    MapPlaceModel(
      id: 'resto-ayam-taliwang',
      name: 'Ayam Taliwang Khas NTB',
      description: 'Restoran ayam taliwang legendaris',
      location: LatLng(-8.5812, 116.1135),
      category: 'Kuliner',
      kind: MapPlaceKind.restaurant,
      address: 'Jl. Pejanggik, Mataram',
    ),
    MapPlaceModel(
      id: 'resto-plecing',
      name: 'Warung Plecing Kangkung',
      description: 'Kuliner khas Lombok plecing kangkung',
      location: LatLng(-8.5876, 116.1210),
      category: 'Kuliner',
      kind: MapPlaceKind.restaurant,
      address: 'Sweta, Mataram',
    ),
    MapPlaceModel(
      id: 'resto-seafood',
      name: 'Seafood Pantai Ampenan',
      description: 'Seafood segar di pinggir pantai',
      location: LatLng(-8.5689, 116.0785),
      category: 'Kuliner',
      kind: MapPlaceKind.restaurant,
      address: 'Ampenan, Mataram',
    ),
    MapPlaceModel(
      id: 'shop-alfamart-sweta',
      name: 'Alfamart Sweta',
      description: 'Minimarket kebutuhan sehari-hari',
      location: LatLng(-8.5891, 116.1198),
      category: 'Toko',
      kind: MapPlaceKind.shop,
      address: 'Sweta, Mataram',
    ),
    MapPlaceModel(
      id: 'shop-indomaret-pejanggik',
      name: 'Indomaret Pejanggik',
      description: 'Minimarket 24 jam',
      location: LatLng(-8.5804, 116.1092),
      category: 'Toko',
      kind: MapPlaceKind.shop,
      address: 'Jl. Pejanggik, Mataram',
    ),
    MapPlaceModel(
      id: 'shop-oleh-oleh',
      name: 'Toko Oleh-oleh NTB',
      description: 'Kerupuk, kain tenun, dan suvenir khas NTB',
      location: LatLng(-8.5848, 116.1256),
      category: 'Toko',
      kind: MapPlaceKind.shop,
      address: 'Cakranegara, Mataram',
    ),
    MapPlaceModel(
      id: 'hospital-rsud',
      name: 'RSUD Provinsi NTB',
      description: 'Rumah sakit rujukan provinsi',
      location: LatLng(-8.5810, 116.1120),
      category: 'Rumah Sakit',
      kind: MapPlaceKind.hospital,
      address: 'Jl. Adi Sucipto, Mataram',
    ),
    MapPlaceModel(
      id: 'hospital-rsgm',
      name: 'RSGM Unram',
      description: 'Rumah sakit gigi dan mulut',
      location: LatLng(-8.5598, 116.0965),
      category: 'Rumah Sakit',
      kind: MapPlaceKind.hospital,
      address: 'Dasan Agung, Mataram',
    ),
    MapPlaceModel(
      id: 'school-unram',
      name: 'Universitas Mataram',
      description: 'Kampus utama Universitas Mataram',
      location: LatLng(-8.5605, 116.0958),
      category: 'Sekolah',
      kind: MapPlaceKind.school,
      address: 'Jl. Majapahit, Mataram',
    ),
    MapPlaceModel(
      id: 'school-sma-negri',
      name: 'SMA Negeri 1 Mataram',
      description: 'Sekolah menengah negeri',
      location: LatLng(-8.5768, 116.1045),
      category: 'Sekolah',
      kind: MapPlaceKind.school,
      address: 'Mataram',
    ),
    MapPlaceModel(
      id: 'mosque-islamic-center',
      name: 'Islamic Center NTB',
      description: 'Masjid megah dan landmark Mataram',
      location: LatLng(-8.5720, 116.1050),
      category: 'Masjid',
      kind: MapPlaceKind.mosque,
      address: 'Jl. Langko, Mataram',
    ),
    MapPlaceModel(
      id: 'park-sangkareang',
      name: 'Taman Sangkareang',
      description: 'Taman kota untuk rekreasi keluarga',
      location: LatLng(-8.5860, 116.1140),
      category: 'Taman',
      kind: MapPlaceKind.park,
      address: 'Mataram',
    ),
    MapPlaceModel(
      id: 'hotel-lombok-raya',
      name: 'Hotel Lombok Raya',
      description: 'Hotel berbintang di pusat kota',
      location: LatLng(-8.5775, 116.1108),
      category: 'Hotel',
      kind: MapPlaceKind.hotel,
      address: 'Jl. Catur Warga, Mataram',
    ),
    MapPlaceModel(
      id: 'terminal-mandalika',
      name: 'Terminal Mandalika',
      description: 'Terminal bus antar kota',
      location: LatLng(-8.5712, 116.1295),
      category: 'Terminal',
      kind: MapPlaceKind.terminal,
      address: 'Bertais, Mataram',
    ),
    MapPlaceModel(
      id: 'terminal-ampenan',
      name: 'Pelabuhan Ampenan',
      description: 'Pelabuhan penyeberangan dan perikanan',
      location: LatLng(-8.5675, 116.0768),
      category: 'Terminal',
      kind: MapPlaceKind.terminal,
      address: 'Ampenan, Mataram',
    ),
    MapPlaceModel(
      id: 'venue-auditorium',
      name: 'Auditorium Mataram',
      description: 'Venue acara seminar dan pertunjukan',
      location: LatLng(-8.5825, 116.1155),
      category: 'Venue',
      kind: MapPlaceKind.venue,
      routePath: '/venue/1',
      address: 'Jl. Pejanggik No. 115, Mataram',
    ),
    MapPlaceModel(
      id: 'tourism-tanjung-aan',
      name: 'Pantai Tanjung Aan',
      description: 'Pantai berpasir putih di Lombok',
      location: LatLng(-8.8972, 116.2769),
      category: 'Wisata',
      kind: MapPlaceKind.tourism,
      routePath: '/public-place/2',
    ),
    MapPlaceModel(
      id: 'tourism-gili-trawangan',
      name: 'Gili Trawangan',
      description: 'Pulau populer untuk snorkeling & diving',
      location: LatLng(-8.3515, 116.0405),
      category: 'Wisata',
      kind: MapPlaceKind.tourism,
    ),
    MapPlaceModel(
      id: 'tourism-bukit-merese',
      name: 'Bukit Merese',
      description: 'Spot sunset terbaik di Lombok',
      location: LatLng(-8.8947, 116.3247),
      category: 'Wisata',
      kind: MapPlaceKind.tourism,
      routePath: '/public-place/3',
    ),
    MapPlaceModel(
      id: 'tourism-senggigi',
      name: 'Pantai Senggigi',
      description: 'Destinasi pantai dan resor populer',
      location: LatLng(-8.4967, 116.0456),
      category: 'Wisata',
      kind: MapPlaceKind.tourism,
    ),
    MapPlaceModel(
      id: 'city-sumbawa',
      name: 'Sumbawa Besar',
      description: 'Kota utama di Pulau Sumbawa',
      location: LatLng(-8.4917, 117.4236),
      category: 'Kota',
      kind: MapPlaceKind.city,
    ),
    MapPlaceModel(
      id: 'airport-lombok',
      name: 'Bandara Internasional Lombok',
      description: 'Bandara utama NTB',
      location: LatLng(-8.7570, 116.2760),
      category: 'Terminal',
      kind: MapPlaceKind.terminal,
    ),
  ];

  static LatLng fallbackCoordinate({
    required String seed,
    required LatLng base,
    required int index,
  }) {
    final hash = seed.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
    final angle = (hash + index * 47) * 0.0174533;
    final radius = 0.004 + (index % 6) * 0.0015;
    return LatLng(
      base.latitude + radius * _sinApprox(angle),
      base.longitude + radius * _cosApprox(angle),
    );
  }

  static double _sinApprox(double radians) {
    final x = radians % (2 * 3.141592653589793);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }

  static double _cosApprox(double radians) {
    return _sinApprox(radians + 1.5707963267948966);
  }
}
