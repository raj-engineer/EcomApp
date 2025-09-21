//
//  CartItem.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//
import SwiftUI

struct CartItem: Identifiable, Codable {
    let id: UUID
    let product: Product
    var quantity: Int
    
    init(product: Product, quantity: Int) {
        self.id = UUID()
        self.product = product
        self.quantity = quantity
    }
}

