//
//  ReminderGramController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseStorage

class ReminderGramController {
    
    // MARK: - Initialization
    static let shared = ReminderGramController()
    
    
    
    // MARK: - Source of Truth
    var reminderGrams: [ReminderGram] = []
    
    
    
    // MARK: - CRUD
    func createReminderGram(uid: String, sender: String, receiver: String, image: UIImage, subject: String, message: String) {
        
        // Save
        StorageManager.shared.uploadReminderGramImage(image) { (url) in
            
            guard let url = url else { return }
            let reminderGram = ReminderGram(uid: uid, sender: sender, receiver: receiver, image: url.absoluteString, subject: subject, message: message)
            
            self.reminderGrams.append(reminderGram)
            
//            DatabaseManager.shared.addDocument(toCollectionPath: "reminderGrams", data: ["uid" : uid, ], completion: { (success) in
//                if success {
//                    print("🧛🏽‍♂️ Successfully added reminderGram to Firebase")
//                } else {
//                    print("🧜🏽‍♀️ Failed to add reminderGram to Firebase")
//                }
//            })
            
//            Endpoint.database.collection("reminderGrams").document(reminderGram.uid).setData(reminderGram.firebaseDictionary) { (error) in
//                if let error = error {
//                    print("🌎 Error saving ReminderGram \(error) \(error.localizedDescription)")
//                } else {
//                    print("👍🏽 Successfully sent ReminderGram!")
//                }
//            }
        }
    }
    
    
    func updateReminderGram(reminderGram: ReminderGram, newLoveRating: Int) {
        reminderGram.loveRating = newLoveRating
        
        // Save
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).updateData(reminderGram.firebaseDictionary)
    }
    
    
    func removeReminderGram(reminderGram: ReminderGram) {
        
        guard let index = reminderGrams.index(of: reminderGram) else { return }
        reminderGrams.remove(at: index)
        
        // Save
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).delete()
    }
}
