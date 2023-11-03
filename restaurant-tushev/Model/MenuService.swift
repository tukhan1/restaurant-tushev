//
//  MenuService.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 29.10.2023.
//

import Foundation
import FirebaseFirestore

enum NWError: String, Error {
    case invalidURL = "Something wrong with URL"
    case unableToComplete = "Received ERROR"
    case invalidData = "Something wrong with Data"
}

final class MenuService {
    
    func getFullMenu(completion: @escaping (Result<[MenuSection], Error>) -> Void) {
        getCategories { categoryResult in
            switch categoryResult {
            case .success(let categories):
                var menu: [MenuSection] = []
                let group = DispatchGroup()

                for category in categories {
                    group.enter()
                    self.getProductsPer(category: category) { productResult in
                        switch productResult {
                        case .success(let products):
                            let catsandProd = MenuSection(title: category.title, products: products)
                            menu.append(catsandProd)
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(menu))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getCategories(completion: @escaping (Result<[MenuCategory], Error>) -> Void) {
        Firestore.firestore().collection(K.menu).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NWError.invalidData))
                return
            }
            
            let categories = documents.compactMap { document -> MenuCategory? in
                let data = document.data()
                let id = document.documentID
                let menuTitle = data["title"] as? String ?? ""
                return MenuCategory(title: menuTitle, categoryId: id)
            }
            
            completion(.success(categories))
        }
    }
    
    private func getProductsPer(category: MenuCategory, completion: @escaping (Result<[Product], Error>) -> Void) {
        Firestore.firestore().collection(K.menu).document(category.categoryId).collection("products").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NWError.invalidData))
                return
            }
            
            let products = documents.compactMap { document -> Product? in
                let data = document.data()
                return Product(
                    title: data["title"] as? String ?? "",
                    cost: data["cost"] as? String ?? "",
                    weight: data["weight"] as? String ?? "",
                    imageUrl: data["imageUrl"] as? String ?? ""
                )
            }
            
            completion(.success(products))
        }
    }
}
