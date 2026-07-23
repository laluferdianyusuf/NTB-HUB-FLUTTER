import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Payment {
  const Payment({
    required this.id,
    required this.userId,
    required this.amount,
    this.status = TransactionStatus.pending,
    this.method,
    this.externalId,
    this.metadata = const {},
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final double amount;
  final TransactionStatus status;
  final String? method;
  final String? externalId;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Payment.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['payment', 'data']) ?? json;

    return Payment(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      amount: JsonFieldHelper.readDecimal(source, ['amount', 'total']),
      status: TransactionStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          TransactionStatus.pending,
      method: JsonFieldHelper.readString(source, [
        'method',
        'paymentMethod',
        'payment_method',
      ]),
      externalId: JsonFieldHelper.readString(source, [
        'externalId',
        'external_id',
        'referenceId',
        'reference_id',
      ]),
      metadata: JsonFieldHelper.readJson(source, ['metadata', 'meta']),
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
        'userId': userId,
        'amount': amount,
        'status': status.value,
        'method': method,
        'externalId': externalId,
        'metadata': metadata,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class Account {
  const Account({
    required this.id,
    required this.type,
    required this.ownerId,
    this.balance = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final AccountType type;
  final String ownerId;
  final double balance;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Account.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['account', 'data']) ?? json;

    return Account(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      type: AccountType.fromJson(
            JsonFieldHelper.readString(source, ['type']),
          ) ??
          AccountType.user,
      ownerId: JsonFieldHelper.readString(source, ['ownerId', 'owner_id']) ??
          '',
      balance: JsonFieldHelper.readDecimal(source, ['balance', 'amount']),
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
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
        'type': type.value,
        'ownerId': ownerId,
        'balance': balance,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class LedgerEntry {
  const LedgerEntry({
    required this.id,
    required this.accountId,
    required this.direction,
    required this.amount,
    required this.referenceType,
    required this.referenceId,
    this.description,
    this.createdAt,
  });

  final String id;
  final String accountId;
  final LedgerDirection direction;
  final double amount;
  final LedgerReferenceType referenceType;
  final String referenceId;
  final String? description;
  final DateTime? createdAt;

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['ledgerEntry', 'data']) ?? json;

    return LedgerEntry(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      accountId: JsonFieldHelper.readString(source, [
            'accountId',
            'account_id',
          ]) ??
          '',
      direction: LedgerDirection.fromJson(
            JsonFieldHelper.readString(source, ['direction']),
          ) ??
          LedgerDirection.debit,
      amount: JsonFieldHelper.readDecimal(source, ['amount']),
      referenceType: LedgerReferenceType.fromJson(
            JsonFieldHelper.readString(source, [
              'referenceType',
              'reference_type',
            ]),
          ) ??
          LedgerReferenceType.adjustment,
      referenceId: JsonFieldHelper.readString(source, [
            'referenceId',
            'reference_id',
          ]) ??
          '',
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
        'accountId': accountId,
        'direction': direction.value,
        'amount': amount,
        'referenceType': referenceType.value,
        'referenceId': referenceId,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
      };
}

class Invoice {
  const Invoice({
    required this.id,
    required this.userId,
    required this.entityType,
    required this.entityId,
    required this.amount,
    this.status = InvoiceStatus.pending,
    this.dueDate,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final InvoiceEntityType entityType;
  final String entityId;
  final double amount;
  final InvoiceStatus status;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['invoice', 'data']) ?? json;

    return Invoice(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      entityType: InvoiceEntityType.fromJson(
            JsonFieldHelper.readString(source, [
              'entityType',
              'entity_type',
            ]),
          ) ??
          InvoiceEntityType.booking,
      entityId: JsonFieldHelper.readString(source, [
            'entityId',
            'entity_id',
          ]) ??
          '',
      amount: JsonFieldHelper.readDecimal(source, ['amount', 'total']),
      status: InvoiceStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          InvoiceStatus.pending,
      dueDate: JsonFieldHelper.readDateTime(source, [
        'dueDate',
        'due_date',
      ]),
      paidAt: JsonFieldHelper.readDateTime(source, [
        'paidAt',
        'paid_at',
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
        'userId': userId,
        'entityType': entityType.value,
        'entityId': entityId,
        'amount': amount,
        'status': status.value,
        'dueDate': dueDate?.toIso8601String(),
        'paidAt': paidAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class WithdrawRequest {
  const WithdrawRequest({
    required this.id,
    required this.amount,
    this.venueId,
    this.eventId,
    this.communityId,
    this.courierId,
    this.status = WithdrawStatus.pending,
    this.bankAccount,
    this.notes,
    this.requestedAt,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? venueId;
  final String? eventId;
  final String? communityId;
  final String? courierId;
  final double amount;
  final WithdrawStatus status;
  final String? bankAccount;
  final String? notes;
  final DateTime? requestedAt;
  final DateTime? processedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory WithdrawRequest.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['withdrawRequest', 'data']) ?? json;

    return WithdrawRequest(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']),
      eventId: JsonFieldHelper.readString(source, ['eventId', 'event_id']),
      communityId:
          JsonFieldHelper.readString(source, ['communityId', 'community_id']),
      courierId:
          JsonFieldHelper.readString(source, ['courierId', 'courier_id']),
      amount: JsonFieldHelper.readDecimal(source, ['amount']),
      status: WithdrawStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          WithdrawStatus.pending,
      bankAccount: JsonFieldHelper.readString(source, [
        'bankAccount',
        'bank_account',
      ]),
      notes: JsonFieldHelper.readString(source, ['notes', 'note']),
      requestedAt: JsonFieldHelper.readDateTime(source, [
        'requestedAt',
        'requested_at',
      ]),
      processedAt: JsonFieldHelper.readDateTime(source, [
        'processedAt',
        'processed_at',
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
        'venueId': venueId,
        'eventId': eventId,
        'communityId': communityId,
        'courierId': courierId,
        'amount': amount,
        'status': status.value,
        'bankAccount': bankAccount,
        'notes': notes,
        'requestedAt': requestedAt?.toIso8601String(),
        'processedAt': processedAt?.toIso8601String(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

class UserVirtualAccount {
  const UserVirtualAccount({
    required this.id,
    required this.userId,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final String bankCode;
  final String accountNumber;
  final String accountName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory UserVirtualAccount.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(
          json,
          ['userVirtualAccount', 'virtualAccount', 'data'],
        ) ??
        json;

    return UserVirtualAccount(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      bankCode: JsonFieldHelper.readString(source, [
            'bankCode',
            'bank_code',
          ]) ??
          '',
      accountNumber: JsonFieldHelper.readString(source, [
            'accountNumber',
            'account_number',
          ]) ??
          '',
      accountName: JsonFieldHelper.readString(source, [
            'accountName',
            'account_name',
          ]) ??
          '',
      isActive: JsonFieldHelper.readBool(source, [
        'isActive',
        'is_active',
        'active',
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
        'userId': userId,
        'bankCode': bankCode,
        'accountNumber': accountNumber,
        'accountName': accountName,
        'isActive': isActive,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}
