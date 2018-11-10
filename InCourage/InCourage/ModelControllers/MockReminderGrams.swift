//
//  MockReminderGrams.swift
//  InCourage
//
//  Created by Eric Andersen on 11/5/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation

class MockReminderGrams {
    
    static let suzyReminderGram1 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.suzy, image: #imageLiteral(resourceName: "sendMessagePhoto"), subject: "Hey", message: "You", loveRating: 1, color: .white)
    
    static let suzyReminderGram2 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.suzy, image: #imageLiteral(resourceName: "sendMessagePhoto"), subject: "Love", message: "You", loveRating: 1, color: .white)
    
    static let rogerReminderGram1 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.roger, image: #imageLiteral(resourceName: "completedMoose"), subject: "My Name is Roger...", message: "Yeah!", loveRating: 1, color: .white)
    
    static let rogerReminderGram2 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.roger, image: #imageLiteral(resourceName: "defaultPhoto"), subject: "And I love ding dongs", message: "What?", loveRating: 1, color: .white)
    
    static let neilReminderGram1 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.neil, image: #imageLiteral(resourceName: "addPhoto"), subject: "Anime", message: "Wait till you see it...", loveRating: 1, color: .white)
    
    static let neilReminderGram2 = ReminderGram(sender: MockUsers.neil, receiver: MockUsers.neil, image: #imageLiteral(resourceName: "sendMessagePhoto"), subject: "Wishing", message: "I was you right now", loveRating: 1, color: .white)
    
    
    static let mockReminderGrams = [MockReminderGrams.suzyReminderGram1, MockReminderGrams.suzyReminderGram2, MockReminderGrams.rogerReminderGram1, MockReminderGrams.rogerReminderGram2, MockReminderGrams.neilReminderGram1, MockReminderGrams.neilReminderGram2]
}
