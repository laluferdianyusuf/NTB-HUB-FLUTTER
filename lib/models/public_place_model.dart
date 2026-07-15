class PublicPlaceModel {
  const PublicPlaceModel({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.rating,
    required this.isOpen,
  });

  final String id;
  final String name;
  final String location;
  final String type;
  final double rating;
  final bool isOpen;
}
