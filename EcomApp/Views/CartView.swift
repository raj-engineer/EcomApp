//
//  CartView.swift
//  EcomApp
//
//  Created by Rajesh on 18/09/25.
//
import SwiftUI

/// A view that displays the user's shopping cart, allowing them to
/// view products, adjust quantities, see the total price, and
/// proceed to checkout.
///
/// Uses `CartManager` as an `@EnvironmentObject` to reactively
/// update the UI when cart items change.
struct CartView: View {
    
    /// The cart manager that provides the cart items and operations.
    @EnvironmentObject var cartManager: CartManager
    
    /// Controls presentation of the checkout sheet.
    @State private var showCheckout = false

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Empty Cart Placeholder
                if cartManager.cartItems.isEmpty {
                    Text("Your cart is empty 🛒")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    // MARK: - Cart Item List
                    List {
                        ForEach(cartManager.cartItems) { item in
                            HStack {
                                // Product thumbnail
                                AsyncImage(url: URL(string: item.product.thumbnail)) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 50, height: 50)
                                .cornerRadius(8)
                                
                                // Product title and price × quantity
                                VStack(alignment: .leading) {
                                    Text(item.product.title)
                                        .font(.headline)
                                        .lineLimit(1)
                                    Text("$\(item.product.price, specifier: "%.2f") x \(item.quantity)")
                                        .foregroundColor(.green)
                                }
                                
                                Spacer()
                                
                                // Stepper to adjust quantity
                                Stepper("", value: Binding(
                                    get: { item.quantity },
                                    set: { newValue in
                                        if newValue > item.quantity {
                                            cartManager.addToCart(item.product)
                                        } else {
                                                           cartManager.removeFromCart(item.product)
                                        }
                                    }
                                ), in: 1...99)
                                .labelsHidden()
                                
                                // Delete button to remove item completely
                                           Button(action: {
                                               cartManager.clearItem(item.product)
                                           }) {
                                               Image(systemName: "trash")
                                                   .foregroundColor(.red)
                                           }
                                           .buttonStyle(BorderlessButtonStyle()) // Important inside List
                            }
                        }
                    }

                    // MARK: - Total Price & Checkout
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text("$\(cartManager.totalPrice, specifier: "%.2f")")
                                .font(.headline)
                        }
                        .padding(.horizontal)

                        // Proceed to checkout button
                        Button(action: { showCheckout = true }) {
                            Text("Proceed to Checkout")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("My Cart")
            // Present checkout sheet when button is tapped
            .sheet(isPresented: $showCheckout) {
                CheckoutView()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CartView()
        .environmentObject(CartManager()) // Inject sample cart manager for preview
}
