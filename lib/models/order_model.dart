import '../core/helpers/json_field_helper.dart';
import 'enums/app_enums.dart';

class Order {
  const Order({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.totalPrice,
    this.subtotal = 0,
    this.status = TransactionStatus.pending,
    this.notes,
    this.createdAt,
    this.updatedAt,
    this.items = const [],
  });

  final String id;
  final String userId;
  final String venueId;
  final double subtotal;
  final double totalPrice;
  final TransactionStatus status;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem> items;

  factory Order.fromJson(Map<String, dynamic> json) {
    final source = JsonFieldHelper.readMap(json, ['order', 'data']) ?? json;

    final itemsRaw = source['items'] ?? source['orderItems'] ?? source['order_items'];
    final items = itemsRaw is List
        ? itemsRaw
            .whereType<Map<String, dynamic>>()
            .map(OrderItem.fromJson)
            .toList()
        : const <OrderItem>[];

    return Order(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      userId: JsonFieldHelper.readString(source, ['userId', 'user_id']) ?? '',
      venueId: JsonFieldHelper.readString(source, ['venueId', 'venue_id']) ??
          '',
      subtotal: JsonFieldHelper.readDecimal(source, [
        'subtotal',
        'subTotal',
        'sub_total',
      ]),
      totalPrice: JsonFieldHelper.readDecimal(source, [
        'totalPrice',
        'total_price',
        'total',
        'amount',
      ]),
      status: TransactionStatus.fromJson(
            JsonFieldHelper.readString(source, ['status']),
          ) ??
          TransactionStatus.pending,
      notes: JsonFieldHelper.readString(source, ['notes', 'note']),
      createdAt: JsonFieldHelper.readDateTime(source, [
        'createdAt',
        'created_at',
      ]),
      updatedAt: JsonFieldHelper.readDateTime(source, [
        'updatedAt',
        'updated_at',
      ]),
      items: items,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'venueId': venueId,
        'subtotal': subtotal,
        'totalPrice': totalPrice,
        'status': status.value,
        'notes': notes,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'items': items.map((item) => item.toJson()).toList(),
      };
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.orderId,
    required this.menuId,
    required this.quantity,
    required this.unitPrice,
    this.menuName,
    this.subtotal = 0,
    this.notes,
  });

  final String id;
  final String orderId;
  final String menuId;
  final String? menuName;
  final int quantity;
  final double unitPrice;
  final double subtotal;
  final String? notes;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final source =
        JsonFieldHelper.readMap(json, ['orderItem', 'item', 'data']) ?? json;

    return OrderItem(
      id: JsonFieldHelper.readString(source, ['id', '_id']) ?? '',
      orderId: JsonFieldHelper.readString(source, ['orderId', 'order_id']) ??
          '',
      menuId: JsonFieldHelper.readString(source, ['menuId', 'menu_id']) ?? '',
      menuName: JsonFieldHelper.readString(source, [
        'menuName',
        'menu_name',
        'name',
      ]),
      quantity: JsonFieldHelper.readInt(source, ['quantity', 'qty']) ?? 1,
      unitPrice: JsonFieldHelper.readDecimal(source, [
        'unitPrice',
        'unit_price',
        'price',
      ]),
      subtotal: JsonFieldHelper.readDecimal(source, [
        'subtotal',
        'subTotal',
        'sub_total',
        'total',
      ]),
      notes: JsonFieldHelper.readString(source, ['notes', 'note']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'menuId': menuId,
        'menuName': menuName,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'subtotal': subtotal,
        'notes': notes,
      };
}
