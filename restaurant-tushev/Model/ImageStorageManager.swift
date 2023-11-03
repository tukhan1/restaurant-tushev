//
//  NetworkManager.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 29.10.2023.
//

import UIKit

class ImageStorageManager {

    let cache = NSCache<NSString, UIImage>()

    static let shared = ImageStorageManager()

    func downloadImage(from urlString: String, complition: @escaping (UIImage?) -> Void) {

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            complition(image)
            return
        }

        guard let url = URL(string: urlString) else { complition(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let safeData = data,
                  let image = UIImage(data: safeData) else {
                complition(nil)
                return
            }

            self.cache.setObject(image, forKey: cacheKey)
            complition(image)
        }
        task.resume()
    }
}
