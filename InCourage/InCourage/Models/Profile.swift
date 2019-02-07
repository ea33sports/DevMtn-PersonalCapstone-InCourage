//
//  Profile.swift
//  InCourage
//
//  Created by Eric Andersen on 1/26/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import Foundation

class Profile: Codable {
    
    // MARK: - Properties
    var uid: String
    var profilePic: String
    var lifePerspective: String
    var loveRating: Int
    var reminderGramIDs: [String]
    
    
    // MARK: - Firebase Keys
    enum ProfileKey {
        
        // Top Level Item
        static let profiles = "profiles"
        
        // Properties
        static let uid = "uid"
        static let profilePic = "profilePic"
        static let lifePerspective = "lifePerspective"
        static let loveRating = "loveRating"
        static let reminderGramIDs = "reminderGramIDs"
        
    }
    
    var firebaseDictionary: [String : Any] {
        return [
            ProfileKey.uid : uid,
            ProfileKey.profilePic : profilePic,
            ProfileKey.lifePerspective : lifePerspective,
            ProfileKey.loveRating : loveRating,
            ProfileKey.reminderGramIDs : reminderGramIDs,
        ]
    }
    
    
    
    // MARK: - Initialization
    init(uid: String, profilePic: String = "", lifePerspective: String = "", loveRating: Int = 0, reminderGramIDs: [String] = []) {
        self.uid = uid
        self.profilePic = profilePic
        self.lifePerspective = lifePerspective
        self.loveRating = loveRating
        self.reminderGramIDs = reminderGramIDs
    }
}



// MARK: - Firebase Initializer
extension Profile {
    
    convenience init?(profileDictionary: [String : Any]) {
        guard let uid = profileDictionary[ProfileKey.uid] as? String,
            let profilePic = profileDictionary[ProfileKey.profilePic] as? String,
            let lifePerspective = profileDictionary[ProfileKey.lifePerspective] as? String,
            let loveRating = profileDictionary[ProfileKey.loveRating] as? Int else { return nil }
        
        var reminderGramIDs = [String]()
        if let myIDs = profileDictionary[ProfileKey.reminderGramIDs] as? [String] {
            reminderGramIDs.append(contentsOf: myIDs)
        }
        
        self.init(uid: uid, profilePic: profilePic, lifePerspective: lifePerspective, loveRating: loveRating, reminderGramIDs: reminderGramIDs)
    }
}



// MARK: - Equatable Protocol
extension Profile: Equatable {
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.uid == rhs.uid
    }
}
