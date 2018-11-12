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
    var sender: User
    var receiver: User
    var image: UIImage
    var subject: String
    var message: String
    var loveRating: Int
    var color: UIColor
    
    
    // MARK: - Firebase Keys
    
    
    // MARK: - Initialization
    init(sender: User, receiver: User, image: UIImage, subject: String, message: String, loveRating: Int, color: UIColor) {
        self.sender = sender
        self.receiver = receiver
        self.image = image
        self.subject = subject
        self.message = message
        self.loveRating = loveRating
        self.color = color
    }
    
    
    // MARK: - Firebase
}

// MARK: - Firebase Initialization
extension ReminderGram {
    
}

// MARK: - Equatable Protocol
//extension ReminderGram: Equatable {
//    static func == (lhs: ReminderGram, rhs: ReminderGram) -> Bool {
//        <#code#>
//    }
//}
