import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/auth_service.dart';
import '../../services/data_repository.dart';
import '../../models/user.dart';

/// Product list screen - Shows first in navigation
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _authService = AuthService();
  final _dataRepository = DataRepository();

  @override
  Widget build(BuildContext context) {
    final products = _dataRepository.getProducts();
    final canCreate = _authService.hasPermission(Permission.createProduct);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('No products available'),
            )
          : ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.all(8.0),
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product);
              },
            ),
      // Add button only for Admin
      floatingActionButton: canCreate
          ? FloatingActionButton(
              onPressed: () => _navigateToForm(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Build product card
  Widget _buildProductCard(BuildContext context, Product product) {
    final canEdit = _authService.hasPermission(Permission.updateProduct);
    final canDelete = _authService.hasPermission(Permission.deleteProduct);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            product.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(product.name),
        subtitle: Text(
          '${product.description}\nPrice: \$${product.price.toStringAsFixed(2)} | Stock: ${product.quantity}',
        ),
        isThreeLine: true,
        trailing: (canEdit || canDelete)
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToForm(context, product: product);
                  } else if (value == 'delete') {
                    _confirmDelete(context, product);
                  }
                },
                itemBuilder: (context) => [
                  if (canEdit)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Edit'),
                    ),
                  if (canDelete)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete'),
                    ),
                ],
              )
            : null,
      ),
    );
  }

  /// Navigate to product form
  void _navigateToForm(BuildContext context, {Product? product}) {
    Navigator.of(context)
        .pushNamed('/products/form', arguments: product)
        .then((_) => setState(() {}));
  }

  /// Confirm delete dialog
  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _dataRepository.deleteProduct(product.id);
              Navigator.of(context).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
