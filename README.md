
## 🛒 App Description

This is a **shopping app template** built with **SwiftUI + Combine**.
It provides a clean, modular, and reusable foundation for an e-commerce experience.

<img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/ProductList.png" alt="App Screenshot" width="200" height="400"/>       <img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/ProductDetail.png" alt="App Screenshot" width="200" height="400"/>
<img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/Cart.png" alt="App Screenshot" width="200" height="400"/>       <img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/Checkout.png" alt="App Screenshot" width="200" height="400"/>
<img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/OrderConfirmed.png" alt="App Screenshot" width="200" height="400"/>       <img src = "https://raw.githubusercontent.com/raj-engineer/EcomApp/refs/heads/main/EcomApp/Screenshots/Favourites.png" alt="App Screenshot" width="200" height="400"/>

### ✨ Key Features

* **Product Browsing**

  * Browse products in a grid layout.
  * Infinite scrolling with lazy loading.
  * Search bar to quickly find products.
  * Category filters with horizontal scroll.

* **Product Details**

  * Detailed product page with images, description, and pricing.
  * Ability to mark/unmark as favorite.
  * Add items directly to the cart.

* **Cart Management**

  * View all items in your cart.
  * Update item quantities with a stepper.
  * Remove items or clear the entire cart.
  * Displays total price dynamically.

* **Checkout Flow**

  * Enter delivery address.
  * Select payment method (Credit/Debit/UPI/COD).
  * Place an order with confirmation alert.
  * Automatically clears cart after order placement.

* **Favorites**

  * Save favorite products for quick access.
  * Favorites persist using `UserDefaults`.

* **Reusable Components**

  * `ProductCard` for displaying products consistently.
  * `FavoritesManager` and `CartManager` for state management.
  * Protocol-oriented services (`ProductServiceProtocol`, `MockProductService`) for testability and scalability.

---

### 🏗️ Tech Stack

* **SwiftUI** → UI framework
* **Combine** → Data binding & reactive updates
* **UserDefaults** → Local persistence for favorites
* **Protocol-Oriented Design** → Easy to swap services (e.g., mock vs real API)
* **EnvironmentObject** → Shared state across views (cart, favorites, products)

