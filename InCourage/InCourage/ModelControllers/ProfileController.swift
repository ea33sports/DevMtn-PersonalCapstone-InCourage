//
//  ProfileController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/30/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation

class ProfileController {
    
    // MARK: - Initialization
    static let shared = ProfileController()
    private init() {}
    
    
    
    // MARK: - Source of Truth
    var currentProfile: Profile?
    var currentProfileUID: String?
    
    
    
    // MARK: - Properties
    let currentUserWasSetNotification = Notification.Name("currentUserSet")
    var isUserLoggedIn = false
    
    
    
    // MARK: - CRUD
    func createProfile(uid: String) {
        let profile = Profile(uid: uid, profilePic: "", lifePerspective: "In 10 words or less...", loveRating: 0, reminderGramIDs: [])
        currentProfile = profile
        currentProfileUID = uid
        
        guard let currentProfile = self.currentProfile else { fatalError() }
        saveToPersistentStorage()
        Endpoint.database.collection("profiles").document(currentProfile.uid).setData(currentProfile.firebaseDictionary)
    }
    
    
    
    // MARK: - Fetching
    func fetchCurrentProfile(completion: @escaping (Bool) -> Void) {
        guard let currentProfileUID = currentProfileUID else { fatalError() }
        Endpoint.database.collection("profiles").document(currentProfileUID).getDocument { (snapshot, error) in
            if let error = error {
                print("🎩 Error fetching user \(error) \(error.localizedDescription)")
                completion(false)
                return
            }

            if let document = snapshot {
                guard let profileDictionary = document.data() else { return }
                self.currentProfile = Profile(profileDictionary: profileDictionary)!
                print("✅ Successfully Fetched logged in user! 🐩\(currentProfileUID)")
                completion(true)
            }
        }
    }
    
    
    
    // MARK: - Local Persistence
    func fileURL() -> URL {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = path[0]
        let fileName = "profile.json"
        let fullURL = documentsDirectory.appendingPathComponent(fileName)
        
        return fullURL
    }
    
    func saveToPersistentStorage() {
        
        guard let currentProfileUID = currentProfileUID else { return }
        do {
            let originalString = currentProfileUID
            let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            try escapedString?.write(to: fileURL(), atomically: true, encoding: .utf8)
        } catch {
            print("💩 There was an error Saving to the Persistent Store \(error): \(error.localizedDescription) 💩")
        }
    }
    
    func loadFromPersistentStorage(completion: @escaping (Bool) -> Void){
        
        do {
            let uid = try String(contentsOf: fileURL(), encoding: .utf8)
            currentProfileUID = uid
            completion(true)
        } catch {
            completion(false)
            print("💩 There was an error Loading from the Persistent Store \(error): \(error.localizedDescription) 💩")
            return
        }
    }
}
