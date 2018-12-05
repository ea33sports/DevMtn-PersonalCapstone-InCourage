//
//  AuthManager.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Create User
    func createAccount(withEmail email: String, password: String, username: String, completion: @escaping (_ user: AuthDataResult?, _ error: Error?) -> Void) {
        Endpoint.auth.createUser(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("Error creating user: \(#function) \(error) \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let user = authDataResult?.user {
                let ref = Database.database().reference().root
                ref.child("users").child(user.uid).setValue(email)
                ref.child("users").child(user.uid).setValue(password)
            }
        }
    }
    
    
    // Convert Anonymous to Permanent User
    func convertAnonymousUserToPermanentAccount(withEmail email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Endpoint.auth.currentUser?.linkAndRetrieveData(with: credential, completion: { (authDataResult, error) in
            
            if let error = error {
                print("Error linking anonymous user to the permanent user credentials: \(#function) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let user = authDataResult?.user {
                let ref = Database.database().reference().root
                ref.child("users").child(user.uid).setValue(email)
                ref.child("users").child(user.uid).setValue(password)
            }
        })
    }
    
    
    
    // MARK: - Sign-in User
    func signIn(withEmail email: String, password: String, completion: @escaping (_ success: Bool) -> Void) {
        Endpoint.auth.signIn(withEmail: email, password: password) { (authDataResult, error) in
            if let error = error {
                print("Error signing in user: \(#function) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let user = authDataResult?.user {
                
            }
        }
    }
    
    
    // Sign In Anynymously
    func signInAnonymously(completion: @escaping (_ succeess: Bool) -> Void) {
        Endpoint.auth.signInAnonymously { (authDataResult, error) in
            if let error = error {
                print("Error signing in an anonymous user: \(#function) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let user = authDataResult?.user {
                
            }
        }
    }
    
    
    
    // MARK: - Logout User
    func logout(completion: @escaping (_ success: Bool) -> Void) {
        do {
            try Endpoint.auth.signOut()
            completion(true)
        } catch {
            print("Could not log out the user")
            completion(false)
            return
        }
    }
    
    
    
    // MARK: - Password Reset
    func sendPasswordReset(toEmail email: String, completion: @escaping (_ success: Bool) -> Void) {
        Endpoint.auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending the user a password reset email: \(#function) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        }
    }
    
    
    func updatePassword(newPassword password: String, completion: @escaping (_ success: Bool) -> Void) {
        Endpoint.auth.currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                print("Error updating the users password: \(#function) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
        })
    }
}
