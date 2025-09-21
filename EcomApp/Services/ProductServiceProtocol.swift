//
//  ProductServiceProtocol.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//
import Combine
/// Abstract contract for fetching products and categories.
/// Allows swapping real API service with a mock service in tests/previews.
protocol ProductServiceProtocol {
    func fetchProducts(limit: Int, skip: Int) -> AnyPublisher<ProductResponse, Error>
    func searchProducts(query: String) -> AnyPublisher<ProductResponse, Error>
    func fetchCategories() -> AnyPublisher<[String], Error>
    func fetchProductsByCategory(_ category: String) -> AnyPublisher<ProductResponse, Error>
}
