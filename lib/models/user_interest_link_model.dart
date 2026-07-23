import '../core/helpers/json_field_helper.dart';

class UserInterest {
  const UserInterest({
    required this.id,
    required this.userId,
    required this.interestId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String interestId;
  final DateTime? createdAt;

  factory UserInterest.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['userInterest', 'data']) ?? json;

    return UserInterest(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      interestId: JsonFieldHelper.readString(
            source,
            ['interestId', 'interest_id'],
          ) ??
          '',
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'interestId': interestId,
        'createdAt': createdAt?.toIso8601String(),
      };
}
