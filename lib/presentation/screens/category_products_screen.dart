import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/product_cubit/product_cubit.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_indicator.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure we have products loaded. If not, fetch them.
    // In a real app, you might want to fetch only category products here if the API limits.
    // But since we have a getAllProducts cache approach in Cubit, we can reuse it.
    final state = context.read<ProductCubit>().state;
    if (state is! ProductLoaded) {
      context.read<ProductCubit>().fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingIndicator();
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ProductLoaded) {
            final categoryProducts = state.products
                .where(
                  (p) =>
                      p.category?.toLowerCase() ==
                      widget.categoryName.toLowerCase(),
                )
                .toList();

            if (categoryProducts.isEmpty) {
              return const Center(
                child: Text('No products found in this category.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column (Even indices)
                  Expanded(
                    child: Column(
                      children: List.generate(
                        (categoryProducts.length / 2).ceil(),
                        (index) {
                          final itemIndex = index * 2;
                          // Pattern: Big, Small, Big, Small
                          final aspectRatio = index % 2 == 0 ? 0.65 : 0.85;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductCard(
                              product: categoryProducts[itemIndex],
                              aspectRatio: aspectRatio,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between columns
                  // Right Column (Odd indices)
                  Expanded(
                    child: Column(
                      children: List.generate(
                        (categoryProducts.length / 2).floor(),
                        (index) {
                          final itemIndex = index * 2 + 1;
                          // Pattern: Small, Big, Small, Big (Opposite of Left)
                          final aspectRatio = index % 2 == 0 ? 0.85 : 0.65;
                          if (itemIndex >= categoryProducts.length)
                            return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductCard(
                              product: categoryProducts[itemIndex],
                              aspectRatio: aspectRatio,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
