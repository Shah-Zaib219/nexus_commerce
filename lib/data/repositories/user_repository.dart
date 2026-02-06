import '../models/user_model.dart';
import '../../core/constants/api_endpoints.dart';
import '../services/api_service.dart';

class UserRepository extends BaseApiService {
  Future<UserModel> getUser(int id) async {
    try {
      final response = await get(ApiEndpoints.userById(id));
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
