//
//  Endpoint.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct Endpoint {
    
    // MARK: - Endpoint Properties
    // Firebase
    private static let _auth = Auth.auth()
    private static let _storageRef = Storage.storage().reference()
    private static let _database = Firestore.firestore()
    
    private init() {}
    
    
    // App Facing
    static var auth: Auth {
        return Endpoint._auth
    }
    
    static var storageRef: StorageReference {
        return Endpoint._storageRef
    }
    
    static var database: Firestore {
        return Endpoint._database
    }
    
    
    
    // MARK: - Firestore Collection
    struct Collection {
        private static let _users = "users"
        private static let _reminderGrams = "reminderGrams"
        
        static var users: CollectionReference {
            return Endpoint.database.collection(_users)
        }
        
        static var reminderGrams: CollectionReference {
            return Endpoint.database.collection(_reminderGrams)
        }
    }
    
    
    
    // MARK: - Firebase Storagebucket paths
    struct StorageBucket {
        private static let _images = "images"
        private static let _profileImages = "profileImages"
        private static let _reminderGramImages = "reminderGramImages"
        
        static var images: StorageReference {
            return Endpoint.storageRef.child(_images)
        }
        
        static func profileImage(forUid uid: String) -> StorageReference {
            return images.child(_profileImages).child(uid)
        }
        
        static func reminderGramImages(forUid uid: String) -> StorageReference {
            return images.child(_reminderGramImages).child(uid)
        }
    }
    
    
}
