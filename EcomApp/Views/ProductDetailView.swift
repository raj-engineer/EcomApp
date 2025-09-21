//
//  ProductDetailView.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import SwiftUI

/// A detailed view that shows information about a selected product.
/// - Displays product image, title, price, and description
/// - Allows user to add product to cart
/// - Allows user to favorite/unfavorite the product
struct ProductDetailView: View {
    // MARK: - Properties
    
    /// The product being displayed in detail.
    let product: Product
    
    /// Manages cart actions like adding items.
    @EnvironmentObject var cartManager: CartManager
    
    /// Manages favorite products.
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: Product Image
                AsyncImage(url: URL(string: product.thumbnail)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure(_):
                        Color.gray // fallback for failed image
                    default:
                        ProgressView() // loading state
                    }
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                
                // MARK: Title + Favorite Button
                HStack(spacing: 12) {
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Favorite toggle button
                    Button(action: { favoritesManager.toggleFavorite(product) }) {
                        Image(systemName: favoritesManager.isFavorite(product) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                // MARK: Price
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.title3)
                    .foregroundColor(.green)
                    .padding(.horizontal)
                
                // MARK: Description
                Text(product.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                // MARK: Add to Cart Button
                Button(action: { cartManager.addToCart(product) }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    ProductDetailView(product: Product.preview)
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
}
