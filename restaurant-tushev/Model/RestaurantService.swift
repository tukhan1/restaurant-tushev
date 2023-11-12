//
//  RestaurantService.swift
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

final class RestaurantService: FirestoreOperable {
    
    static let shared = RestaurantService()
    
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
        fetchCollection(collectionPath: K.menu, resultType: MenuCategory.self, completion: completion)
    }

    private func getProductsPer(category: MenuCategory, completion: @escaping (Result<[Product], Error>) -> Void) {
        let path = "\(K.menu)/\(category.categoryId)/\(K.products)"
        fetchCollection(collectionPath: path, resultType: Product.self, completion: completion)
    }
    
    func fetchBanners(completion: @escaping (Result<[Banner], Error>) -> Void) {
        fetchCollection(collectionPath: K.banners, resultType: Banner.self, completion: completion)
    }
    
    func fetchChefRecommendations(completion: @escaping (Result<[MasterClass], Error>) -> Void) {
        fetchCollection(collectionPath: K.recommendations, resultType: MasterClass.self, completion: completion)
    }
}
