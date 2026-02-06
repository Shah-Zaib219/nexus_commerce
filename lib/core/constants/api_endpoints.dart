class ApiEndpoints {
  static const String baseUrl = "https://fakestoreapi.com";

  static const String login = "/auth/login";
  static const String products = "/products";
  static const String categories = "/products/categories";
  static String productById(int id) => "/products/$id";
  static String category(String category) => "/products/category/$category";
  static const String carts = "/carts";
  static const String users = "/users";
  static String userById(int id) => "/users/$id";
}
