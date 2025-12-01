import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

/// Home screen with role-based navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    if (user == null) {
      // If not authenticated, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('UB Sales Tracker'),
        actions: [
          // User role badge
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Chip(
                label: Text(
                  user.role.name.toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: _getRoleColor(user.role),
              ),
            ),
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          // Products - All roles can view
          _buildNavigationCard(
            context,
            title: 'Products',
            icon: Icons.inventory,
            route: '/products',
            color: Colors.blue,
          ),

          // Sales - Admin and Cashier can access
          if (authService.hasPermission(Permission.viewSales))
            _buildNavigationCard(
              context,
              title: 'Sales',
              icon: Icons.point_of_sale,
              route: '/sales',
              color: Colors.green,
            ),

          // Users - Admin only
          if (authService.hasPermission(Permission.viewUsers))
            _buildNavigationCard(
              context,
              title: 'Users',
              icon: Icons.people,
              route: '/users',
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  /// Build a navigation card
  Widget _buildNavigationCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  /// Get color based on user role
  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red.shade100;
      case UserRole.cashier:
        return Colors.blue.shade100;
      case UserRole.guest:
        return Colors.grey.shade300;
    }
  }

  /// Handle logout
  void _handleLogout(BuildContext context) {
    AuthService().logout();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
