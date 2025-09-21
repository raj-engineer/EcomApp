//
//  ProductService.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Foundation
import Combine

/// Handles all API requests related to products.
/// Uses Combine publishers for async networking.
class ProductService: ProductServiceProtocol {
    
    /// Fetches a paginated list of products.
    /// - Parameters:
    ///   - limit: Number of products to return (default = 10)
    ///   - skip: Number of products to skip (for pagination)
    /// - Returns: A publisher that emits `ProductResponse`
    func fetchProducts(limit: Int = 10, skip: Int = 0) -> AnyPublisher<ProductResponse, Error> {
        let url = URL(string: "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Searches for products matching a query string.
    /// - Parameter query: Search term (e.g. "laptop")
    /// - Returns: A publisher that emits `ProductResponse`
    func searchProducts(query: String) -> AnyPublisher<ProductResponse, Error> {
        // Encode query for safe use in URL
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let url = URL(string: "https://dummyjson.com/products/search?q=\(encoded)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Fetches all available product categories.
    /// - Returns: A publisher that emits an array of category names.
    func fetchCategories() -> AnyPublisher<[String], Error> {
        let url = URL(string: "https://dummyjson.com/products/categories")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Fetches products belonging to a specific category.
    /// - Parameter category: Category name (e.g. "fragrances")
    /// - Returns: A publisher that emits `ProductResponse`
    func fetchProductsByCategory(_ category: String) -> AnyPublisher<ProductResponse, Error> {
        // Encode category for use in path
        let encoded = category.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? category
        let url = URL(string: "https://dummyjson.com/products/category/\(encoded)")!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

