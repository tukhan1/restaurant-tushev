//
//  DTO.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 29.10.2023.
//

import Foundation
import FirebaseFirestore

// MARK: - User Profile
struct User: Codable {
    let phoneNumber: String
}

struct Address: Codable {
    let name: String
    let street: String
    let houseNumber: String
    let apartment: String
    let building: String?
    let intercom: String?
}

struct Loyalty: Codable {
    let id: String
    let amount: Double
}

// MARK: - Orders
struct Order: Codable {
    var id: String
    var date: Date
    var totalAmount: Double
}

// MARK: - Menu
struct Product: Codable, Equatable {
    let title: String
    let cost: String
    let weight: String
    let imageUrl: String
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.title == rhs.title && lhs.cost == rhs.cost && lhs.weight == rhs.weight && lhs.imageUrl == rhs.imageUrl
    }
}

struct MenuCategory: Codable {
    let title: String
    let categoryId: String
}

struct MenuSection {
    let title: String
    let products: [Product]
}

// MARK: - Promotions
struct Banner: Codable {
    let imageUrl: String
    let title: String
    let description: String
    let activeUrl: String?
}

struct MasterClass: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let date: String
    let recipeUrl: String?
}

// MARK: - Reservations
struct Reservation: Codable {
    var id: String
    var date: Date
    var numberOfGuests: Int
}

// MARK: - Cart
struct CartItem {
    let product: Product
    var quantity: Int
}
