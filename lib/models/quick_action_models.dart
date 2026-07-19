class FoodItemModel {
  const FoodItemModel({
    required this.id,
    required this.name,
    required this.merchant,
    required this.price,
    required this.rating,
    required this.category,
  });

  final String id;
  final String name;
  final String merchant;
  final int price;
  final double rating;
  final String category;

  String get formattedPrice {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }
}

class TopUpPackageModel {
  const TopUpPackageModel({
    required this.id,
    required this.amount,
    required this.bonus,
    required this.isPopular,
  });

  final String id;
  final int amount;
  final int bonus;
  final bool isPopular;

  String get formattedAmount {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }
}

class PromoDealModel {
  const PromoDealModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountLabel,
    required this.validUntil,
    required this.category,
  });

  final String id;
  final String title;
  final String description;
  final String discountLabel;
  final DateTime validUntil;
  final String category;
}

class NewProductModel {
  const NewProductModel({
    required this.id,
    required this.name,
    required this.seller,
    required this.price,
    required this.category,
    required this.isNew,
  });

  final String id;
  final String name;
  final String seller;
  final int price;
  final String category;
  final bool isNew;

  String get formattedPrice {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $formatted';
  }
}
