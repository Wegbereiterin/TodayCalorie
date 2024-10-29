//
//  UserService.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/29/24.
//

import Firebase
import FirebaseFirestore

enum UserError: Error {
    case failedToCreateUser
    case failedToFetchUser
    case invalidUser
}

class UserService {
    static let shared = UserService()
    
    private var db = Firestore.firestore()
    
    private init() { }
    
    func craeteUser(email: String, name: String, uid: String) async throws {
        let user = User(
            uid: uid,
            name: name,
            email: email
        )
        
        do {
            try db.collection("users").document(uid).setData(from: user)
        } catch {
            print("DEBUGLOG: Failed to create user \(error.localizedDescription)")
            throw UserError.failedToCreateUser
        }
    }
    
    func fetchUser(uid: String) async throws -> User {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            let user = try snapshot.data(as: User.self)
            return user
        } catch {
            print("DEBUGLOG: Failed to fetch user \(error.localizedDescription)")
            throw UserError.failedToFetchUser
        }
    }
}
