import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/mock_data_service.dart';
import '../../../../../models/quick_action_models.dart';
import '../../../../../widgets/common/app_page_scaffold.dart';
import '../../../../../widgets/common/app_skeleton.dart';
import '../widgets/quick_action_grid_card.dart';

final newProductsProvider = FutureProvider<List<NewProductModel>>((ref) async {
  await Future<void>.delayed(const Duration(milliseconds: 600));
  return MockDataService.newProducts;
});

class NewProductsScreen extends ConsumerWidget {
  const NewProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(newProductsProvider);

    return AppPageScaffold(
      title: 'New Products',
      body: productsAsync.when(
        loading: () => const AppGridSkeleton(itemCount: 6),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (products) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return QuickActionGridCard(
              title: product.name,
              subtitle: product.seller,
              badge: product.isNew ? 'NEW' : product.category,
              footer: product.formattedPrice,
              icon: Iconsax.box,
              colors: const [Color(0xFF1B5E4B), Color(0xFF2E8B6E)],
              onTap: () => context.showSnackBar('Membuka ${product.name}'),
            );
          },
        ),
      ),
    );
  }
}
