import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/cart_repository.dart';
import '../../data/repositories/product_repository.dart';

// States
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double totalPrice;

  const CartLoaded({this.items = const [], this.totalPrice = 0.0});

  @override
  List<Object> get props => [items, totalPrice];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object> get props => [message];
}

// Cubit
class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;
  final ProductRepository _productRepository; // Need this to fetch details

  CartCubit(this._cartRepository, this._productRepository)
    : super(const CartLoaded(items: [], totalPrice: 0));

  Future<void> loadCart(int userId) async {
    emit(CartLoading());
    try {
      final cartItemsData = await _cartRepository.getCart(userId);

      if (cartItemsData.isEmpty) {
        emit(const CartLoaded(items: [], totalPrice: 0));
        return;
      }

      final List<CartItemModel> loadedItems = [];

      // Optimize: Fetch all products once instead of in loop
      List<ProductModel> allProducts = [];
      try {
        allProducts = await _productRepository.getAllProducts();
      } catch (e) {
        // If product fetch fails, we might show unknown products or handle error
        // For now, proceed with empty list causing "Unknown" or skip
      }

      for (var itemData in cartItemsData) {
        final productId = itemData['productId'];
        final quantity = itemData['quantity'];

        // Find product in the pre-fetched list
        final product = allProducts.firstWhere(
          (p) => p.id == productId,
          orElse: () => ProductModel(id: productId, title: "Unknown"),
        );

        if (product.title != "Unknown") {
          loadedItems.add(CartItemModel(product: product, quantity: quantity));
        }
      }

      emit(
        CartLoaded(
          items: loadedItems,
          totalPrice: _calculateTotal(loadedItems),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void addToCart(ProductModel product) async {
    final currentState = state;
    List<CartItemModel> currentItems = [];

    if (currentState is CartLoaded) {
      currentItems = List.from(currentState.items);
    }

    // Check if item exists
    final index = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      // Update quantity
      final existingItem = currentItems[index];
      currentItems[index] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Add new item
      currentItems.add(CartItemModel(product: product, quantity: 1));
    }

    // Optimistic Update
    emit(
      CartLoaded(
        items: currentItems,
        totalPrice: _calculateTotal(currentItems),
      ),
    );

    // API Sync (Fire and forget or handle error quietly)
    try {
      // Hardcoded userId 1 for demo
      await _cartRepository.addToCart(1, product.id ?? 0, 1);
    } catch (e) {
      // In a real app, we might revert state or show a snackbar.
      // For this demo, we'll keep the local state as "truth" for UI responsiveness.
      // print("API Sync failed: $e");
    }
  }

  void removeFromCart(int productId) {
    if (state is CartLoaded) {
      final currentItems = List<CartItemModel>.from(
        (state as CartLoaded).items,
      );
      currentItems.removeWhere((item) => item.product.id == productId);
      emit(
        CartLoaded(
          items: currentItems,
          totalPrice: _calculateTotal(currentItems),
        ),
      );
    }
  }

  void decreaseQuantity(int productId) {
    if (state is CartLoaded) {
      final currentItems = List<CartItemModel>.from(
        (state as CartLoaded).items,
      );
      final index = currentItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index >= 0) {
        final existingItem = currentItems[index];
        if (existingItem.quantity > 1) {
          currentItems[index] = existingItem.copyWith(
            quantity: existingItem.quantity - 1,
          );
        } else {
          currentItems.removeAt(index);
        }
        emit(
          CartLoaded(
            items: currentItems,
            totalPrice: _calculateTotal(currentItems),
          ),
        );
      }
    }
  }

  double _calculateTotal(List<CartItemModel> items) {
    double total = 0;
    for (var item in items) {
      total += (item.product.price ?? 0) * item.quantity;
    }
    return total;
  }
}
