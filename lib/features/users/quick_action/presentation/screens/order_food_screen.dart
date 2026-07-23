import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/quick_action_models.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../widgets/quick_action_grid_card.dart';

final orderFoodProvider = FutureProvider<List<FoodItemModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 600));
  return MockDataService.foodItems;
});

class OrderFoodScreen extends ConsumerWidget {
  const OrderFoodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodAsync = ref.watch(orderFoodProvider);

    return AppPageScaffold(
      title: 'Order Food',
      body: foodAsync.when(
        loading: () => const AppGridSkeleton(itemCount: 6),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return QuickActionGridCard(
              title: item.name,
              subtitle: item.merchant,
              badge: item.category,
              footer: item.formattedPrice,
              rating: item.rating,
              icon: Iconsax.coffee,
              colors: const [Color(0xFFE76F51), Color(0xFFF4A261)],
              onTap: () =>
                  context.showSnackBar('${item.name} ditambahkan ke keranjang'),
            );
          },
        ),
      ),
    );
  }
}
