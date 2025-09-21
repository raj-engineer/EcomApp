//
//  FavoritesView.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//
import SwiftUI

/// A view that displays all products the user has marked as favorites.
/// - Uses `FavoritesManager` to check which product IDs are favorited
/// - Uses `ProductViewModel` for the complete product list
/// - Allows navigation to product detail pages
struct FavoritesView: View {
    // MARK: - Dependencies
    
    /// Manages favorite product IDs.
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    /// Provides product data to filter favorites from.
    @EnvironmentObject var productVM: ProductViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                // Filter products to show only favorites
                let favProducts = productVM.products.filter {
                    favoritesManager.favorites.contains($0.id)
                }
                
                if favProducts.isEmpty {
                    // Empty state
                    Text("No favorites yet ❤️")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // Display grid of favorite products
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(favProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

// MARK: - Preview

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager())
        .environmentObject(ProductViewModel()) // Inject dependencies for preview
}
