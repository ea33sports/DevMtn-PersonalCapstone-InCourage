//
//  ReminderGram.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class ReminderGram {
    
    // MARK: - Properties
    var uid: String
    var image: String
    var subject: String
    var message: String
    var loveRating: Int
    
    
    
    // MARK: - Firebase Keys
    enum ReminderGramKey {
        
        // Top Level Item
        static let reminderGrams = "reminderGrams"
        
        // Properties
        static let uid = "uid"
        static let image = "image"
        static let subject = "subject"
        static let message = "message"
        static let loveRating = "loveRating"
    }
    
    
    var firebaseDictionary: [String : Any] {
        return [
            ReminderGramKey.uid : uid,
            ReminderGramKey.image : image,
            ReminderGramKey.subject : subject,
            ReminderGramKey.message : message,
            ReminderGramKey.loveRating : loveRating as Any,
        ]
    }
    
    
    
    // MARK: - Initialization
    init(uid: String, image: String, subject: String, message: String, loveRating: Int = 0) {
        self.uid = uid
        self.image = image
        self.subject = subject
        self.message = message
        self.loveRating = loveRating
    }
}



// MARK: - Firebase Initialization
extension ReminderGram {
    
    convenience init?(reminderGramDictionary: [String : Any]) {
        guard let uid = reminderGramDictionary[ReminderGramKey.uid] as? String,
            let image = reminderGramDictionary[ReminderGramKey.image] as? String,
            let subject = reminderGramDictionary[ReminderGramKey.subject] as? String,
            let message = reminderGramDictionary[ReminderGramKey.message] as? String,
            let loveRating = reminderGramDictionary[ReminderGramKey.loveRating] as? Int else { return nil }
        
        self.init(uid: uid, image: image, subject: subject, message: message, loveRating: loveRating)
    }
}



// MARK: - Equatable Protocol
extension ReminderGram: Equatable {
    static func == (lhs: ReminderGram, rhs: ReminderGram) -> Bool {
        return lhs.uid == rhs.uid
    }
}
