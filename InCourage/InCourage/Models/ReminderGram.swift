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
//    var sender: String
//    var receiver: String
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
//        static let sender = "sender"
//        static let receiver = "receiver"
        static let image = "image"
        static let subject = "subject"
        static let message = "message"
        static let loveRating = "loveRating"
    }
    
    
    var firebaseDictionary: [String : Any] {
        return [
            ReminderGramKey.uid : uid,
//            ReminderGramKey.sender : sender,
//            ReminderGramKey.receiver : receiver,
            ReminderGramKey.image : image,
            ReminderGramKey.subject : subject,
            ReminderGramKey.message : message,
            ReminderGramKey.loveRating : loveRating as Any,
        ]
    }
    
    
    
    // MARK: - Initialization
    init(uid: String, image: String, subject: String, message: String, loveRating: Int = 0) {
        self.uid = uid
//        self.sender = sender
//        self.receiver = receiver
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
//            let sender = reminderGramDictionary[ReminderGramKey.sender] as? String,
//            let receiver = reminderGramDictionary[ReminderGramKey.receiver] as? String,
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
