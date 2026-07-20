import '../core/helpers/json_field_helper.dart';

class PublicPlaceModel {
  const PublicPlaceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.rating,
    required this.isOpen,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String location;
  final String type;
  final double rating;
  final bool isOpen;
  final String? description;
  final String? imageUrl;

  String get displayDescription {
    final value = description?.trim();
    if (value != null && value.isNotEmpty) return value;
    return '$name adalah ${type.toLowerCase()} populer di $location. '
        'Tempat ideal untuk bersantai dan menikmati keindahan NTB.';
  }

  PublicPlaceModel mergeWith(PublicPlaceModel? other) {
    if (other == null) return this;

    return PublicPlaceModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      location: location.isNotEmpty ? location : other.location,
      type: type.isNotEmpty ? type : other.type,
      rating: rating > 0 ? rating : other.rating,
      isOpen: isOpen || other.isOpen,
      description: description ?? other.description,
      imageUrl: imageUrl ?? other.imageUrl,
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
      location: JsonFieldHelper.readString(source, [
            'location',
            'address',
            'city',
            'area',
            'district',
          ]) ??
          '-',
      type: JsonFieldHelper.readString(source, [
            'type',
            'category',
            'categoryName',
            'category_name',
            'placeType',
          ]) ??
          'Umum',
      rating: JsonFieldHelper.readDouble(source, [
            'rating',
            'averageRating',
            'average_rating',
            'score',
          ]) ??
          0,
      isOpen: JsonFieldHelper.readBool(source, [
        'isOpen',
        'is_open',
        'openNow',
        'open_now',
        'status',
      ]),
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
        'about',
        'overview',
      ]),
      imageUrl: JsonFieldHelper.readString(source, [
        'imageUrl',
        'image_url',
        'thumbnail',
        'coverImage',
        'cover_image',
        'image',
        'photo',
      ]),
    );
  }
}
