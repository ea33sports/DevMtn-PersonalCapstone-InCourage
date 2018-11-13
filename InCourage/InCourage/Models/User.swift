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
//    let uid: String
    var firstName: String
    var lastName: String
//    var email: String
//    var username: String
//    var password: String
//    var isPrivate: Bool
    var profilePic: UIImage?
    var lifePerspective: String?
    var loveRating: Int
    var totalReminderGramsSent: Int?
    var reminderGramsIn: [ReminderGram]?
    var reminderGramsOut: [ReminderGram]?
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    
    
    
    
    
    // MARK: - Firebase Keys
    
    
    
    // MARK: - Initialization
    init(firstName: String, lastName: String, profilePic: UIImage?, lifePerspective: String?, loveRating: Int?, totalReminderGramsSent: Int?, reminderGramsIn: [ReminderGram]?, reminderGramsOut: [ReminderGram]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.lifePerspective = lifePerspective
        self.loveRating = loveRating ?? 0
        self.totalReminderGramsSent = totalReminderGramsSent
        self.reminderGramsIn = reminderGramsIn
        self.reminderGramsOut = reminderGramsOut
    }
    
    
    
    // MARK: - Firebase
    
}



// MARK: - Firebase Initializer
extension User {
    
}



// MARK: - Equatable Protocol
//extension User: Equatable {
//    static func == (lhs: User, rhs: User) -> Bool {
//        <#code#>
//    }
//}
