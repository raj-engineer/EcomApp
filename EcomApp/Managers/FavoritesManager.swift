//
//  FavoritesManager.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Foundation
import Combine


/// Abstract contract for managing favorite products.
protocol FavoritesManaging: ObservableObject {
    var favorites: Set<Int> { get }
    func toggleFavorite(_ product: Product)
    func isFavorite(_ product: Product) -> Bool
}

/// Manages user's favorite products.
/// Stores product IDs in a `Set` to avoid duplicates.
/// Persists favorites in UserDefaults.

class FavoritesManager: FavoritesManaging {
    
    /// Stores IDs of favorited products.
    /// Using `Set` ensures each product can only appear once.
    @Published private(set) var favorites: Set<Int> = [] {
        didSet { save() }  // persist whenever favorites change
    }
    
    private let key = "favoriteProducts_v1"
    
    init() {
        load()
    }
    
    /// Add or remove product from favorites.
    /// - If product is already favorited → remove it
    /// - Else → add it
    func toggleFavorite(_ product: Product) {
        if favorites.contains(product.id) { favorites.remove(product.id) }
        else { favorites.insert(product.id) }
    }
    
    /// Check whether a product is marked as favorite.
    func isFavorite(_ product: Product) -> Bool {
        favorites.contains(product.id)
    }
    
    // MARK: - Persistence
    
    /// Save favorites to UserDefaults as an array of Int IDs.
    private func save() {
        let array = Array(favorites)
        UserDefaults.standard.set(array, forKey: key)
    }
    /// Load favorites from UserDefaults (array of Int IDs → Set<Int>).
    private func load() {
        if let array = UserDefaults.standard.array(forKey: key) as? [Int] {
            favorites = Set(array)
        }
    }
}
