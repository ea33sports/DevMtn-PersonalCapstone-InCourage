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
    func createReminderGram(uid: String, image: UIImage, subject: String, message: String) {
        
        // Save
        StorageManager.shared.uploadReminderGramImage(uid: uid, image) { (url) in
            
            guard let currentProfile = ProfileController.shared.currentProfile,
                let url = url else { fatalError() }
            let reminderGram = ReminderGram(uid: uid, image: url.absoluteString, subject: subject, message: message)
            currentProfile.reminderGramIDs.append(reminderGram.uid)
            
            Endpoint.database.collection("profiles").document(currentProfile.uid).updateData(["reminderGramIDs" : currentProfile.reminderGramIDs])
            
            print("🏆 We have reminderGram IDs!!!!!🏅")
            
            Endpoint.database.collection("reminderGrams").document(reminderGram.uid).setData(reminderGram.firebaseDictionary) { (error) in
                if let error = error {
                    print("🌎 Error saving ReminderGram \(error) \(error.localizedDescription)")
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    print("🎀🎀🎀 loaded")
                    print("👍🏽 Successfully created ReminderGram!")
                }
            }
        }
    }
    
    
    func updateReminderGram(reminderGram: ReminderGram, newSubject: String, newMessage: String, newLoveRating: Int) {
        reminderGram.subject = newSubject
        reminderGram.message = newMessage
        reminderGram.loveRating = newLoveRating
        
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).updateData(reminderGram.firebaseDictionary)
    }
    
    
    func removeReminderGram(reminderGram: ReminderGram) {
        
        guard let currentProfile = ProfileController.shared.currentProfile else { return }
        
        if currentProfile.reminderGramIDs.contains(reminderGram.uid) {
            currentProfile.reminderGramIDs.removeAll(where: { $0 == reminderGram.uid })
        }
        
        Endpoint.database.collection("profiles").document(currentProfile.uid).updateData(["reminderGramIDs" : currentProfile.reminderGramIDs])
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).delete()
    }
    
    
    
    // MARK: - Fetching
    func fetchReminderGrams(ids: [String], completion: @escaping ([ReminderGram]) -> Void) {

        Endpoint.database.collection("reminderGrams").getDocuments { (snapshot, error) in
            if let error = error {
                print("😤 Error getting reminderGrams \(error) \(error.localizedDescription)")
            }

            if let documents = snapshot {
                let reminderGramDictionaries = documents.documents.map({ $0.data() })
                let result = reminderGramDictionaries.map({ ReminderGram.init(reminderGramDictionary: $0) }).compactMap({ $0 }).filter({ ids.contains( ($0.uid) ) })
                completion(result)
            }
        }
    }
}
