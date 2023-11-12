//
//  CartManager.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit

final class CartManager {
    
    var items: [CartItem] = []

    var itemsCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
    
    var uniqueProducts: [Product] {
        return items.map { $0.product }
    }
    
    func calculateTotalAmount() -> Double {
        return items.reduce(0.0) { total, cartItem in
            total + (cartItem.product.cost.parsePrice() ?? 0) * Double(cartItem.quantity)
        }
    }
    
    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product == product }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product == product }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
