enum ActivityType { groupJoin, like, event, booking, comment }

class ActivityModel {
  const ActivityModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final String title;
  final ActivityType type;
  final DateTime createdAt;

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: ActivityType.values.byName(json['type'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type.name,
    'created_at': createdAt.toIso8601String(),
  };
}
