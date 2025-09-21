//
//  ProductListView.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import SwiftUI

/// Displays a searchable, categorized grid of products.
/// - Supports searching, filtering by category, infinite scrolling
/// - Allows navigation to product details
/// - Shows cart count in the toolbar
struct ProductListView: View {
    // MARK: - Dependencies
    
    /// Provides product data and handles fetching/filtering.
    @EnvironmentObject var viewModel: ProductViewModel
    
    /// Manages cart state.
    @EnvironmentObject var cartManager: CartManager
    
    /// Manages favorite products.
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    // MARK: - Layout
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: Search Bar
                TextField("Search products...", text: $viewModel.searchQuery)
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.top)
                
                // MARK: Categories Filter (Horizontal Scroll)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Button(action: {
                                viewModel.fetchProductsByCategory(category)
                            }) {
                                Text(category.capitalized)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        viewModel.selectedCategory == category
                                        ? Color.blue
                                        : Color.gray.opacity(0.3)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                }
                
                // MARK: Product Grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.products) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                            }
                            .onAppear {
                                // Infinite scroll: load more when last product appears
                                if product == viewModel.products.last && viewModel.canLoadMore {
                                    viewModel.fetchProducts()
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Loading indicator while fetching
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    }
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                // MARK: Cart Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CartView()) {
                        HStack(spacing: 6) {
                            Image(systemName: "bag")
                            Text("\(cartManager.cartItems.count)")
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ProductListView()
        .environmentObject(ProductViewModel(service: MockProductService())) // Mocked product source
        .environmentObject(CartManager())
        .environmentObject(FavoritesManager())
}
