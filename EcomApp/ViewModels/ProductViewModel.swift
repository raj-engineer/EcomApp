//
//  ProductViewModel.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import Foundation
import Combine

/// ViewModel responsible for managing products, categories,
/// search, and pagination logic.
/// Acts as a bridge between `ProductService` and SwiftUI views.
class ProductViewModel: ObservableObject {
    
    // MARK: - Published properties (UI state)
    
   
    @Published var products: [Product] = []  /// List of products displayed in UI.
    @Published var categories: [String] = [] /// All available categories.
    @Published var searchQuery = "" /// Search query entered by user.
    @Published var selectedCategory: String? = nil  /// Currently selected category (nil = "All products").
    @Published var isLoading = false  /// Flag to indicate loading state (for showing spinners).

    // MARK: - Private properties
    
    private let service: ProductServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    /// Pagination tracking
    private var skip = 0
    private let limit = 10
    private var total = 0
    
    // MARK: - Init
    /// Inject service → can be real or mock
    init(service: ProductServiceProtocol = ProductService()) {
        self.service = service
        fetchProducts(reset: true)   // initial load
        fetchCategories()            // preload categories
        setupSearch()                // set up live search
    }
    
    // MARK: - Products
    
    /// Fetches a paginated list of products.
    /// - Parameter reset: If true → reset list & start from page 0.
    func fetchProducts(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            skip = 0
            products = []
            selectedCategory = nil
        }

        service.fetchProducts(limit: limit, skip: skip)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let err) = completion {
                        print("Error fetching products: \(err)")
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    self.total = response.total
                    self.skip += self.limit   // move to next page
                    self.products.append(contentsOf: response.products)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Categories
    
    /// Fetch list of all product categories.
    func fetchCategories() {
        service.fetchCategories()
            .receive(on: DispatchQueue.main)
            .replaceError(with: []) // if error → show empty list
            .sink { [weak self] categories in
                self?.categories = categories
            }
            .store(in: &cancellables)
    }
    
    /// Fetch products for a given category.
    func fetchProductsByCategory(_ category: String) {
        guard !isLoading else { return }
        selectedCategory = category
        isLoading = true

        service.fetchProductsByCategory(category)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] response in
                    self?.products = response.products
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Search
    
    /// Set up search with debounce & deduplication.
    /// - Debounce: waits 500ms after user stops typing
    /// - RemoveDuplicates: avoids re-searching same query
    private func setupSearch() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.isEmpty {
                    self.fetchProducts(reset: true)
                } else {
                    self.searchProducts(query: query)
                }
            }
            .store(in: &cancellables)
    }

    /// Executes product search.
    private func searchProducts(query: String) {
        guard !isLoading else { return }
        isLoading = true
        
        service.searchProducts(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] response in
                    self?.products = response.products
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Helpers
    
    /// Whether more products can be loaded (pagination).
    var canLoadMore: Bool {
        products.count < total
    }
}
