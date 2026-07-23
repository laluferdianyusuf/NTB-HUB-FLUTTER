import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Task {
  const Task({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.type,
    required this.title,
    this.description,
    this.config = const {},
    this.rewardPoints,
    this.isActive = true,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final TaskEntityType entityType;
  final String entityId;
  final TaskType type;
  final String title;
  final String? description;
  final Map<String, dynamic> config;
  final int? rewardPoints;
  final bool isActive;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Task.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['task', 'data']) ?? json;

    return Task(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      entityType: TaskEntityType.fromJson(
            JsonFieldHelper.readString(source, [
              'entityType',
              'entity_type',
            ]),
          ) ??
          TaskEntityType.community,
      entityId: JsonFieldHelper.readString(source, [
            'entityId',
            'entity_id',
          ]) ??
          '',
      type: TaskType.fromJson(JsonFieldHelper.readString(source, ['type'])) ??
          TaskType.custom,
      title: JsonFieldHelper.readString(source, ['title', 'name']) ?? '',
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
      ]),
      config: JsonFieldHelper.readJson(source, ['config', 'settings']),
      rewardPoints: JsonFieldHelper.readInt(source, [
        'rewardPoints',
        'reward_points',
        'points',
      ]),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      startAt: JsonFieldHelper.readDateTime(source, [
        'startAt',
        'start_at',
      ]),
      endAt: JsonFieldHelper.readDateTime(source, [
        'endAt',
        'end_at',
      ]),
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
        'entityType': entityType.value,
        'entityId': entityId,
        'type': type.value,
        'title': title,
        'description': description,
        'config': config,
        'rewardPoints': rewardPoints,
        'isActive': isActive,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class TaskExecution {
  const TaskExecution({
    required this.id,
    required this.taskId,
    required this.userId,
    this.status = TaskExecutionStatus.pending,
    this.result = const {},
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String taskId;
  final String userId;
  final TaskExecutionStatus status;
  final Map<String, dynamic> result;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory TaskExecution.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['taskExecution', 'data']) ?? json;

    return TaskExecution(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      taskId: JsonFieldHelper.readString(source, ['taskId', 'task_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      status: TaskExecutionStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          TaskExecutionStatus.pending,
      result: JsonFieldHelper.readJson(source, ['result', 'data', 'metadata']),
      completedAt: JsonFieldHelper.readDateTime(source, [
        'completedAt',
        'completed_at',
      ]),
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
        'taskId': taskId,
        'userId': userId,
        'status': status.value,
        'result': result,
        'completedAt': completedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class TaskQrSession {
  const TaskQrSession({
    required this.id,
    required this.taskId,
    required this.code,
    required this.expiresAt,
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String taskId;
  final String code;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime? createdAt;

  factory TaskQrSession.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['taskQrSession', 'data']) ?? json;

    return TaskQrSession(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      taskId: JsonFieldHelper.readString(source, ['taskId', 'task_id']) ?? '',
      code: JsonFieldHelper.readString(source, ['code', 'qrCode']) ?? '',
      expiresAt: JsonFieldHelper.readDateTime(source, [
            'expiresAt',
            'expires_at',
          ]) ??
          DateTime.now(),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'code': code,
        'expiresAt': expiresAt.toIso8601String(),
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class UserPresenceSnapshot {
  const UserPresenceSnapshot({
    required this.id,
    required this.userId,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.capturedAt,
    this.createdAt,
  });

  final String id;
  final String userId;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final DateTime? capturedAt;
  final DateTime? createdAt;

  factory UserPresenceSnapshot.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'userPresenceSnapshot',
          'presence',
          'data',
        ]) ??
        json;

    return UserPresenceSnapshot(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      latitude: JsonFieldHelper.readDouble(source, ['latitude', 'lat']),
      longitude: JsonFieldHelper.readDouble(source, [
        'longitude',
        'lng',
        'long',
      ]),
      accuracy: JsonFieldHelper.readDouble(source, ['accuracy']),
      capturedAt: JsonFieldHelper.readDateTime(source, [
        'capturedAt',
        'captured_at',
      ]),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'capturedAt': capturedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
      };
}
