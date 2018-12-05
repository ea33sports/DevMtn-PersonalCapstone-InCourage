//
//  DatabaseManager.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    // MARK: - Read
    func getAllDocuments(forCollectionPath collectionPath: String, completion: @escaping (_ documents: [QueryDocumentSnapshot]?, _ error: Error?) -> Void) {
        
        Endpoint.database.collection(collectionPath).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error get the documents at colleciton path: \(collectionPath) \(error) \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let documents = querySnapshot?.documents {
                completion(documents, nil)
            }
        }
    }
    
    
    func getDocument(forCollectionPath collectionPath: String, documentPath: String, completion: @escaping (_ document: Dictionary<String, Any>?, _ error: Error?) -> Void) {
        
        Endpoint.database.collection(collectionPath).document(documentPath).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error get the document at document path: \(documentPath) \(error) \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                let document = documentSnapshot.data()
                completion(document, error)
            }
        }
    }
    
    
    
    // MARK: - Write
    func setNewUser(document: String, toCollection collection: CollectionReference, data: Dictionary<String, Any>, completion: @escaping (_ success: Bool) -> Void) {
        
        collection.document(document).setData(data) { (error) in
            if let error = error {
                print("Unable to set data to document: \(document) \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    func addDocument(toCollectionPath collectionPath: String, data: Dictionary<String, Any>, completion: @escaping (_ success: Bool) -> Void) {
        
        Endpoint.database.collection(collectionPath).addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to add data to colleciton: \(collectionPath) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
    
    // MARK: - Update
    func updateDocument(forCollectionPath collectionPath: String, documentPath: String, withFields fields: Dictionary<String, Any>, completion: @escaping (_ success: Bool) -> Void) {
        
        Endpoint.database.collection(collectionPath).document(documentPath).updateData(fields) { (error) in
            if let error = error {
                print("Error updating document at document path: \(documentPath) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
