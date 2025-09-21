//
//  ProductCard.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import SwiftUI

/// A reusable card view to display a single product.
/// - Shows product thumbnail, title, price
/// - Allows marking/unmarking product as favorite
struct ProductCard: View {
    // MARK: - Properties
    
    /// The product to display.
    let product: Product
    
    /// Favorites manager used to check and toggle favorite state.
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // MARK: Product Image + Favorite Button
            ZStack(alignment: .topTrailing) {
                // Async load product thumbnail
                AsyncImage(url: URL(string: product.thumbnail)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure(_):
                        Color.gray // fallback for broken image
                    default:
                        ProgressView() // loading state
                    }
                }
                .frame(height: 120)
                .clipped()
                .cornerRadius(8)
                
                // Favorite toggle button
                Button(action: { favoritesManager.toggleFavorite(product) }) {
                    Image(systemName: favoritesManager.isFavorite(product) ? "heart.fill" : "heart")
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            // MARK: Product Title
            Text(product.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(2)
            
            // MARK: Product Price
            Text("$\(product.price, specifier: "%.2f")")
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
    }
}

// MARK: - Preview

#Preview {
    ProductCard(product: Product.preview)
        .environmentObject(FavoritesManager()) // required for preview
}
