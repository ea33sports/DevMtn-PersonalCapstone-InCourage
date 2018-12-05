//
//  UserController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation

class UserController {
    
    // MARK: - Initialization
    static let shared = UserController()
    private init() {}
    
    
    
    // MARK: - Source of Truth
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: currentUserWasSetNotification, object: nil)
        }
    }
    
    
    
    // MARK: - Properties
    let currentUserWasSetNotification = Notification.Name("currentUserSet")
    var isUserLoggedIn = false
}
