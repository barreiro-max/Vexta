# Vexta — iOS Online Store
## Project Specification (Phase 1)

---

## 1. Project Overview

**App name:** Vexta  
**Platform:** iOS 17+  
**Language:** Swift 5.9+  
**UI Framework:** SwiftUI  
**Xcode:** 15+  
**Target:** Single target, logically isolated Feature Modules  
**Purpose:** A demo online store application. All integrations (Firebase, RevenueCat) are real in code structure, but RevenueCat operates in mock mode without actual transactions.

---

## 2. Technology Stack

| Category | Tool | Purpose |
|----------|------|---------|
| UI & Reactivity | SwiftUI + Observation (`@Observable`) | Declarative UI, reactive state |
| Analytics | Firebase Analytics | Event and screen tracking |
| Crash Reporting | Firebase Crashlytics | Crash monitoring, userID binding |
| Remote Config | Firebase Remote Config | A/B flags, promo banners, catalog configuration |
| Authentication | Firebase Auth | Email/Password, Google Sign-In, Apple Sign-In |
| Payments | RevenueCat SDK (mock mode) | Payment flow demo without real purchases |
| Persistence | SwiftData | Cart, wishlist, order history, catalog cache |
| Logging | OSLog | Structured logging per module |
| Notifications | UserNotifications | Order status push notifications (mock delivery) |

---

## 3. Architecture

### 3.1 Pattern Stack

```
MVI  +  Coordinator  +  Repository  +  DTO
```

### 3.2 MVI (Model–View–Intent)

```
User action
    │
    ▼
Intent (enum)
    │
    ▼  dispatch(_:)
Store (@Observable)          ◄──── Repository / Service (async)
    │  reduce(state, intent)         │
    │  → new State                   │ Domain Model
    │  → SideEffect?                 │
    ▼                                │
SwiftUI View                         │
    │  observes @Observable Store    │
    └────────────────────────────────┘
         (state drives UI)
```

- **State** — `struct`, immutable UI snapshot.
- **Intent** — `enum` of all user actions within the module.
- **Store** — `@Observable final class`. Holds `state`, exposes `dispatch(_ intent: Intent)`, launches async tasks, calls Repository.
- **SideEffect** — navigation events, emitted to Coordinator via closure or delegate.

### 3.3 Coordinator

- Each Feature has its own `FeatureCoordinator`.
- Navigation via `NavigationStack` + `@State var path: NavigationPath`.
- `AppCoordinator` owns the TabBar and child coordinators.
- Features never trigger navigation directly — only via SideEffect → Coordinator callback.

```swift
// Interaction pattern
store.onSideEffect = { [weak coordinator] effect in
    switch effect {
    case .openProductDetail(let id):
        coordinator?.push(.productDetail(id))
    case .openCheckout:
        coordinator?.present(.checkout)
    }
}
```

### 3.4 Repository Pattern

```
Feature Store
    │
    ▼
ProductRepository   (Core/Domain/Repositories/)
    │
    ├── ProductRepositoryImpl  (Core/Data/Repositories/)
    │       ├── RemoteDataSource  → NetworkService → DTO → Map → Domain
    │       └── LocalDataSource   → SwiftData → @Model → Map → Domain
    │
    └── MockProductRepository  (for Preview / Unit tests)
```

- Protocols live in `Core/Domain/`.
- Implementations live in `Core/Data/`.
- Features only know the protocol, not the implementation.

### 3.5 DTO Pattern

```
JSON Response
    │
    ▼
NetworkDTO (Codable)         ← network layer only
    │
    ▼  NetworkDTO.toDomain()
Domain Model (struct)        ← Features work only with this
    │
    ▼  DomainModel.toPersistence()
@Model Entity (SwiftData)    ← persistence layer only
```

Three separate types per entity — no leakage of the network or DB layer into the UI.

---

## 4. Project Structure (Single Target)

```
ShopKit/
├── App/
│   ├── VextaApp.swift          # @main, Firebase.configure(), DI bootstrap
│   ├── AppCoordinator.swift      # Root coordinator, TabBar
│   └── DIContainer.swift         # Dependency injection container
│   └── ContentView.swift         # Main View
│
├── Core/
│   ├── Domain/
│   │   ├── Models/               # Product, Order, CartItem, User, PurchaseResult…
│   │   ├── Repositories/         # Protocol definitions
│   │   └── UseCases/             # (optional) business rules on top of Repository
│   │
│   ├── Data/
│   │   ├── Repositories/         # Impl: cache + local + remote merge logic
│   │   └── Cache/                # Impl: InMemoryCache…, protocol definition
│   │   ├── Remote/
│   │   │   ├── RemoteDataSource.swift
│   │   │   └── RemoteDataSourceImpl.swift
│   │   │   └── DTOs/             # ProductDTO, OrderDTO…
│   │   └── Persistence/
│   │   │   └── Entities/         # SwiftData @Model: ProductEntity…
│   │   │   └── Local/            # Impl: LocalDataSourceImpl… protocol definition 
│   │   └── Network/
│   │       └── Client/           # Impl: NetworkClient…, protocol definition
│   │       └── Endpoint/
│   │
│   ├── Services/
│   │   ├── Analytics/
│   │   │   ├── AnalyticsService.swift
│   │   │   └── FirebaseAnalyticsService.swift
│   │   ├── Auth/
│   │   │   ├── AuthService.swift
│   │   │   └── FirebaseAuthService.swift
│   │   │   └── Providers/
│   │   │
│   │   │   
│   │   ├── RemoteConfig/
│   │   │   ├── RemoteConfigService.swift
│   │   │   └── FirebaseRemoteConfigService.swift
│   │   ├── Crashlytics/
│   │   │   ├── CrashlyticsService.swift
│   │   │   └── FirebaseCrashlyticsService.swift
│   │   ├── Purchase/
│   │   │   ├── PurchaseService.swift
│   │   │   ├── MockPurchaseService.swift   # ← RevenueCat mock
│   │   │   └── RevenueCatPurchaseService.swift
│   │   └── Notifications/
│   │       └── NotificationService.swift
│   │       └── UserNotificationService.swift
│   │
│   └── Common/
│       ├── Logger/               # OSLog subsystems per module
│       ├── DesignSystem/         # Colors, Typography, Components
│       └── Errors/               # AppError enum
│
└── Features/
    ├── Auth/
    │   ├── AuthCoordinator.swift
    │   ├── Login/
    │   │   ├── LoginView.swift
    │   │   └── LoginStore.swift
    │   └── Register/
    │       ├── RegisterView.swift
    │       └── RegisterStore.swift
    │
    ├── Catalog/
    │   ├── CatalogCoordinator.swift
    │   ├── ProductList/
    │   │   ├── ProductListView.swift
    │   │   └── ProductListStore.swift
    │   └── ProductDetail/
    │       ├── ProductDetailView.swift
    │       └── ProductDetailStore.swift
    │
    ├── Search/
    │   ├── SearchCoordinator.swift
    │   ├── SearchView.swift
    │   └── SearchStore.swift
    │
    ├── Cart/
    │   ├── CartCoordinator.swift
    │   ├── CartView.swift
    │   └── CartStore.swift
    │
    ├── Checkout/
    │   ├── CheckoutCoordinator.swift
    │   ├── CheckoutView.swift
    │   └── CheckoutStore.swift
    │
    ├── Wishlist/
    │   ├── WishlistCoordinator.swift
    │   ├── WishlistView.swift
    │   └── WishlistStore.swift
    │
    ├── Orders/
    │   ├── OrdersCoordinator.swift
    │   ├── OrderList/
    │   │   ├── OrderListView.swift
    │   │   └── OrderListStore.swift
    │   └── OrderDetail/
    │       ├── OrderDetailView.swift
    │       └── OrderDetailStore.swift
    │
    └── Profile/
        ├── ProfileCoordinator.swift
        ├── ProfileView.swift
        └── ProfileStore.swift
```

---

## 5. Feature Modules

Each module contains: `View`, `Store`, `Coordinator`.  
Dependencies are injected into the Coordinator via `DIContainer`.

### 5.1 AuthModule
- Firebase Auth: email/password, Google, Apple and Facebook Sign-In
- Email verification, password recovery
- `SessionManager` (@Observable, App-level) publishes `AuthState`
- On successful login emits SideEffect → AppCoordinator switches to TabBar

### 5.2 CatalogModule
- Product feed with filtering (category, price) and sorting
- Remote Config controls: promo banners, category order, new-arrival flags
- SwiftData caches the last successful response for offline use
- Analytics: `screen_view`, `select_item`, `view_item`

### 5.3 SearchModule
- Search with debounce (300ms) via `async/await` + `Task` cancellation
- Search history in SwiftData (last 20 queries)
- Analytics: `search` event with `search_term` parameter
- Results are the same `Product` Domain models as in Catalog

### 5.4 CartModule
- Cart stored in SwiftData, persistent across sessions
- Operations: add, change quantity, remove, clear
- Item counter on the tab icon via `@Observable CartStore`
- Analytics: `add_to_cart`, `remove_from_cart`

### 5.5 CheckoutModule
- Form: delivery address, payment method selection (mock)
- RevenueCat mock purchase: simulates 1.5s delay → `PurchaseResult.success`
- On successful payment: creates `Order` in SwiftData, clears cart
- UserNotifications: local push "Your order has been placed" after 2s, "Order delivered" after 10s
- Analytics: `begin_checkout`, `purchase`

### 5.6 WishlistModule
- Favourite products stored in SwiftData
- "Price drop" notification (mock): UserNotification via Remote Config flag
- Analytics: `add_to_wishlist`

### 5.7 OrdersModule
- Order history from SwiftData
- Statuses: `pending`, `processing`, `shipped`, `delivered` (mock progression)
- Order details, reorder (adds items to cart via AppCoordinator)
- OSLog: every status transition is logged with `logger.info`

### 5.8 ProfileModule
- Displays user data from Firebase Auth
- Notification settings (UserNotifications authorization)
- Theme switching (Light / Dark / System) via `AppStorage`
- Crashlytics: `Crashlytics.crashlytics().setUserID(uid)`
- Sign out: Firebase Auth sign out → AppCoordinator → AuthModule

---

## 6. Isolation Rules

> Features share a single target, but code from one Feature is **never** imported by another Feature.

| # | Rule |
|---|------|
| R1 | `Features/Catalog` contains no `import` of anything from `Features/Cart` and vice versa |
| R2 | Cross-feature interaction only via `AppCoordinator` (callback / enum Route) |
| R3 | Features receive only `Domain Models` from `Core/Domain/Models/` |
| R4 | DTOs and `@Model` Entities **do not** leave `Core/Data/` |
| R5 | Firebase SDK is imported only in `Core/Services/` and `App/`. Features work with service protocols |
| R6 | RevenueCat is imported only in `Core/Services/Purchase/RevenueCatPurchaseService.swift` |
| R7 | All logging via `OSLog`. Direct `print()` calls are forbidden |
| R8 | `DIContainer` is the sole place where dependencies (Repository and Service implementations) are created |

---

## 7. RevenueCat — Mock Strategy

Goal: demonstrate the full payment UX without real transactions.

### PurchaseServiceProtocol

```swift
protocol PurchaseServiceProtocol {
    func fetchOfferings() async throws -> [MockOffering]
    func purchase(_ offering: MockOffering) async throws -> PurchaseResult
    func restorePurchases() async throws -> PurchaseResult
}

enum PurchaseResult {
    case success(transactionID: String)
    case cancelled
    case failed(Error)
}
```

### MockPurchaseService

```swift
final class MockPurchaseService: PurchaseServiceProtocol {

    func fetchOfferings() async throws -> [MockOffering] {
        try await Task.sleep(for: .milliseconds(800))
        return MockOffering.allCases   // monthly, yearly, one-time purchase
    }

    func purchase(_ offering: MockOffering) async throws -> PurchaseResult {
        try await Task.sleep(for: .seconds(1.5))
        // 90% success, 10% random error — to demonstrate error handling
        guard Int.random(in: 0..<10) != 0 else {
            throw PurchaseError.networkError
        }
        return .success(transactionID: UUID().uuidString)
    }
}
```

### DI Switching

```swift
// DIContainer.swift
#if DEBUG
let purchaseService: PurchaseServiceProtocol = MockPurchaseService()
#else
let purchaseService: PurchaseServiceProtocol = RevenueCatPurchaseService(apiKey: Secrets.revenueCatKey)
#endif
```

### Mock Offerings

```swift
enum MockOffering: CaseIterable {
    case monthlySubscription   // $4.99/month
    case yearlySubscription    // $39.99/year
    case premiumOneTime        // $9.99 one-time Premium purchase
}
```

---

## 8. Firebase Services — Protocol Wrappers

### AnalyticsServiceProtocol

```swift
protocol AnalyticsServiceProtocol {
    func logEvent(_ name: String, parameters: [String: Any]?)
    func logScreenView(screenName: String, screenClass: String)
    func setUserProperty(_ value: String?, forName name: String)
}
```

### RemoteConfigServiceProtocol

```swift
protocol RemoteConfigServiceProtocol {
    func fetchAndActivate() async throws
    func string(forKey key: RemoteConfigKey) -> String
    func bool(forKey key: RemoteConfigKey) -> Bool
}

enum RemoteConfigKey: String {
    case promoBannerEnabled   = "promo_banner_enabled"
    case featuredCategoryIDs  = "featured_category_ids"
    case freeShippingThreshold = "free_shipping_threshold"
    case discountBadgeEnabled  = "discount_badge_enabled"
}
```

### AuthServiceProtocol

```swift
protocol AuthServiceProtocol {
    var authState: AuthState { get }
    func signIn(email: String, password: String) async throws -> User
    func signUp(email: String, password: String, displayName: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signInWithApple() async throws -> User
    func signOut() throws
    func sendPasswordReset(to email: String) async throws
}

enum AuthState {
    case unknown
    case authenticated(User)
    case unauthenticated
}
```

---

## 9. Logging Strategy (OSLog)

```swift
// Core/Common/Logger/AppLogger.swift
import OSLog

extension Logger {
    private static let subsystem = Bundle.main.bundleIdentifier!

    static let auth     = Logger(subsystem: subsystem, category: "Auth")
    static let catalog  = Logger(subsystem: subsystem, category: "Catalog")
    static let cart     = Logger(subsystem: subsystem, category: "Cart")
    static let checkout = Logger(subsystem: subsystem, category: "Checkout")
    static let orders   = Logger(subsystem: subsystem, category: "Orders")
    static let network  = Logger(subsystem: subsystem, category: "Network")
    static let purchase = Logger(subsystem: subsystem, category: "Purchase")
    static let storage  = Logger(subsystem: subsystem, category: "Storage")
}

// Usage in Store:
Logger.catalog.info("Products fetched: \(products.count)")
Logger.cart.error("Failed to add item: \(error.localizedDescription)")
```

---

## 10. SwiftData Models

```swift
// Core/Data/Local/Entities/

@Model final class CartItemEntity {
    var id: String
    var productID: String
    var productTitle: String
    var productImageURL: String
    var price: Double
    var quantity: Int
    var addedAt: Date

    init(...) { ... }
}

@Model final class WishlistItemEntity {
    var id: String
    var productID: String
    var productTitle: String
    var productImageURL: String
    var price: Double
    var addedAt: Date
}

@Model final class OrderEntity {
    var id: String
    var createdAt: Date
    var status: String          // OrderStatus.rawValue
    var totalAmount: Double
    var itemsData: Data         // JSON-encoded [OrderItemSnapshot]
    var deliveryAddress: String
    var transactionID: String?
}

@Model final class SearchHistoryEntity {
    var query: String
    var searchedAt: Date
}

@Model final class CachedProductEntity {
    var id: String
    var data: Data              // JSON-encoded ProductDTO
    var cachedAt: Date
    var categoryID: String
}
```

---

## 11. Navigation Structure

```
AppCoordinator
│
├── AuthCoordinator (if not authenticated)
│   ├── LoginView
│   └── RegisterView
│
└── TabBarCoordinator (if authenticated)
    ├── Tab 0: CatalogCoordinator
    │   ├── ProductListView
    │   └── ProductDetailView
    │       └── (sheet) ReviewsView
    │
    ├── Tab 1: SearchCoordinator
    │   └── SearchView
    │       └── ProductDetailView (shared route)
    │
    ├── Tab 2: CartCoordinator
    │   └── CartView
    │       └── (push) CheckoutCoordinator
    │           └── CheckoutView
    │               └── (sheet) PaymentMethodView
    │
    ├── Tab 3: WishlistCoordinator
    │   └── WishlistView
    │
    └── Tab 4: ProfileCoordinator
        ├── ProfileView
        ├── OrdersCoordinator
        │   ├── OrderListView
        │   └── OrderDetailView
        └── (sheet) NotificationSettingsView
```

---

## 12. Analytics Events

| Event Name | Module | Parameters |
|------------|--------|------------|
| `screen_view` | all | `screen_name`, `screen_class` |
| `login` | Auth | `method` (email/google/apple) |
| `sign_up` | Auth | `method` |
| `search` | Search | `search_term` |
| `select_item` | Catalog | `item_id`, `item_name`, `item_category` |
| `view_item` | Catalog | `item_id`, `item_name`, `price` |
| `add_to_cart` | Cart | `item_id`, `item_name`, `price`, `quantity` |
| `remove_from_cart` | Cart | `item_id`, `quantity` |
| `add_to_wishlist` | Wishlist | `item_id`, `item_name` |
| `begin_checkout` | Checkout | `value`, `currency`, `num_items` |
| `purchase` | Checkout | `transaction_id`, `value`, `currency` |
| `view_order` | Orders | `order_id`, `order_status` |

---

## 13. SDLC Phases

| Phase | Content | Status |
|-------|---------|--------|
| **Phase 1 — Specification** | Architecture, contracts, structure, data flow | ✅ Done |
| **Phase 2 — Core Layer** | Domain Models, Repository protocols, DI Container, Service wrappers | ⬜ Next |
| **Phase 3 — Auth + Navigation** | Firebase Auth, AppCoordinator, TabBar, SessionManager | ⬜ |
| **Phase 4 — Catalog + Search + Cart** | Remote Config, SwiftData cache, Analytics, Search debounce | ⬜ |
| **Phase 5 — Checkout + RevenueCat** | Mock purchase flow, UserNotifications, Order creation | ⬜ |
| **Phase 6 — Wishlist + Profile + QA** | Crashlytics, OSLog audit, UI polish, Preview coverage | ⬜ |

---

## 14. Key Conventions

- All public types in `Core/` use `internal` (default) — no `public`, no `open`
- `Store` is always `@MainActor final class`
- `@Observable` instead of `ObservableObject` / `@Published` everywhere
- Async/await for all asynchronous operations, no Combine chains
- `Task` in Store is created via `Task { @MainActor in ... }` and cancelled in `deinit`
- All UI strings are localizable via `String(localized:)`, keys in `Localizable.xcstrings`
- SwiftData `ModelContainer` is created once in `App/`, passed via `.modelContainer()`
- `DIContainer` is a `struct` that creates dependencies lazily
- Previews use `MockRepository` and `MockPurchaseService` — no Firebase in Previews

## 15. Rules of change in Specification.md

- If we update SDLC Phases, each completed development phase gets exactly 1 commit of the form:

```
// Example
[Specification] Complete phase 1 - Specification
```

- **Changes are allowed** 

## 16. Data Layer Policy 

In the repository, the dependencies are: cache, local data source, and remote data source.

For fetch, fetchAll: first, we request information from the cache. If it fails, we request it from the local data source and also save it to the cache. However, if it is not found in the local data source either, we make a request to the remote data source and save it first to the local data source, and then to the cache.

For save, saveAll: first, we save to the cache, then to the local data source.
 
### 16.1 TTL — Time-To-Live 

The algorithm must take into account the data expiration policy. Therefore, if we request data from the cache and it is fresh, we return it. Otherwise, we make a request to the local DB and also check if the data is up-to-date; if it is not, we make a request to the network.

## 17. Model ID Synchronization Policy

A DTO model comes from the server with a built-in server identifier, which is assumed to be unique. This exact identifier will be passed to the Domain & Entity models, meaning the **single source of truth is the DTO ID.**
