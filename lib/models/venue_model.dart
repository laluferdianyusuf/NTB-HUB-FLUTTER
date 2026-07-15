class VenueModel {
  const VenueModel({
    required this.id,
    required this.name,
    required this.location,
    required this.capacity,
    required this.rating,
    required this.category,
    required this.priceRange,
  });

  final String id;
  final String name;
  final String location;
  final int capacity;
  final double rating;
  final String category;
  final String priceRange;
}
