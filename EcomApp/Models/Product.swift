//
//  Product.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Foundation
/// Represents a product in the e-commerce app.
/// This model comes from the DummyJSON API.
///
/// Conforms to:
/// - `Identifiable` → so it can be uniquely displayed in SwiftUI lists
/// - `Codable` → so it can be decoded directly from API responses
struct ProductResponse: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

struct Product: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let thumbnail: String
    let images: [String]
    let category: String
}

// Preview helper for SwiftUI
extension Product {
    static let preview = Product(
        id: 0,
        title: "Preview Product",
        price: 49.99,
        description: "Sample product for SwiftUI previews.",
        thumbnail: "https://via.placeholder.com/150",
        images: [],
        category: "Preview"
    )
}

