import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/data_repository.dart';

/// User form screen for creating/editing users
class UserFormScreen extends StatefulWidget {
  final User? user;

  const UserFormScreen({super.key, this.user});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dataRepository = DataRepository();
  
  UserRole _selectedRole = UserRole.guest;

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _usernameController.text = widget.user!.username;
      _passwordController.text = widget.user!.password;
      _selectedRole = widget.user!.role;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Handle form submission
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        id: widget.user?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        username: _usernameController.text,
        password: _passwordController.text,
        role: _selectedRole,
      );

      if (widget.user == null) {
        _dataRepository.addUser(user);
      } else {
        _dataRepository.updateUser(user);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.user == null
                ? 'User created successfully'
                : 'User updated successfully',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Role selection
              DropdownButtonFormField<UserRole>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.admin_panel_settings),
                ),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (role) {
                  if (role != null) {
                    setState(() {
                      _selectedRole = role;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Role permissions info
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Role Permissions',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(_getRoleDescription()),
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
                ),
                child: Text(
                  widget.user == null ? 'Create User' : 'Update User',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get role description
  String _getRoleDescription() {
    switch (_selectedRole) {
      case UserRole.admin:
        return 'Full access: Can create, view, update, and delete products, sales, and users.';
      case UserRole.cashier:
        return 'Limited access: Can create and view sales, view products.';
      case UserRole.guest:
        return 'View only: Can only view products.';
    }
  }
}
