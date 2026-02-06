import '../../core/constants/api_endpoints.dart';
import '../services/api_service.dart';

class CartRepository extends BaseApiService {
  // Simulate Adding to Cart API
  Future<void> addToCart(int userId, int productId, int quantity) async {
    try {
      // FakeStoreAPI requires a body with date, userId, products: [{productId, quantity}]
      final body = {
        "userId": userId,
        "date": DateTime.now().toIso8601String(),
        "products": [
          {"productId": productId, "quantity": quantity},
        ],
      };

      final response = await post(ApiEndpoints.carts, data: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success
        return;
      } else {
        throw Exception('Failed to add to cart: ${response.statusMessage}');
      }
    } catch (e) {
      // For demo purposes, we might want to suppress errors if offline or fake API behaves oddly,
      // but strictly we should rethrow.
      rethrow;
    }
  }

  // Fetch Cart for User using /carts endpoint (simulating app startup fetch of all carts)
  Future<List<Map<String, dynamic>>> getCart(int userId) async {
    try {
      // User explicitly requested to use /carts and filter
      final response = await get(ApiEndpoints.carts);
      if (response.statusCode == 200) {
        final List<dynamic> allCarts = response.data;
        if (allCarts.isEmpty) return [];

        // Filter locally for the user's cart
        // FakeStoreAPI carts objects: {id, userId, date, products: []}
        // Note: userId in API is int
        final userCarts = allCarts.where((c) => c['userId'] == userId).toList();

        if (userCarts.isEmpty) return [];

        // Return products from the latest/first user cart
        final Map<String, dynamic> latestCart = userCarts.first;
        final List<dynamic> products = latestCart['products'];
        return products.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load carts: ${response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Helper to fetch details for a list of cart items (simulating "Expand" or using ProductRepository logic)
  // For simplicity and strict separation, we'll return just the item IDs here
  // and let the Cubit coordinate fetching Product details using ProductRepository or a new method here.
}
