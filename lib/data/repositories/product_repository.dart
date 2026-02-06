import '../../core/constants/api_endpoints.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductRepository extends BaseApiService {
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await get(ApiEndpoints.products);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await get(ApiEndpoints.productById(id));
      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
