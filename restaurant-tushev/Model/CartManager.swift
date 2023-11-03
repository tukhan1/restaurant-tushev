//
//  CartManager.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit

class CartManager {
    static let shared = CartManager()

    var items: [Product] = []

    func addToCart(_ product: Product) {
        items.append(product)
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }

    func removeFromCart(_ product: Product) {
        if let index = items.firstIndex(of: product) {
            items.remove(at: index)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
    }

    func clearCart() {
        items.removeAll()
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("CartUpdated")
}
