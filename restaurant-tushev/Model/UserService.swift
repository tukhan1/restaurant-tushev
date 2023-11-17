//
//  UserService.swift
//  restaurant-tushev
//
//  Created by Egor Tushev on 07.11.2023.
//

import Firebase

final class UserService: FirestoreOperable {
    
    private let auth: Auth
    private let db: Firestore
    
    var userId: String? {
        return auth.currentUser?.uid
    }
    
    static let shared = UserService(auth: Auth.auth(), db: Firestore.firestore())
    
    init(auth: Auth, db: Firestore) {
        self.auth = auth
        self.db = db
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        guard let uid = userId else {
            completion(.failure(NSError(domain: "app", code: 404, userInfo: [NSLocalizedDescriptionKey: "Пользователь не найден."])))
            return
        }
        
        fetchData(collectionPath: K.users, documentId: uid, resultType: User.self, completion: completion)
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
        
        auth.signIn(with: credential) { [weak self] (authResult, error) in
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
            try auth.signOut()
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
        
        let data = ["phoneNumber": phoneNumber]
        saveData(collectionPath: K.users, documentId: userId, data: data, merge: true, completion: completion)
    }
    
    func saveOrder(_ order: Order, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.orders)"
        saveData(collectionPath: path, documentId: order.id, data: order, merge: false, completion: completion)
    }
    
    func saveAddress(_ address: Address, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.addresses)"
        saveData(collectionPath: path, documentId: K.currentAddress, data: address, merge: true, completion: completion)
    }
    
    func fetchAddress(completion: @escaping (Result<Address, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.addresses)"
        fetchData(collectionPath: path, documentId: K.currentAddress, resultType: Address.self, completion: completion)
    }

    func fetchLoyaltyData(completion: @escaping (Result<Loyalty, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.loyalty)"
        fetchData(collectionPath: path, documentId: K.loyaltyCard, resultType: Loyalty.self, completion: completion)
    }
    
    func createLoyaltyCard(_ loyaltyCard: Loyalty, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.loyalty)"
        saveData(collectionPath: path, documentId: K.loyaltyCard, data: loyaltyCard, merge: true, completion: completion)
    }
    
    func saveReservation(_ reservation: Reservation, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.reservations)"
        saveData(collectionPath: path, documentId: reservation.id, data: reservation, merge: false, completion: completion)
    }
    
    func fetchOrderHistory(completion: @escaping (Result<[Order], Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.orders)"
        fetchCollection(collectionPath: path, resultType: Order.self, completion: completion)
    }
    
    func fetchBookingHistory(completion: @escaping (Result<[Reservation], Error>) -> Void) {
        guard let userId = userId else { completion(.failure(NWError.invalidURL)); return }
        let path = "\(K.users)/\(userId)/\(K.reservations)"
        fetchCollection(collectionPath: path, resultType: Reservation.self, completion: completion)
    }
}
