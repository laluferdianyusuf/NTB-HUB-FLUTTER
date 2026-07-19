enum NotificationType { booking, event, system, promo }

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  final bool isRead;

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}
