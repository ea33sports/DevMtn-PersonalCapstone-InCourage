//
//  User.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class User {
    
    var firstName: String
    var lastName: String
//    var email: String
//    var password: String
    var profilePic: UIImage?
    var lifePerspective: String?
    var loveRating: Int
    var messagesSent: Int?
    var reminderGrams: [ReminderGram]?
    
    init(firstName: String, lastName: String, profilePic: UIImage?, lifePerspective: String?, loveRating: Int?, messagesSent: Int?, reminderGrams: [ReminderGram]?) {
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = profilePic
        self.lifePerspective = lifePerspective
        self.loveRating = loveRating ?? 0
        self.messagesSent = messagesSent
        self.reminderGrams = reminderGrams
    }
    
}
