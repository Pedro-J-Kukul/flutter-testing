import '../models/product.dart';
import '../models/sale.dart';
import '../models/user.dart';

/// In-memory data repository for managing app data
/// In production, this would connect to a database
class DataRepository {
  static final DataRepository _instance = DataRepository._internal();
  factory DataRepository() => _instance;
  DataRepository._internal() {
    _initializeSampleData();
  }

  final List<User> _users = [];
  final List<Product> _products = [];
  final List<Sale> _sales = [];

  /// Initialize sample data for testing
  void _initializeSampleData() {
    // Sample users
    _users.addAll([
      User(
        id: '1',
        username: 'admin',
        password: 'admin123',
        role: UserRole.admin,
      ),
      User(
        id: '2',
        username: 'cashier',
        password: 'cashier123',
        role: UserRole.cashier,
      ),
      User(
        id: '3',
        username: 'guest',
        password: 'guest123',
        role: UserRole.guest,
      ),
    ]);

    // Sample products
    _products.addAll([
      Product(
        id: '1',
        name: 'UB T-Shirt',
        description: 'Official University of Belize t-shirt',
        price: 25.00,
        quantity: 50,
      ),
      Product(
        id: '2',
        name: 'UB Cap',
        description: 'University of Belize baseball cap',
        price: 15.00,
        quantity: 30,
      ),
      Product(
        id: '3',
        name: 'UB Notebook',
        description: 'Spiral notebook with UB logo',
        price: 8.00,
        quantity: 100,
      ),
    ]);

    // Sample sales
    _sales.add(
      Sale(
        id: '1',
        productId: '1',
        productName: 'UB T-Shirt',
        quantity: 2,
        unitPrice: 25.00,
        totalAmount: 50.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        cashierId: '2',
      ),
    );
  }

  // User operations
  List<User> getUsers() => List.unmodifiable(_users);
  
  void addUser(User user) {
    _users.add(user);
  }

  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = user;
    }
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
  }

  // Product operations
  List<Product> getProducts() => List.unmodifiable(_products);

  void addProduct(Product product) {
    _products.add(product);
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Sale operations
  List<Sale> getSales() => List.unmodifiable(_sales);

  void addSale(Sale sale) {
    _sales.add(sale);
    // Update product quantity
    final product = getProductById(sale.productId);
    if (product != null) {
      updateProduct(product.copyWith(
        quantity: product.quantity - sale.quantity,
      ));
    }
  }

  void updateSale(Sale sale) {
    final index = _sales.indexWhere((s) => s.id == sale.id);
    if (index != -1) {
      _sales[index] = sale;
    }
  }

  void deleteSale(String id) {
    _sales.removeWhere((s) => s.id == id);
  }
}
