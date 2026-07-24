import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';
import 'financial_model.dart';

class EnsureAccountPayload {
  const EnsureAccountPayload({
    required this.type,
    this.userId,
    this.venueId,
    this.eventId,
    this.communityEventId,
    this.courierId,
    this.id,
  });

  final AccountType type;
  final String? userId;
  final String? venueId;
  final String? eventId;
  final String? communityEventId;
  final String? courierId;
  final String? id;

  Map<String, dynamic> toJson() => {
        'type': type.value,
        if (userId != null) 'userId': userId,
        if (venueId != null) 'venueId': venueId,
        if (eventId != null) 'eventId': eventId,
        if (communityEventId != null) 'communityEventId': communityEventId,
        if (courierId != null) 'courierId': courierId,
        if (id != null) 'id': id,
      };
}

class LedgerAccountBalance {
  const LedgerAccountBalance({
    required this.accountId,
    this.balance = 0,
    this.updatedAt,
  });

  final String accountId;
  final double balance;
  final DateTime? updatedAt;

  factory LedgerAccountBalance.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, [
          'balance',
          'ledgerBalance',
          'data',
          'result',
        ]) ??
        json;

    return LedgerAccountBalance(
      accountId: JsonFieldHelper.readString(source, [
            'accountId',
            'account_id',
            'id',
          ]) ??
          '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
    );
  }
}

class WalletSnapshot {
  const WalletSnapshot({
    required this.account,
    required this.balance,
    this.updatedAt,
  });

  final Account account;
  final double balance;
  final DateTime? updatedAt;
}
