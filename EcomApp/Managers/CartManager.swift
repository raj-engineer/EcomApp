//
//  CartManager.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Foundation
import Combine


/// Abstract contract for managing cart items.
protocol CartManaging: ObservableObject {
    var cartItems: [CartItem] { get }
    var totalPrice: Double { get }
    var itemCount: Int { get }
    
    func addToCart(_ product: Product)
    func removeFromCart(_ product: Product)
    func clearCart()
    func clearItem(_ product: Product) // Clears a specific product
}

/// Manages all shopping cart operations including:
/// - Adding and removing products
/// - Tracking quantities
/// - Calculating total price
/// - Persisting cart items to UserDefaults
///
/// This class is marked as `ObservableObject` so it can be injected into SwiftUI views
/// and any changes automatically update the UI.
class CartManager: CartManaging {

    /// Published list of cart items.
    /// Each `CartItem` contains a `Product` and its current `quantity`.
    /// Whenever this array changes, the UI is updated and the cart is persisted.
    @Published private(set) var cartItems: [CartItem] = [] {
        didSet { save() }  // Automatically persist whenever cart changes
    }
    
    /// Storage key used in `UserDefaults` to persist cart items.
    private let key = "cartItems_v2"
    
    // MARK: - Initializer
    init() {
        load()  // Load previously saved cart items from UserDefaults
    }
    
    // MARK: - Cart Operations
    func addToCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            // Product already in cart → increase quantity
            cartItems[index].quantity += 1
        } else {
            // Product not in cart → add as new entry
            let newItem = CartItem(product: product, quantity: 1)
            cartItems.append(newItem)
        }
    }
    
    /// Removes a product from the cart.
    /// - If quantity > 1, it decreases the quantity.
    /// - If quantity == 1, the item is completely removed from the cart.
    func removeFromCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if cartItems[index].quantity > 1 {
                // More than one → decrease by 1
                cartItems[index].quantity -= 1
            } else {
                // Only one left → remove item entirely
                cartItems.remove(at: index)
            }
        }
    }
    
    /// Clears the entire cart.
    /// Typically used after a successful checkout.
    func clearCart() {
        cartItems.removeAll()
    }
    
    /// Removes a specific product completely from the cart.
    func clearItem(_ product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
    }
    
    // MARK: - Computed Properties
    
    /// Calculates the total price of all items in the cart.
    /// Uses quantity × product price for each cart item.
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    /// Calculates the total number of items (sum of all quantities).
        var itemCount: Int {
            cartItems.reduce(0) { $0 + $1.quantity }
        }
    
    // MARK: - Persistence
    
    /// Saves the current cart items to `UserDefaults` as JSON.
    private func save() {
        do {
            let data = try JSONEncoder().encode(cartItems)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to save cart: \(error)")
        }
    }
    
    /// Loads previously saved cart items from `UserDefaults`.
   
    private func load() {
           guard let data = UserDefaults.standard.data(forKey: key) else { return }
           do {
               cartItems = try JSONDecoder().decode([CartItem].self, from: data)
           } catch {
               print("Failed to load cart: \(error)")
           }
       }
}


