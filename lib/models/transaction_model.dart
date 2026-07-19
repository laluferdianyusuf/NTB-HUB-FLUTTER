class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.status,
    required this.date,
    required this.type,
  });

  final String id;
  final String title;
  final int amount;
  final String status;
  final DateTime date;
  final String type;

  String get formattedAmount {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp $formatted';
  }
}
