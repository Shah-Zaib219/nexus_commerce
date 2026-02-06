import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/product_repository.dart';
import 'logic/product_cubit/product_cubit.dart';
import 'data/repositories/auth_repository.dart';
import 'logic/auth_cubit/auth_cubit.dart';
import 'logic/theme_cubit/theme_cubit.dart';
import 'data/repositories/cart_repository.dart';
import 'logic/cart_cubit/cart_cubit.dart';
import 'data/repositories/user_repository.dart';
import 'logic/user_cubit/user_cubit.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const NexusCommerceApp());
}

class NexusCommerceApp extends StatelessWidget {
  const NexusCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection for Repositories
    final productRepository = ProductRepository();
    final authRepository = AuthRepository();
    final cartRepository = CartRepository();
    final userRepository = UserRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
        RepositoryProvider<UserRepository>.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(authRepository),
          ),
          BlocProvider<ProductCubit>(
            create: (context) => ProductCubit(productRepository),
          ),
          BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
          BlocProvider<CartCubit>(
            create: (context) =>
                CartCubit(cartRepository, productRepository)..loadCart(1),
          ),
          BlocProvider<UserCubit>(
            create: (context) => UserCubit(userRepository),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Nexus Commerce',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              initialRoute: AppRoutes.splash,
              onGenerateRoute: AppRouter.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }
}
