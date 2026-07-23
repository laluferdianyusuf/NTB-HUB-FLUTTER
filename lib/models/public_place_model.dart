import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class PublicPlaceModel {
  const PublicPlaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    this.description,
    this.latitude,
    this.longitude,
    this.image,
    this.gallery = const [],
    this.isActive = true,
    this.averageRating = 0,
    this.totalReviews = 0,
    this.totalLikes = 0,
    this.totalViews = 0,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final PublicPlaceType type;
  final String address;
  final String? description;
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

  /// Legacy UI aliases.
  String get location => address;
  String get typeLabel => type.value;
  double get rating => averageRating;
  bool get isOpen => isActive;
  String? get imageUrl => image;

  List<String> get allImages {
    final images = <String>[];
    final main = image?.trim();
    if (main != null && main.isNotEmpty) images.add(main);
    for (final item in gallery) {
      final trimmed = item.trim();
      if (trimmed.isNotEmpty && !images.contains(trimmed)) {
        images.add(trimmed);
      }
    }
    return images;
  }

  String get displayDescription {
    final value = description?.trim();
    if (value != null && value.isNotEmpty) return value;
    return '$name adalah ${typeLabel.toLowerCase()} populer di $address. '
        'Tempat ideal untuk bersantai dan menikmati keindahan NTB.';
  }

  PublicPlaceModel mergeWith(PublicPlaceModel? other) {
    if (other == null) return this;

    return PublicPlaceModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      type: type,
      address: address.isNotEmpty ? address : other.address,
      description: description ?? other.description,
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

  factory PublicPlaceModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'place',
          'publicPlace',
          'public_place',
          'data',
          'result',
        ]) ??
        json;

    return PublicPlaceModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      name: JsonFieldHelper.readString(source, [
            'name',
            'title',
            'placeName',
            'place_name',
          ]) ??
          'Public Place',
      type: PublicPlaceType.fromJson(JsonFieldHelper.readString(source, [
            'type',
            'placeType',
            'place_type',
          ])) ??
          PublicPlaceType.other,
      address: JsonFieldHelper.readString(source, [
            'address',
            'location',
            'city',
            'area',
            'district',
          ]) ??
          '-',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
        'about',
        'overview',
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
        'isOpen',
        'is_open',
      ]),
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
          ]) ??
          0,
      totalLikes: JsonFieldHelper.readInt(source, [
            'totalLikes',
            'total_likes',
          ]) ??
          0,
      totalViews: JsonFieldHelper.readInt(source, [
            'totalViews',
            'total_views',
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.value,
        'address': address,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'image': image,
        'gallery': gallery,
        'is_active': isActive,
        'average_rating': averageRating,
        'total_reviews': totalReviews,
        'total_likes': totalLikes,
        'total_views': totalViews,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
