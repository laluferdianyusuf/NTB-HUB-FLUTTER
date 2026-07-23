import '../core/helpers/json_field_helper.dart';

class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.province,
    required this.description,
    this.ownerId,
    this.latitude,
    this.longitude,
    this.image,
    this.gallery = const [],
    this.isActive = false,
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalViews = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final String province;
  final String description;
  final String? ownerId;
  final double? latitude;
  final double? longitude;
  final String? image;
  final List<String> gallery;
  final bool isActive;
  final double averageRating;
  final int totalReviews;
  final int totalLikes;
  final int totalViews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Alamat lengkap untuk tampilan UI.
  String get location {
    final parts = [address, city, province]
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.isEmpty ? '-' : parts.join(', ');
  }

  /// Alias untuk kompatibilitas UI yang masih memakai [imageUrl].
  String? get imageUrl => image;

  /// Alias untuk kompatibilitas UI yang masih memakai [rating].
  double get rating => averageRating;

  /// Semua gambar venue (cover + gallery).
  List<String> get allImages {
    final images = <String>[];
    final main = image?.trim();
    if (main != null && main.isNotEmpty) {
      images.add(main);
    }
    for (final item in gallery) {
      final trimmed = item.trim();
      if (trimmed.isNotEmpty && !images.contains(trimmed)) {
        images.add(trimmed);
      }
    }
    return images;
  }

  String get displayDescription {
    final value = description.trim();
    if (value.isNotEmpty) return value;
    return '$name berlokasi di $location. Cocok untuk acara komunitas, '
        'seminar, dan pertemuan.';
  }

  VenueModel mergeWith(VenueModel? other) {
    if (other == null) return this;

    return VenueModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      address: address.isNotEmpty ? address : other.address,
      city: city.isNotEmpty ? city : other.city,
      province: province.isNotEmpty ? province : other.province,
      description: description.isNotEmpty ? description : other.description,
      ownerId: ownerId ?? other.ownerId,
      latitude: latitude ?? other.latitude,
      longitude: longitude ?? other.longitude,
      image: image ?? other.image,
      gallery: gallery.isNotEmpty ? gallery : other.gallery,
      isActive: isActive || other.isActive,
      averageRating:
          averageRating > 0 ? averageRating : other.averageRating,
      totalReviews: totalReviews > 0 ? totalReviews : other.totalReviews,
      totalLikes: totalLikes > 0 ? totalLikes : other.totalLikes,
      totalViews: totalViews > 0 ? totalViews : other.totalViews,
      createdAt: createdAt ?? other.createdAt,
      updatedAt: updatedAt ?? other.updatedAt,
    );
  }

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'venue',
          'data',
          'result',
        ]) ??
        json;

    return VenueModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(source, [
            'name',
            'title',
            'venueName',
            'venue_name',
          ]) ??
          'Venue',
      address: JsonFieldHelper.readString(source, [
            'address',
            'street',
            'streetAddress',
            'street_address',
          ]) ??
          '',
      city: JsonFieldHelper.readString(source, ['city', 'area', 'district']) ??
          '',
      province: JsonFieldHelper.readString(source, [
            'province',
            'state',
            'region',
          ]) ??
          '',
      description: JsonFieldHelper.readString(source, [
            'description',
            'desc',
            'about',
            'overview',
          ]) ??
          '',
      ownerId: JsonFieldHelper.readString(source, [
        'ownerId',
        'owner_id',
        'ownerID',
      ]),
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']),
      longitude: JsonFieldHelper.readDouble(source, [
        'longitude',
        'lng',
        'long',
      ]),
      image: JsonFieldHelper.readString(source, [
        'image',
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'photo',
      ]),
      gallery: JsonFieldHelper.readStringList(source, [
        'gallery',
        'images',
        'photos',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ], fallback: false),
      averageRating: JsonFieldHelper.readDouble(source, [
            'averageRating',
            'average_rating',
            'rating',
            'score',
          ]) ??
          0,
      totalReviews: JsonFieldHelper.readInt(source, [
            'totalReviews',
            'total_reviews',
            'reviewCount',
            'review_count',
          ]) ??
          0,
      totalLikes: JsonFieldHelper.readInt(source, [
            'totalLikes',
            'total_likes',
            'likeCount',
            'like_count',
          ]) ??
          0,
      totalViews: JsonFieldHelper.readInt(source, [
            'totalViews',
            'total_views',
            'viewCount',
            'view_count',
          ]) ??
          0,
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }
}
