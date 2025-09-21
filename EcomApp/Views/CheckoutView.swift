//
//  CheckoutView.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//

import SwiftUI

/// A view that handles the checkout flow:
/// - Lets the user enter a delivery address
/// - Choose a payment method
/// - Place an order (dummy action)
/// - Clears the cart and shows a confirmation
///
/// This view depends on `CartManager` injected via `@EnvironmentObject`.
struct CheckoutView: View {
    // MARK: - Dependencies
    
    /// Shared cart manager to clear cart after successful order.
    @EnvironmentObject var cartManager: CartManager
    
    /// Environment dismiss action to close the view.
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State
    
    /// User’s entered delivery address.
    @State private var address = ""
    
    /// Selected payment method. Defaults to "Credit Card".
    @State private var paymentMethod = "Credit Card"
    
    /// Controls display of order confirmation alert.
    @State private var showConfirmation = false
    
    /// Available payment options for the picker.
    let paymentOptions = ["Credit Card", "Debit Card", "UPI", "Cash on Delivery"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            Form {
                // Delivery address input
                Section(header: Text("Delivery Address")) {
                    TextField("Enter your address", text: $address)
                }
                
                // Payment method selection
                Section(header: Text("Payment Method")) {
                    Picker("Select", selection: $paymentMethod) {
                        ForEach(paymentOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                // Place order button
                Section {
                    Button(action: placeOrder) {
                        Text("Place Order")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(address.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(8)
                    }
                    .disabled(address.isEmpty) // disable until address is filled
                }
            }
            .navigationTitle("Checkout")
            
            // Close button in toolbar
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            
            // Confirmation alert after placing order
            .alert("Order Confirmed 🎉", isPresented: $showConfirmation) {
                Button("OK") { dismiss() }
            } message: {
                Text("Your order will be delivered soon.")
            }
        }
    }
    
    // MARK: - Actions
    
    /// Handles order placement:
    /// - Shows confirmation alert
    /// - Clears the cart
    private func placeOrder() {
        showConfirmation = true
        cartManager.clearCart()
    }
}

// MARK: - Preview

#Preview {
    CheckoutView()
        .environmentObject(CartManager()) // required for preview
}
