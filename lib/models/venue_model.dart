import '../core/helpers/json_field_helper.dart';

class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.rating,
    required this.category,
    required this.priceRange,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String location;
  final int capacity;
  final double rating;
  final String category;
  final String priceRange;
  final String? description;
  final String? imageUrl;

  String get displayDescription {
    final value = description?.trim();
    if (value != null && value.isNotEmpty) return value;
    return '$name adalah venue populer di $location dengan kapasitas '
        '$capacity orang. Cocok untuk acara komunitas, seminar, dan pertemuan.';
  }

  VenueModel mergeWith(VenueModel? other) {
    if (other == null) return this;

    return VenueModel(
      id: id.isNotEmpty ? id : other.id,
      name: name.isNotEmpty ? name : other.name,
      location: location.isNotEmpty ? location : other.location,
      capacity: capacity > 0 ? capacity : other.capacity,
      rating: rating > 0 ? rating : other.rating,
      category: category.isNotEmpty ? category : other.category,
      priceRange: priceRange.isNotEmpty ? priceRange : other.priceRange,
      description: description ?? other.description,
      imageUrl: imageUrl ?? other.imageUrl,
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
      location: JsonFieldHelper.readString(source, [
            'location',
            'address',
            'city',
            'area',
            'district',
          ]) ??
          '-',
      capacity: JsonFieldHelper.readInt(source, [
            'capacity',
            'maxCapacity',
            'max_capacity',
            'maxGuest',
          ]) ??
          0,
      rating: JsonFieldHelper.readDouble(source, [
            'rating',
            'averageRating',
            'average_rating',
            'score',
          ]) ??
          0,
      category: JsonFieldHelper.readString(source, [
            'category',
            'categoryName',
            'category_name',
            'type',
            'venueType',
          ]) ??
          'Umum',
      priceRange: JsonFieldHelper.readString(source, [
            'priceRange',
            'price_range',
            'price',
            'priceLabel',
            'price_label',
          ]) ??
          '-',
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
