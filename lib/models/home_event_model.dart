class HomeEventModel {
  const HomeEventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.attendees,
    required this.category,
  });

  final String id;
  final String title;
  final String location;
  final DateTime date;
  final int attendees;
  final String category;
}
