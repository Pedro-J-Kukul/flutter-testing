/// User model for authentication and authorization
class User {
  final String id;
  final String username;
  final String password; // In production, this should be hashed
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  /// Check if user has permission for a given action
  bool hasPermission(Permission permission) {
    switch (role) {
      case UserRole.admin:
        return true; // Admin has all permissions
      case UserRole.cashier:
        return permission == Permission.viewProducts ||
            permission == Permission.createSale ||
            permission == Permission.viewSales;
      case UserRole.guest:
        return permission == Permission.viewProducts;
    }
  }
}

/// User roles in the system
enum UserRole {
  admin,
  cashier,
  guest,
}

/// Permissions for different actions
enum Permission {
  viewProducts,
  createProduct,
  updateProduct,
  deleteProduct,
  viewSales,
  createSale,
  updateSale,
  deleteSale,
  viewUsers,
  createUser,
  updateUser,
  deleteUser,
}
