//
//  DTO.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 29.10.2023.
//

import Foundation

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

struct Banner: Codable {
    let imageUrl: String
    let title: String
    let description: String
}

struct MasterClass: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let date: String
    let recipeUrl: String?
}
