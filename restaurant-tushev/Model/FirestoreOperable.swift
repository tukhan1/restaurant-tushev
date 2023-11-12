//
//  FirestoreOperable.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 11.11.2023.
//

import Firebase

protocol FirestoreOperable {
    func fetchData<T: Decodable>(collectionPath: String, documentId: String, resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func saveData<T: Encodable>(collectionPath: String, documentId: String?, data: T, merge: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchCollection<T: Decodable>(collectionPath: String, resultType: T.Type, completion: @escaping (Result<[T], Error>) -> Void)
}

extension FirestoreOperable {
    func fetchData<T: Decodable>(collectionPath: String, documentId: String, resultType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let docRef = Firestore.firestore().collection(collectionPath).document(documentId)
        docRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists, let resultData = document.decode(as: resultType) else {
                completion(.failure(NSError(domain: "app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Данные не найдены."])))
                return
            }
            completion(.success(resultData))
        }
    }
    
    func saveData<T: Encodable>(collectionPath: String, documentId: String?, data: T, merge: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let jsonData = try JSONEncoder().encode(data)
            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any] else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ошибка при преобразовании данных"])
            }
            let ref = documentId != nil ? Firestore.firestore().collection(collectionPath).document(documentId!) : Firestore.firestore().collection(collectionPath).document()
            ref.setData(dictionary, merge: merge) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchCollection<T: Decodable>(collectionPath: String, resultType: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        Firestore.firestore().collection(collectionPath).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(NWError.invalidData))
                return
            }
            
            let items: [T] = documents.compactMap { document -> T? in
                        let data = document.data()
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                            let item = try JSONDecoder().decode(T.self, from: jsonData)
                            return item
                        } catch {
                            print("Error decoding: \(error)")
                            return nil
                        }
                    }
                    completion(.success(items))
        }
    }
}

