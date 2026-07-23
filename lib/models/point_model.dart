import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Point {
  const Point({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.referenceId,
    this.description,
    this.createdAt,
  });

  final String id;
  final String userId;
  final int amount;
  final PointActivityType type;
  final String? referenceId;
  final String? description;
  final DateTime? createdAt;

  factory Point.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['point', 'data']) ?? json;

    return Point(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      amount: JsonFieldHelper.readInt(source, ['amount', 'points', 'value']) ??
          0,
      type: PointActivityType.fromJson(
            JsonFieldHelper.readString(source, [
              'type',
              'activityType',
              'activity_type',
            ]),
          ) ??
          PointActivityType.adminGrant,
      referenceId: JsonFieldHelper.readString(source, [
        'referenceId',
        'reference_id',
      ]),
      description: JsonFieldHelper.readString(source, [
        'description',
        'desc',
        'note',
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
        'amount': amount,
        'type': type.value,
        'referenceId': referenceId,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
      };
}
