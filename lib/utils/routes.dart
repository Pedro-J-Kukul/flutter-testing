import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/products/product_list_screen.dart';
import '../screens/products/product_form_screen.dart';
import '../screens/sales/sale_form_screen.dart';
import '../screens/sales/sale_list_screen.dart';
import '../screens/users/user_list_screen.dart';
import '../screens/users/user_form_screen.dart';
import '../models/product.dart';
import '../models/user.dart' as user_model;
import '../services/auth_service.dart';

/// App routing configuration
class AppRoutes {
  /// Route names
  static const String login = '/';
  static const String home = '/home';
  static const String products = '/products';
  static const String productForm = '/products/form';
  static const String sales = '/sales';
  static const String salesList = '/sales/list';
  static const String users = '/users';
  static const String userForm = '/users/form';

  /// Generate routes based on settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final authService = AuthService();

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case home:
        // Protected route - requires authentication
        if (!authService.isAuthenticated) {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case products:
        // All authenticated users can view products
        if (!authService.isAuthenticated) {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return MaterialPageRoute(builder: (_) => const ProductListScreen());

      case productForm:
        // Only admin can create/edit products
        if (!authService.hasPermission(user_model.Permission.createProduct) &&
            !authService.hasPermission(user_model.Permission.updateProduct)) {
          return _unauthorizedRoute();
        }
        final product = settings.arguments as Product?;
        return MaterialPageRoute(
          builder: (_) => ProductFormScreen(product: product),
        );

      case sales:
        // Admin and Cashier can access sales (form first)
        if (!authService.hasPermission(user_model.Permission.createSale)) {
          return _unauthorizedRoute();
        }
        return MaterialPageRoute(builder: (_) => const SaleFormScreen());

      case salesList:
        // Admin and Cashier can view sales list
        if (!authService.hasPermission(user_model.Permission.viewSales)) {
          return _unauthorizedRoute();
        }
        return MaterialPageRoute(builder: (_) => const SaleListScreen());

      case users:
        // Only admin can manage users
        if (!authService.hasPermission(user_model.Permission.viewUsers)) {
          return _unauthorizedRoute();
        }
        return MaterialPageRoute(builder: (_) => const UserListScreen());

      case userForm:
        // Only admin can create/edit users
        if (!authService.hasPermission(user_model.Permission.createUser) &&
            !authService.hasPermission(user_model.Permission.updateUser)) {
          return _unauthorizedRoute();
        }
        final user = settings.arguments as user_model.User?;
        return MaterialPageRoute(
          builder: (_) => UserFormScreen(user: user),
        );

      default:
        return _notFoundRoute();
    }
  }

  /// Unauthorized access route
  static Route<dynamic> _unauthorizedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Unauthorized')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'You don\'t have permission to access this page',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Not found route
  static Route<dynamic> _notFoundRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
