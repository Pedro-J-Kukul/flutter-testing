# Application Architecture

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐     ┌──────────────────────────────────────┐ │
│  │ Login Screen │────>│         Home Screen                  │ │
│  └──────────────┘     │  (Role-based navigation dashboard)   │ │
│                       └──────────────────────────────────────┘ │
│                                     │                            │
│              ┌──────────────────────┼──────────────────────┐    │
│              ▼                      ▼                      ▼    │
│     ┌────────────────┐    ┌─────────────────┐   ┌──────────────┐
│     │   PRODUCTS     │    │     SALES       │   │    USERS     │
│     │                │    │                 │   │  (Admin only)│
│     │ ┌────────────┐ │    │ ┌─────────────┐ │   │┌───────────┐│
│     │ │   List     │ │    │ │    Form     │ │   ││   List    ││
│     │ │  (First)   │ │    │ │   (First)   │ │   ││  (First)  ││
│     │ └────────────┘ │    │ └─────────────┘ │   │└───────────┘│
│     │       ▼        │    │       ▼         │   │     ▼       │
│     │ ┌────────────┐ │    │ ┌─────────────┐ │   │┌───────────┐│
│     │ │   Form     │ │    │ │    List     │ │   ││   Form    ││
│     │ │ (Admin)    │ │    │ │             │ │   ││           ││
│     │ └────────────┘ │    │ └─────────────┘ │   │└───────────┘│
│     └────────────────┘    └─────────────────┘   └──────────────┘
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    ▼                         ▼
         ┌─────────────────────┐   ┌──────────────────┐
         │   BUSINESS LOGIC    │   │      ROUTING     │
         ├─────────────────────┤   ├──────────────────┤
         │                     │   │                  │
         │  ┌───────────────┐  │   │  AppRoutes       │
         │  │ AuthService   │  │   │  - Route guards  │
         │  │ - Login       │  │   │  - Permission    │
         │  │ - Logout      │  │   │    checking      │
         │  │ - Permissions │  │   │  - Navigation    │
         │  └───────────────┘  │   │                  │
         │                     │   └──────────────────┘
         │  ┌───────────────┐  │
         │  │DataRepository │  │
         │  │ - Products    │  │
         │  │ - Sales       │  │
         │  │ - Users       │  │
         │  └───────────────┘  │
         └─────────────────────┘
                    │
                    ▼
         ┌─────────────────────┐
         │    DATA MODELS      │
         ├─────────────────────┤
         │                     │
         │  ┌───────────────┐  │
         │  │   User        │  │
         │  │   - Roles     │  │
         │  │   - Perms     │  │
         │  └───────────────┘  │
         │                     │
         │  ┌───────────────┐  │
         │  │   Product     │  │
         │  └───────────────┘  │
         │                     │
         │  ┌───────────────┐  │
         │  │    Sale       │  │
         │  └───────────────┘  │
         │                     │
         └─────────────────────┘
```

## Data Flow

### Authentication Flow
```
User Input (credentials)
    │
    ▼
LoginScreen
    │
    ▼
AuthService.login()
    │
    ▼
DataRepository.getUsers()
    │
    ▼
Validate Credentials
    │
    ├─── Success ──> Set currentUser ──> Navigate to Home
    │
    └─── Failure ──> Show Error
```

### Authorization Flow
```
User navigates to route
    │
    ▼
AppRoutes.generateRoute()
    │
    ▼
Check AuthService.isAuthenticated
    │
    ├─── No ──> Redirect to Login
    │
    ▼
Check AuthService.hasPermission()
    │
    ├─── No ──> Show Unauthorized
    │
    ▼
Allow Access
```

### Sale Creation Flow
```
User selects product & quantity
    │
    ▼
SaleFormScreen validates
    │
    ▼
Check product stock availability
    │
    ├─── Insufficient ──> Show Error
    │
    ▼
Create Sale object
    │
    ▼
DataRepository.addSale()
    │
    ├─── Add to sales list
    │
    └─── Update product quantity
         (product.quantity - sale.quantity)
```

## Permission Matrix

| Action             | Admin | Cashier | Guest |
|-------------------|-------|---------|-------|
| View Products     |   ✓   |    ✓    |   ✓   |
| Create Product    |   ✓   |    ✗    |   ✗   |
| Update Product    |   ✓   |    ✗    |   ✗   |
| Delete Product    |   ✓   |    ✗    |   ✗   |
| View Sales        |   ✓   |    ✓    |   ✗   |
| Create Sale       |   ✓   |    ✓    |   ✗   |
| Update Sale       |   ✓   |    ✗    |   ✗   |
| Delete Sale       |   ✓   |    ✗    |   ✗   |
| View Users        |   ✓   |    ✗    |   ✗   |
| Create User       |   ✓   |    ✗    |   ✗   |
| Update User       |   ✓   |    ✗    |   ✗   |
| Delete User       |   ✓   |    ✗    |   ✗   |

## Component Relationships

```
main.dart
    │
    └─── MaterialApp
            │
            ├─── initialRoute: '/'
            │
            └─── onGenerateRoute: AppRoutes.generateRoute
                    │
                    └─── Route Guards (Permission Checking)
                            │
                            └─── Screen Widgets
                                    │
                                    ├─── Use AuthService (current user)
                                    │
                                    └─── Use DataRepository (CRUD)
```

## Design Patterns Used

1. **Singleton Pattern**: AuthService, DataRepository
2. **Repository Pattern**: DataRepository abstracts data access
3. **Model-View Pattern**: Clear separation of data and UI
4. **Factory Pattern**: Route generation based on permissions
5. **Strategy Pattern**: Permission-based UI rendering

## Security Layers

```
Layer 1: Route Guards
    ↓ (Block unauthorized routes)
    
Layer 2: UI Controls
    ↓ (Hide unauthorized buttons/menus)
    
Layer 3: Permission Checks
    ↓ (Verify before operations)
    
Layer 4: Data Validation
    ↓ (Validate all inputs)
```
