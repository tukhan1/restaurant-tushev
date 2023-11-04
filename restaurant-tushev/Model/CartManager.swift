//
//  CartManager.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import UIKit

class CartManager {
    
    var itemsCount: Int {
        return items.count
    }
    
    private var items: [Product] = []
    
    func calculateTotalAmount() -> Double {
        return items.reduce(0.0) { total, product in
            total + (product.cost.parsePrice() ?? 0)
        }
    }
    
    func addToCart(_ product: Product) {
        items.append(product)
    }
    
    func removeFromCart(_ product: Product) {
        if let index = items.firstIndex(of: product) {
            items.remove(at: index)
        }
    }
    
    func clearCart() {
        items.removeAll()
    }
}
