import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.recipientType,
    required this.recipientId,
    required this.title,
    required this.message,
    required this.type,
    this.entityId,
    this.image,
    this.isRead = false,
    this.isGlobal = false,
    this.adminOnly = false,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final NotificationRecipientType recipientType;
  final String recipientId;
  final String title;
  final String message;
  final AppNotificationType type;
  final String? entityId;
  final String? image;
  final bool isRead;
  final bool isGlobal;
  final bool adminOnly;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Legacy UI alias.
  String get body => message;

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      recipientType: recipientType,
      recipientId: recipientId,
      title: title,
      message: message,
      type: type,
      entityId: entityId,
      image: image,
      isRead: isRead ?? this.isRead,
      isGlobal: isGlobal,
      adminOnly: adminOnly,
      userId: userId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'notification',
          'data',
          'result',
        ]) ??
        json;

    return NotificationModel(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      recipientType: NotificationRecipientType.fromJson(
            JsonFieldHelper.readString(source, [
              'recipientType',
              'recipient_type',
            ]),
          ) ??
          NotificationRecipientType.user,
      recipientId: JsonFieldHelper.readString(source, [
            'recipientId',
            'recipient_id',
          ]) ??
          '',
      title: JsonFieldHelper.readString(source, ['title']) ?? '',
      message: JsonFieldHelper.readString(source, [
            'message',
            'body',
            'content',
          ]) ??
          '',
      type: AppNotificationType.fromJson(JsonFieldHelper.readString(source, [
            'type',
          ])) ??
          AppNotificationType.system,
      entityId: JsonFieldHelper.readString(source, ['entityId', 'entity_id']),
      image: JsonFieldHelper.readString(source, ['image', 'imageUrl']),
      isRead: JsonFieldHelper.readBool(source, [
        'isRead',
        'is_read',
        'read',
      ], fallback: false),
      isGlobal: JsonFieldHelper.readBool(source, [
        'isGlobal',
        'is_global',
      ], fallback: false),
      adminOnly: JsonFieldHelper.readBool(source, [
        'adminOnly',
        'admin_only',
      ], fallback: false),
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']),
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
        'recipient_type': recipientType.value,
        'recipient_id': recipientId,
        'title': title,
        'message': message,
        'type': type.value,
        'entity_id': entityId,
        'image': image,
        'is_read': isRead,
        'is_global': isGlobal,
        'admin_only': adminOnly,
        'user_id': userId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
