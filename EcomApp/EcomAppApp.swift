//
//  EcomAppApp.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import SwiftUI

@main
struct EcommerceApp: App {
    @StateObject private var productVM = ProductViewModel()
    @StateObject private var cartManager = CartManager()
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            TabView {
                ProductListView()
                    .tabItem { Label("Shop", systemImage: "cart") }

                CartView()
                    .tabItem { Label("Cart", systemImage: "bag") }

                FavoritesView()
                    .tabItem { Label("Favorites", systemImage: "heart") }
            }
            .environmentObject(productVM)
            .environmentObject(cartManager)
            .environmentObject(favoritesManager)
        }
    }
}

