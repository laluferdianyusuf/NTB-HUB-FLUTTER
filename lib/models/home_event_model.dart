import '../core/helpers/json_field_helper.dart';

class HomeEventModel {
  const HomeEventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.attendees,
    required this.category,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String location;
  final DateTime date;
  final int attendees;
  final String category;
  final String? description;
  final String? imageUrl;

  String get displayDescription {
    final value = description?.trim();
    if (value != null && value.isNotEmpty) return value;
    return '$title akan diselenggarakan di $location. Bergabunglah dengan '
        'komunitas NTB Hub dan jangan lewatkan event ${category.toLowerCase()} ini.';
  }

  HomeEventModel mergeWith(HomeEventModel? other) {
    if (other == null) return this;

    return HomeEventModel(
      id: id.isNotEmpty ? id : other.id,
      title: title.isNotEmpty ? title : other.title,
      location: location.isNotEmpty ? location : other.location,
      date: date,
      attendees: attendees > 0 ? attendees : other.attendees,
      category: category.isNotEmpty ? category : other.category,
      description: description ?? other.description,
      imageUrl: imageUrl ?? other.imageUrl,
    );
  }

  factory HomeEventModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'event',
          'data',
          'result',
        ]) ??
        json;

    return HomeEventModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      title: JsonFieldHelper.readString(source, [
            'title',
            'name',
            'eventName',
            'event_name',
          ]) ??
          'Event',
      location: JsonFieldHelper.readString(source, [
            'location',
            'address',
            'venue',
            'city',
            'area',
          ]) ??
          '-',
      date: JsonFieldHelper.readDateTime(source, [
            'date',
            'startDate',
            'start_date',
            'eventDate',
            'event_date',
            'startsAt',
            'starts_at',
          ]) ??
          DateTime.now(),
      attendees: JsonFieldHelper.readInt(source, [
            'attendees',
            'participants',
            'participantCount',
            'participant_count',
            'registrations',
          ]) ??
          0,
      category: JsonFieldHelper.readString(source, [
            'category',
            'categoryName',
            'category_name',
            'type',
            'eventType',
          ]) ??
          'Umum',
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
        'banner',
      ]),
    );
  }
}
