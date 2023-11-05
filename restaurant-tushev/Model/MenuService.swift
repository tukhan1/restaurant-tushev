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
    
    static let shared = MenuService()
    
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
    
    func fetchBanners(completion: @escaping (Result<[Banner], Error>) -> Void) {
        let bannersCollection = Firestore.firestore().collection("banners")
        bannersCollection.getDocuments { snap, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let documents = snap?.documents else {
                completion(.failure(NWError.invalidData))
                return
            }
 
            let banners = documents.compactMap { document -> Banner? in
                let data = document.data()
                return Banner(imageUrl: data["imageUrl"] as? String ?? "",
                              title: data["title"] as? String ?? "",
                              description: data["description"] as? String ?? "")
            }
            completion(.success(banners))
        }
    }

    func fetchChefRecommendations(completion: @escaping (Result<[MasterClass], Error>) -> Void) {
        let recommendationsCollection = Firestore.firestore().collection("chef_recommendations")
        recommendationsCollection.getDocuments { snap, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let documents = snap?.documents else {
                completion(.failure(NWError.invalidData))
                return
            }
            
            let chefRecommendations = documents.compactMap { document -> MasterClass? in
                let data = document.data()
                return MasterClass(title: data["title"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            imageUrl: data["imageUrl"] as? String ?? "",
                            date: data["date"] as? String ?? "",
                            recipeUrl: data["recipeUrl"] as? String)
            }
            completion(.success(chefRecommendations))
        }
    }
    
    private func getCategories(completion: @escaping (Result<[MenuCategory], Error>) -> Void) {
        let menuCollection = Firestore.firestore().collection(K.menu)
        menuCollection.getDocuments { snapshot, error in
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
