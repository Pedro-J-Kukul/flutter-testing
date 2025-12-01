import '../models/user.dart';

/// Authentication service for managing user login and current session
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  User? _currentUser;

  /// Get the currently logged-in user
  User? get currentUser => _currentUser;

  /// Check if a user is currently logged in
  bool get isAuthenticated => _currentUser != null;

  /// Login with username and password
  bool login(String username, String password, List<User> users) {
    try {
      final user = users.firstWhere(
        (u) => u.username == username && u.password == password,
      );
      _currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Logout the current user
  void logout() {
    _currentUser = null;
  }

  /// Check if current user has a specific permission
  bool hasPermission(Permission permission) {
    return _currentUser?.hasPermission(permission) ?? false;
  }

  /// Check if current user has a specific role
  bool hasRole(UserRole role) {
    return _currentUser?.role == role;
  }
}
