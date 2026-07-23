import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class ActivityLog {
  const ActivityLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.actorId,
    this.actorType = ActorType.system,
    this.metadata = const {},
    this.createdAt,
  });

  final String id;
  final String? actorId;
  final ActorType actorType;
  final ActivityEntityType entityType;
  final String entityId;
  final ActivityAction action;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['activityLog', 'data']) ?? json;

    return ActivityLog(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      actorId: JsonFieldHelper.readString(source, ['actorId', 'actor_id']),
      actorType: ActorType.fromJson(
            JsonFieldHelper.readString(source, ['actorType', 'actor_type']),
          ) ??
          ActorType.system,
      entityType: ActivityEntityType.fromJson(
            JsonFieldHelper.readString(source, [
              'entityType',
              'entity_type',
            ]),
          ) ??
          ActivityEntityType.booking,
      entityId: JsonFieldHelper.readString(source, [
            'entityId',
            'entity_id',
          ]) ??
          '',
      action: ActivityAction.fromJson(
            JsonFieldHelper.readString(source, ['action']),
          ) ??
          ActivityAction.create,
      metadata: JsonFieldHelper.readJson(source, ['metadata', 'meta', 'data']),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'actorId': actorId,
        'actorType': actorType.value,
        'entityType': entityType.value,
        'entityId': entityId,
        'action': action.value,
        'metadata': metadata,
        'createdAt': createdAt?.toIso8601String(),
      };
}
