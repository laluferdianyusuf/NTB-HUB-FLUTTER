/// Enum values aligned with the backend Prisma schema.
library;

enum Role {
  customer('CUSTOMER'),
  admin('ADMIN'),
  courier('COURIER'),
  venueOwner('VENUE_OWNER'),
  venueStaff('VENUE_STAFF'),
  eventOwner('EVENT_OWNER'),
  communityOwner('COMMUNITY_OWNER');

  const Role(this.value);
  final String value;

  static Role? fromJson(String? raw) => _parse(raw, values, (e) => e.value);
}

enum BookingStatus {
  pending('PENDING'),
  paid('PAID'),
  ongoing('ONGOING'),
  cancelled('CANCELLED'),
  completed('COMPLETED'),
  expired('EXPIRED');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum TransactionStatus {
  pending('PENDING'),
  success('SUCCESS'),
  failed('FAILED'),
  refunded('REFUNDED'),
  expired('EXPIRED'),
  cancelled('CANCELLED');

  const TransactionStatus(this.value);
  final String value;

  static TransactionStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PointActivityType {
  register('REGISTER'),
  booking('BOOKING'),
  eventPurchase('EVENT_PURCHASE'),
  review('REVIEW'),
  payment('PAYMENT'),
  promo('PROMO'),
  refund('REFUND'),
  adminGrant('ADMIN_GRANT'),
  checkIn('CHECK_IN');

  const PointActivityType(this.value);
  final String value;

  static PointActivityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum InvoiceStatus {
  pending('PENDING'),
  paid('PAID'),
  cancelled('CANCELLED'),
  refunded('REFUNDED'),
  expired('EXPIRED');

  const InvoiceStatus(this.value);
  final String value;

  static InvoiceStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum WithdrawStatus {
  pending('PENDING'),
  approved('APPROVED'),
  processing('PROCESSING'),
  paid('PAID'),
  rejected('REJECTED'),
  failed('FAILED');

  const WithdrawStatus(this.value);
  final String value;

  static WithdrawStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum EventStatus {
  upcoming('UPCOMING'),
  ongoing('ONGOING'),
  finished('FINISHED'),
  cancelled('CANCELLED');

  const EventStatus(this.value);
  final String value;

  static EventStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum TicketStatus {
  active('ACTIVE'),
  used('USED'),
  expired('EXPIRED'),
  refunded('REFUNDED');

  const TicketStatus(this.value);
  final String value;

  static TicketStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum EventOrderStatus {
  pending('PENDING'),
  paid('PAID'),
  cancelled('CANCELLED'),
  expired('EXPIRED');

  const EventOrderStatus(this.value);
  final String value;

  static EventOrderStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PublicPlaceType {
  tourism('TOURISM'),
  hospital('HOSPITAL'),
  school('SCHOOL'),
  park('PARK'),
  mall('MALL'),
  terminal('TERMINAL'),
  other('OTHER');

  const PublicPlaceType(this.value);
  final String value;

  static PublicPlaceType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum UnitType {
  field('FIELD'),
  table('TABLE'),
  room('ROOM'),
  court('COURT');

  const UnitType(this.value);
  final String value;

  static UnitType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum BookingType {
  time('TIME'),
  session('SESSION'),
  none('NONE');

  const BookingType(this.value);
  final String value;

  static BookingType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum NewsStatus {
  auto('AUTO'),
  manual('MANUAL'),
  failed('FAILED');

  const NewsStatus(this.value);
  final String value;

  static NewsStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CourierStatus {
  offline('OFFLINE'),
  online('ONLINE'),
  onDelivery('ON_DELIVERY'),
  suspended('SUSPENDED');

  const CourierStatus(this.value);
  final String value;

  static CourierStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum VehicleType {
  motorcycle('MOTORCYCLE'),
  car('CAR'),
  bicycle('BICYCLE'),
  walking('WALKING');

  const VehicleType(this.value);
  final String value;

  static VehicleType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum DeliveryStatus {
  pending('PENDING'),
  assigned('ASSIGNED'),
  pickedUp('PICKED_UP'),
  onTheWay('ON_THE_WAY'),
  delivered('DELIVERED'),
  cancelled('CANCELLED');

  const DeliveryStatus(this.value);
  final String value;

  static DeliveryStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum StaffPosition {
  manager('MANAGER'),
  cashier('CASHIER'),
  receptionist('RECEPTIONIST'),
  cleaning('CLEANING'),
  security('SECURITY'),
  technician('TECHNICIAN'),
  other('OTHER');

  const StaffPosition(this.value);
  final String value;

  static StaffPosition? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum Gender {
  male('MALE'),
  female('FEMALE'),
  other('OTHER');

  const Gender(this.value);
  final String value;

  static Gender? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CommunityMemberStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED');

  const CommunityMemberStatus(this.value);
  final String value;

  static CommunityMemberStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CommunityMemberRole {
  owner('OWNER'),
  admin('ADMIN'),
  member('MEMBER');

  const CommunityMemberRole(this.value);
  final String value;

  static CommunityMemberRole? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CommunityEventType {
  meetup('MEETUP'),
  online('ONLINE'),
  announcement('ANNOUNCEMENT'),
  workshop('WORKSHOP'),
  other('OTHER');

  const CommunityEventType(this.value);
  final String value;

  static CommunityEventType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CommunityEventStatus {
  upcoming('UPCOMING'),
  ongoing('ONGOING'),
  finished('FINISHED'),
  cancelled('CANCELLED');

  const CommunityEventStatus(this.value);
  final String value;

  static CommunityEventStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CommentEntityType {
  community('COMMUNITY'),
  event('EVENT'),
  publicPlace('PUBLIC_PLACE');

  const CommentEntityType(this.value);
  final String value;

  static CommentEntityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum TaskEntityType {
  community('COMMUNITY'),
  event('EVENT'),
  publicPlace('PUBLIC_PLACE');

  const TaskEntityType(this.value);
  final String value;

  static TaskEntityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum TaskType {
  attendEvent('ATTEND_EVENT'),
  checkIn('CHECK_IN'),
  ratePlace('RATE_PLACE'),
  custom('CUSTOM');

  const TaskType(this.value);
  final String value;

  static TaskType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum TaskExecutionStatus {
  pending('PENDING'),
  completed('COMPLETED'),
  failed('FAILED');

  const TaskExecutionStatus(this.value);
  final String value;

  static TaskExecutionStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PromotionBannerType {
  internal('INTERNAL'),
  external('EXTERNAL');

  const PromotionBannerType(this.value);
  final String value;

  static PromotionBannerType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PromotionEntityType {
  venue('VENUE'),
  event('EVENT'),
  community('COMMUNITY'),
  publicPlace('PUBLIC_PLACE'),
  none('NONE');

  const PromotionEntityType(this.value);
  final String value;

  static PromotionEntityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum InvoiceEntityType {
  booking('BOOKING'),
  eventOrder('EVENT_ORDER'),
  communityEventOrder('COMMUNITY_EVENT_ORDER'),
  topup('TOPUP'),
  order('ORDER');

  const InvoiceEntityType(this.value);
  final String value;

  static InvoiceEntityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum AccountType {
  user('USER'),
  venue('VENUE'),
  event('EVENT'),
  courier('COURIER'),
  platform('PLATFORM'),
  community('COMMUNITY');

  const AccountType(this.value);
  final String value;

  static AccountType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum LedgerDirection {
  debit('DEBIT'),
  credit('CREDIT');

  const LedgerDirection(this.value);
  final String value;

  static LedgerDirection? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum LedgerReferenceType {
  topup('TOPUP'),
  bookingPayment('BOOKING_PAYMENT'),
  eventPayment('EVENT_PAYMENT'),
  communityEventPayment('COMMUNITY_EVENT_PAYMENT'),
  refund('REFUND'),
  withdrawal('WITHDRAWAL'),
  settlement('SETTLEMENT'),
  fee('FEE'),
  adjustment('ADJUSTMENT'),
  order('ORDER');

  const LedgerReferenceType(this.value);
  final String value;

  static LedgerReferenceType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum CheckInMethod {
  manual('MANUAL'),
  ticket('TICKET');

  const CheckInMethod(this.value);
  final String value;

  static CheckInMethod? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum DiscountType {
  percent('PERCENT'),
  fixed('FIXED');

  const DiscountType(this.value);
  final String value;

  static DiscountType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PromotionType {
  menuDiscount('MENU_DISCOUNT'),
  bundle('BUNDLE'),
  buyXGetY('BUY_X_GET_Y'),
  orderDiscount('ORDER_DISCOUNT'),
  freeItem('FREE_ITEM');

  const PromotionType(this.value);
  final String value;

  static PromotionType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum PromotionStatus {
  pending('PENDING'),
  approved('APPROVED'),
  rejected('REJECTED');

  const PromotionStatus(this.value);
  final String value;

  static PromotionStatus? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum ActivityEntityType {
  withdraw('WITHDRAW'),
  booking('BOOKING'),
  order('ORDER'),
  event('EVENT'),
  communityEvent('COMMUNITY_EVENT'),
  delivery('DELIVERY'),
  promotion('PROMOTION');

  const ActivityEntityType(this.value);
  final String value;

  static ActivityEntityType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum ActivityAction {
  create('CREATE'),
  update('UPDATE'),
  delete('DELETE'),
  approve('APPROVE'),
  reject('REJECT'),
  process('PROCESS'),
  paid('PAID'),
  cancel('CANCEL'),
  expire('EXPIRE');

  const ActivityAction(this.value);
  final String value;

  static ActivityAction? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum ActorType {
  user('USER'),
  admin('ADMIN'),
  system('SYSTEM');

  const ActorType(this.value);
  final String value;

  static ActorType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum AppNotificationType {
  withdraw('WITHDRAW'),
  order('ORDER'),
  booking('BOOKING'),
  system('SYSTEM');

  const AppNotificationType(this.value);
  final String value;

  static AppNotificationType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

enum NotificationRecipientType {
  user('USER'),
  venue('VENUE'),
  event('EVENT'),
  community('COMMUNITY'),
  courier('COURIER'),
  admin('ADMIN');

  const NotificationRecipientType(this.value);
  final String value;

  static NotificationRecipientType? fromJson(String? raw) =>
      _parse(raw, values, (e) => e.value);
}

T? _parse<T>(
  String? raw,
  List<T> values,
  String Function(T value) read,
) {
  if (raw == null || raw.trim().isEmpty) return null;
  final normalized = raw.trim().toUpperCase();
  for (final value in values) {
    if (read(value) == normalized) return value;
  }
  return null;
}
