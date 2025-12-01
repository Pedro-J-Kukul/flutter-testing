import 'package:flutter/material.dart';
import '../../models/sale.dart';
import '../../models/product.dart';
import '../../services/auth_service.dart';
import '../../services/data_repository.dart';

/// Sales form screen - Shows first in navigation for Sales
class SaleFormScreen extends StatefulWidget {
  const SaleFormScreen({super.key});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _authService = AuthService();
  final _dataRepository = DataRepository();
  
  Product? _selectedProduct;
  double _totalAmount = 0.0;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  /// Calculate total amount
  void _calculateTotal() {
    if (_selectedProduct != null && _quantityController.text.isNotEmpty) {
      final quantity = int.tryParse(_quantityController.text) ?? 0;
      setState(() {
        _totalAmount = _selectedProduct!.price * quantity;
      });
    } else {
      setState(() {
        _totalAmount = 0.0;
      });
    }
  }

  /// Handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      final quantity = int.parse(_quantityController.text);
      
      // Check if enough stock is available
      // Note: In a production system, use atomic transactions or stock reservation
      // to prevent race conditions in concurrent sales
      if (quantity > _selectedProduct!.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Insufficient stock available'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final sale = Sale(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: _selectedProduct!.id,
        productName: _selectedProduct!.name,
        quantity: quantity,
        unitPrice: _selectedProduct!.price,
        totalAmount: _totalAmount,
        date: DateTime.now(),
        cashierId: _authService.currentUser?.id ?? '',
      );

      _dataRepository.addSale(sale);

      // Clear form
      setState(() {
        _selectedProduct = null;
        _quantityController.clear();
        _totalAmount = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sale recorded successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = _dataRepository.getProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        actions: [
          // View sales list button
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.of(context).pushNamed('/sales/list'),
            tooltip: 'View Sales',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product selection
              DropdownButtonFormField<Product>(
                value: _selectedProduct,
                decoration: const InputDecoration(
                  labelText: 'Select Product',
                  border: OutlineInputBorder(),
                ),
                items: products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text('${product.name} (\$${product.price})'),
                  );
                }).toList(),
                onChanged: (product) {
                  setState(() {
                    _selectedProduct = product;
                  });
                  _calculateTotal();
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Show available stock
              if (_selectedProduct != null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Available Stock: ${_selectedProduct!.quantity} units',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              if (_selectedProduct != null) const SizedBox(height: 16),

              // Quantity field
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _calculateTotal(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  final quantity = int.tryParse(value);
                  if (quantity == null || quantity <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Total amount display
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                ),
                child: const Text('Record Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
