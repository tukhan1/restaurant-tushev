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

struct User {
    let uid: String
    let phoneNumber: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
    }
}

struct Order {
    var id: String
    var date: Date
    var totalAmount: Double
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "date": date,
            "totalAmount": totalAmount
        ]
    }
}

struct Address {
    let name: String
    let street: String
    let houseNumber: String
    let apartment: String
    let building: String?
    let intercom: String?
    
    
    var dictionary: [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "street": street,
            "houseNumber": houseNumber,
            "apartment": apartment
        ]

        
        if let building = building {
            dict["building"] = building
        }
        
        if let intercom = intercom {
            dict["intercom"] = intercom
        }
        
        
        return dict
    }
}

