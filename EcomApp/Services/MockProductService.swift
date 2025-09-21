//
//  MockProductService.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Combine

/// Mock implementation of ProductServiceProtocol for testing & previews.
/// You can inject MockProductService in SwiftUI previews or unit tests.
class MockProductService: ProductServiceProtocol {
    func fetchProducts(limit: Int, skip: Int) -> AnyPublisher<ProductResponse, Error> {
        let dummy = ProductResponse(products: [.preview], total: 1, skip: 0, limit: 10)
        return Just(dummy)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func searchProducts(query: String) -> AnyPublisher<ProductResponse, Error> {
        fetchProducts(limit: 10, skip: 0)
    }

    func fetchCategories() -> AnyPublisher<[String], Error> {
        Just(["Electronics", "Clothes", "Shoes"])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchProductsByCategory(_ category: String) -> AnyPublisher<ProductResponse, Error> {
        fetchProducts(limit: 10, skip: 0)
    }
}
