# Quick Reference Guide

## Getting Started

### 1. Running the Application

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 2. Login Credentials

| Role    | Username | Password    | Permissions                           |
|---------|----------|-------------|---------------------------------------|
| Admin   | admin    | admin123    | Full CRUD on all resources            |
| Cashier | cashier  | cashier123  | Create/view sales, view products      |
| Guest   | guest    | guest123    | View products only                    |

## Navigation Flow

```
Login Screen (/)
    ↓
Home Screen (/home)
    ↓
    ├─→ Products (/products) → All users can access
    │   └─→ Add/Edit (/products/form) → Admin only
    │
    ├─→ Sales (/sales) → Admin & Cashier only
    │   └─→ View History (/sales/list) → Admin & Cashier
    │
    └─→ Users (/users) → Admin only
        └─→ Add/Edit (/users/form) → Admin only
```

## File Locations

### Need to modify authentication logic?
→ `lib/services/auth_service.dart`

### Need to change data storage?
→ `lib/services/data_repository.dart`

### Need to modify a screen?
→ `lib/screens/[module]/[screen]_screen.dart`

### Need to add/modify routes?
→ `lib/utils/routes.dart`

### Need to modify data models?
→ `lib/models/[model].dart`

## Common Tasks

### Add a New User Role

1. Add role to enum in `lib/models/user.dart`:
   ```dart
   enum UserRole {
     admin,
     cashier,
     guest,
     newRole, // Add here
   }
   ```

2. Update `hasPermission()` method in `User` class

3. Update route guards in `lib/utils/routes.dart`

4. Update UI logic in screens

### Add a New Permission

1. Add to Permission enum in `lib/models/user.dart`:
   ```dart
   enum Permission {
     // ... existing permissions
     newPermission,
   }
   ```

2. Update `hasPermission()` method for each role

3. Add route guards or UI checks as needed

### Add a New Screen

1. Create screen file in appropriate folder:
   ```
   lib/screens/[module]/new_screen.dart
   ```

2. Add route in `lib/utils/routes.dart`:
   ```dart
   static const String newScreen = '/new-screen';
   ```

3. Add case in `generateRoute()` method

4. Add navigation button/link in appropriate screen

### Modify Sample Data

Edit `_initializeSampleData()` in `lib/services/data_repository.dart`

## Key Classes

### AuthService (Singleton)
- `login()` - Authenticate user
- `logout()` - Clear session
- `hasPermission()` - Check permission
- `hasRole()` - Check role
- `currentUser` - Get current user

### DataRepository (Singleton)
- `getProducts()` - Get all products
- `addProduct()` - Create product
- `updateProduct()` - Update product
- `deleteProduct()` - Delete product
- Similar methods for Sales and Users

### User Model
```dart
User(
  id: String,
  username: String,
  password: String,
  role: UserRole,
)
```

### Product Model
```dart
Product(
  id: String,
  name: String,
  description: String,
  price: double,
  quantity: int,
)
```

### Sale Model
```dart
Sale(
  id: String,
  productId: String,
  productName: String,
  quantity: int,
  unitPrice: double,
  totalAmount: double,
  date: DateTime,
  cashierId: String,
)
```

## Debugging Tips

### User can't access a screen
1. Check if user is logged in
2. Verify user role has required permission
3. Check route guard in `routes.dart`

### Data not persisting
- Current implementation uses in-memory storage
- Data resets on app restart
- For persistence, integrate a database

### Build errors
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

## Security Notes

⚠️ **For Production:**

1. **Password Security**: Hash passwords using bcrypt or similar
   ```dart
   // Current: Storing plain text (NOT production-ready)
   password: 'admin123'
   
   // Production: Hash passwords
   password: hashPassword('admin123')
   ```

2. **Data Storage**: Replace in-memory storage with secure database

3. **Authentication**: Implement JWT or OAuth

4. **API Integration**: Connect to secure backend API

5. **Input Validation**: Already implemented, but review for edge cases

6. **HTTPS**: Ensure all network calls use HTTPS

## Testing Checklist

- [ ] Login with each role (Admin, Cashier, Guest)
- [ ] Verify Admin can CRUD all resources
- [ ] Verify Cashier can only create/view sales and view products
- [ ] Verify Guest can only view products
- [ ] Try accessing restricted routes with wrong role
- [ ] Test form validation on all forms
- [ ] Test sale creation reduces product stock
- [ ] Test sale deletion restores product stock
- [ ] Logout and verify session cleared

## Architecture Summary

```
Models (Data) ← Services (Logic) ← Screens (UI)
                      ↑
                   Routes (Navigation + Guards)
```

## Contact & Support

For questions or issues:
1. Check documentation files (README.md, IMPLEMENTATION.md)
2. Review architecture diagrams (ARCHITECTURE.md)
3. Check code comments in source files

---

**Version:** 1.0.0  
**Last Updated:** 2025-12-01  
**Flutter Version:** 3.9.2+
