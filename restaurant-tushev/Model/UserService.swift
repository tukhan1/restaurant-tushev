//
//  UserService.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 07.11.2023.
//

import Firebase

class UserService {
    
    var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    static let shared = UserService()
    
    private init() {}
    
    func fetchUser(completion: @escaping (User?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден."]))
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                if let safeData = userData {
                    let user = User(uid: uid, dictionary: safeData)
                    completion(user, nil)
                } else {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func verifyPhoneNumber(_ phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                completion(.failure(error))
            } else if let verificationID = verificationID {
                completion(.success(verificationID))
            }
        }
    }
    
    func signInWithVerificationCode(_ verificationCode: String, verificationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                // Пользователь успешно вошел в систему, теперь сохраняем его номер телефона
                self?.savePhoneNumber(authResult.user.phoneNumber, userId: authResult.user.uid, completion: completion)
            }
        }
    }
    
    func signOut(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false, signOutError)
        }
    }
    
    private func savePhoneNumber(_ phoneNumber: String?, userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let phoneNumber = phoneNumber else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Номер телефона не доступен"])))
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(userId)
        userRef.setData(["phoneNumber": phoneNumber], merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func saveOrder(_ order: Order, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("orders").document(order.id).setData(order.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func addAddress(_ address: Address, for userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userAddressesCollection = Firestore.firestore().collection("users").document(userId).collection("addresses")
        userAddressesCollection.addDocument(data: address.dictionary) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchUserAddress(userId: String, completion: @escaping (Result<String, Error>) -> Void) {
            let userDocRef = Firestore.firestore().collection("users").document(userId)
            
            userDocRef.getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let document = document, document.exists {
                    let address = document.data()?["fullAddress"] as? String
                    completion(.success(address ?? "Адрес не указан"))
                } else {
                    completion(.failure(NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Документ пользователя не найден"])))
                }
            }
        }
}

