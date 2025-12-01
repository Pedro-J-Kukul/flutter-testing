# UB Student Club Sales Tracker

A mobile sales application for the University of Belize student club to track their sales activities.

## Features

### Role-Based Access Control

The application implements three user roles with different permissions:

#### Admin
- Full CRUD (Create, Read, Update, Delete) operations for:
  - Products
  - Sales
  - Users
- Access to all screens and features

#### Cashier
- Can create and view sales
- Can view products
- Limited access to sales and product screens

#### Guest
- Can only view products
- Read-only access

### Application Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   ├── product.dart          # Product model
│   ├── sale.dart             # Sale model
│   └── user.dart             # User model with permissions
├── screens/                  # UI screens organized by feature
│   ├── auth/
│   │   └── login_screen.dart # Login screen (landing page)
│   ├── home_screen.dart      # Home screen with role-based navigation
│   ├── products/
│   │   ├── product_list_screen.dart  # Product list (shown first)
│   │   └── product_form_screen.dart  # Product form
│   ├── sales/
│   │   ├── sale_form_screen.dart     # Sale form (shown first)
│   │   └── sale_list_screen.dart     # Sales history
│   └── users/
│       ├── user_list_screen.dart     # User list (Admin only)
│       └── user_form_screen.dart     # User form (Admin only)
├── services/                 # Business logic
│   ├── auth_service.dart     # Authentication service
│   └── data_repository.dart  # In-memory data repository
└── utils/                    # Utilities
    └── routes.dart           # App routing with role-based guards
```

### Navigation Flow

1. **Landing Page**: Login screen with authentication
2. **Home Screen**: Role-based dashboard showing available modules
3. **Products**: List shown first → Form for creating/editing (Admin only)
4. **Sales**: Form shown first → List for viewing history
5. **Users**: List shown first → Form for creating/editing (Admin only)

### Demo Credentials

- **Admin**: username: `admin`, password: `admin123`
- **Cashier**: username: `cashier`, password: `cashier123`
- **Guest**: username: `guest`, password: `guest123`

## Security Features

- Role-based authentication
- Permission checking at route level
- Protected screens with unauthorized access handling
- Role-specific UI elements (buttons, menus)

## Code Quality

- Well-organized folder structure
- Clear separation of concerns
- Comprehensive comments
- Follows Flutter best practices
- Type-safe data models
- Form validation
- Error handling

## Running the Application

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Notes

- The current implementation uses in-memory data storage
- For production, integrate with a backend API and database
- Passwords should be properly hashed in production
- Consider adding state management (Provider, Riverpod, or Bloc)
