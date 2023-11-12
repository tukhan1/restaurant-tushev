//
//  DocumentSnapshot+Ext.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 11.11.2023.
//

import Firebase

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type) -> T? {
        guard let documentData = data() else { return nil }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
            let object = try JSONDecoder().decode(objectType, from: jsonData)
            return object
        } catch {
            print("Ошибка декодирования: \(error)")
            return nil
        }
    }
}
