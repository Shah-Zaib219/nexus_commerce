import 'package:flutter/material.dart';

import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/signup_screen.dart';
import '../../presentation/screens/category_products_screen.dart';
import '../../presentation/screens/product_detail_screen.dart';
import '../../presentation/screens/dashboard_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case AppRoutes.categoryProducts:
        final categoryName = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CategoryProductsScreen(categoryName: categoryName),
        );
      case AppRoutes.productDetail:
        final productId = settings.arguments as int;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
