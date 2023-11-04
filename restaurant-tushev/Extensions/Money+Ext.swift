//
//  Money+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 03.11.2023.
//

import Foundation

extension String {
    func parsePrice() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        
        if let number = formatter.number(from: self) {
            return number.doubleValue
        }
        return 0.0
    }
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.currencySymbol = "Р"
        
        if let value = parsePrice() {
            return formatter.string(from: NSNumber(value: value)) ?? "0 Р"
        }
        return "0 Р"
    }
}

extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.currencySymbol = "Р"
        
        return formatter.string(from: NSNumber(value: self)) ?? "0 Р"
    }
}
