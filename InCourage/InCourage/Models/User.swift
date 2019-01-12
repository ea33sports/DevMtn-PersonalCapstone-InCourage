//
//  User.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class User {
    
    // MARK: - Properties
    let uid: String
    var email: String
    var username: String
    var loggedIn: Bool
    var firstName: String
    var lastName: String
    var isPrivate: Bool
    var profilePic: String
    var lifePerspective: String
    var loveRating: Int
    var reminderGramInboxIDs: [String]
    var reminderGramOutboxIDs: [String]
    var totalReminderGramsSent: Int
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
//    var FBSearchDictionary: [String] {
//        var characters = ""
//        var returnArray: [String] = []
//        let usernameArray = Array(username.lowercased())
//        let fullNameArray = Array(fullName.lowercased())
//        for n in 0...username.count - 1 {
////            let userArray = Array(usernameArray)
//            characters.append(usernameArray[n])
//            returnArray.append(characters)
//            
//        }
//        characters = ""
//        for n in 0...fullName.count - 1 {
////            let fullArray = Array(fullNameArray)
//            characters.append(fullNameArray[n])
//            returnArray.append(characters)
//        }
//        return returnArray
//    }
    
    
    // MARK: - Firebase Keys
    enum UserKey {
        
        // Top Level Item
        static let users = "users"
        
        // Properties
        static let uid = "uid"
        static let email = "email"
        static let username = "username"
        static let loggedIn = "loggedIn"
        static let firstName = "firstName"
        static let lastName = "lastName"
//        static let fullName = "fullName"
        static let isPrivate = "isPrivate"
        static let profilePic = "profilePic"
        static let lifePerspective = "lifePerspective"
        static let loveRating = "loveRating"
        static let reminderGramInboxIDs = "reminderGramInboxIDs"
        static let reminderGramOutboxIDs = "reminderGramOutboxIDs"
        static let totalReminderGramsSent = "totalReminderGramsSent"
//        static let FBSearchDictionary = "FBSearchDictionary"
        
    }
    
    var firebaseDictionary: [String : Any] {
        return [
            UserKey.uid : uid,
            UserKey.email : email,
            UserKey.username : username,
            UserKey.loggedIn : loggedIn,
            UserKey.firstName : firstName,
            UserKey.lastName : lastName,
            UserKey.isPrivate : isPrivate,
            UserKey.profilePic : profilePic as Any,
            UserKey.lifePerspective : lifePerspective as Any,
            UserKey.loveRating : loveRating,
            UserKey.reminderGramInboxIDs : reminderGramInboxIDs as Any,
            UserKey.reminderGramOutboxIDs : reminderGramOutboxIDs as Any,
            UserKey.totalReminderGramsSent : totalReminderGramsSent as Any
//            UserKey.FBSearchDictionary : FBSearchDictionary
        ]
    }
    
    
    
    // MARK: - Initialization
    init(uid: String, email: String, username: String, loggedIn: Bool, firstName: String, lastName: String, isPrivate: Bool, profilePic: String = "", lifePerspective: String = "", loveRating: Int = 0, reminderGramInboxIDs: [String] = [], reminderGramOutboxIDs: [String] = [], totalReminderGramsSent: Int = 0) {
        self.uid = uid
        self.email = email
        self.username = username
        self.loggedIn = loggedIn
        self.firstName = firstName
        self.lastName = lastName
        self.isPrivate = isPrivate
        self.profilePic = profilePic
        self.lifePerspective = lifePerspective
        self.loveRating = loveRating
        self.reminderGramInboxIDs = reminderGramInboxIDs
        self.reminderGramOutboxIDs = reminderGramOutboxIDs
        self.totalReminderGramsSent = totalReminderGramsSent
    }
}



// MARK: - Firebase Initializer
extension User {
    
    convenience init?(userDictionary: [String : Any]) {
        guard let uid = userDictionary[UserKey.uid] as? String,
            let email = userDictionary[UserKey.email] as? String,
            let username = userDictionary[UserKey.username] as? String,
            let loggedIn = userDictionary[UserKey.loggedIn] as? Bool,
            let firstName = userDictionary[UserKey.firstName] as? String,
            let lastName = userDictionary[UserKey.lastName] as? String,
            let isPrivate = userDictionary[UserKey.isPrivate] as? Bool,
            let profilePic = userDictionary[UserKey.profilePic] as? String,
            let lifePerspective = userDictionary[UserKey.lifePerspective] as? String,
            let loveRating = userDictionary[UserKey.loveRating] as? Int,
            let totalReminderGramsSent = userDictionary[UserKey.totalReminderGramsSent] as? Int else { return nil }
        var reminderGramInboxIDs = [String]()
        if let inboxIDs = userDictionary[UserKey.reminderGramInboxIDs] as? [String] {
            reminderGramInboxIDs.append(contentsOf: inboxIDs)
        }
        
        var reminderGramOutboxIDs = [String]()
        if let outboxIDs = userDictionary[UserKey.reminderGramOutboxIDs] as? [String] {
            reminderGramOutboxIDs.append(contentsOf: outboxIDs)
        }
        
        self.init(uid: uid, email: email, username: username, loggedIn: loggedIn, firstName: firstName, lastName: lastName, isPrivate: isPrivate, profilePic: profilePic, lifePerspective: lifePerspective, loveRating: loveRating, reminderGramInboxIDs: reminderGramInboxIDs, reminderGramOutboxIDs: reminderGramOutboxIDs, totalReminderGramsSent: totalReminderGramsSent)
    }
}



// MARK: - Equatable Protocol
extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
