//
//  AuthService.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/29/24.
//

import Firebase
import FirebaseAuth

enum AuthError: Error {
    case failedToSignIn
    case failedToSignOut
    case failedToCreateUser
    case userNotFound
}

class AuthService {
    static let shared = AuthService()
    
    private init() { }
    
    func signIn(withEmail email: String, password: String) async throws -> User {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            return try await UserService.shared.fetchUser(uid: result.user.uid)
        } catch {
            print("DEBUG: Failed to sign in: \(error.localizedDescription)")
            throw AuthError.failedToSignIn
        }
    }
    
    func createUser(withEmail email: String, password: String, name: String) async throws -> User {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)

            try await UserService.shared.craeteUser(email: email, name: name, uid: result.user.uid)
            return try await UserService.shared.fetchUser(uid: result.user.uid)
        } catch {
            print("DEBUG: Failed to create user: \(error.localizedDescription)")
            throw AuthError.failedToCreateUser
        }
    }
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Failed to sign out: \(error.localizedDescription)")
            throw AuthError.failedToSignOut
        }
    }
    
    func getCurrentUser() throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw AuthError.failedToSignOut
        }
        return uid
    }
}
