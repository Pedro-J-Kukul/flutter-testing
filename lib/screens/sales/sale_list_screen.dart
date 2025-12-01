import 'package:flutter/material.dart';
import '../../models/sale.dart';
import '../../services/auth_service.dart';
import '../../services/data_repository.dart';
import '../../models/user.dart';

/// Sales list screen
class SaleListScreen extends StatefulWidget {
  const SaleListScreen({super.key});

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  final _authService = AuthService();
  final _dataRepository = DataRepository();

  @override
  Widget build(BuildContext context) {
    final sales = _dataRepository.getSales();
    final canDelete = _authService.hasPermission(Permission.deleteSale);

    // Calculate total sales
    final totalSales = sales.fold<double>(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
      ),
      body: Column(
        children: [
          // Total sales card
          Card(
            margin: const EdgeInsets.all(16.0),
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Sales',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '\$${totalSales.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Sales list
          Expanded(
            child: sales.isEmpty
                ? const Center(child: Text('No sales recorded yet'))
                : ListView.builder(
                    itemCount: sales.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      final sale = sales[sales.length - 1 - index]; // Reverse order
                      return _buildSaleCard(context, sale, canDelete);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.add),
        tooltip: 'New Sale',
      ),
    );
  }

  /// Build sale card
  Widget _buildSaleCard(BuildContext context, Sale sale, bool canDelete) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: const Icon(Icons.point_of_sale, color: Colors.white),
        ),
        title: Text(sale.productName),
        subtitle: Text(
          'Qty: ${sale.quantity} × \$${sale.unitPrice.toStringAsFixed(2)}\n'
          '${_formatDate(sale.date)}',
        ),
        isThreeLine: true,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${sale.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
            ),
            if (canDelete)
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () => _confirmDelete(context, sale),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Confirm delete dialog
  void _confirmDelete(BuildContext context, Sale sale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text('Are you sure you want to delete this sale?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _dataRepository.deleteSale(sale.id);
              Navigator.of(context).pop();
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sale deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
