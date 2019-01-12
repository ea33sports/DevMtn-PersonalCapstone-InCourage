
//  StoreManager.swift
//  InCourage
//
//  Created by Eric Andersen on 11/13/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class StorageManager {
    
    static let shared = StorageManager()
    
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram?
    
    
    
    // MARK: - Data
    // Upload
    func uploadData(toStoragePath storagePath: String, uploadData: Data, completion: @escaping (_ success: Bool) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        Endpoint.storageRef.child(storagePath).putData(uploadData, metadata: metaData) { (storageMetaData, error) in
            if let error = error {
                print("Error upload data to storage path: \(storagePath) \(error) \(error.localizedDescription)")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
    // Download
    func downloadData(atStoragePath storagePath: String, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        
        Endpoint.storageRef.child(storagePath).downloadURL { (downloadURL, error) in
            if let error = error {
                print("Error downloading data to storage path: \(storagePath) \(error) \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            if let url = downloadURL {
                completion(url, error)
            }
        }
    }
    
    
    
    // MARK: - Image
    // Upload
//    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
//
//        guard let currentUser = UserController.shared.currentUser else { return }
//
//        if let data = image.jpegData(compressionQuality: 0.4) {
//
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            let profileImageStoragePath = Storage.storage().reference(withPath: "profileImages").child("\(currentUser.uid)").child("profilePic.png")
//            let metaData = StorageMetadata()
//            metaData.contentType = "image/jpeg"
//            profileImageStoragePath.putData(data, metadata: metaData) { (_, error) in
//                if let error = error {
//                    print(error)
//                    completion(nil)
//                    return
//                }
//            }
//
//            profileImageStoragePath.downloadURL { (url, error) in
//                guard let url = url else { fatalError() }
//                completion(url)
//            }
//        }
//    }
    
    func uploadProfileImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        if let data = image.jpegData(compressionQuality: 0.4) {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let profileImageStoragePath = Storage.storage().reference(withPath: "profileImages").child("\(currentUser.uid)").child("profilePic.png")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            profileImageStoragePath.putData(data, metadata: metaData) { (metadata, error) in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                profileImageStoragePath.downloadURL { (url, error) in
                    guard let url = url else { fatalError() }
                    completion(url)
                }
            }
        }
    }
    
    
    func uploadReminderGramImage(_ image: UIImage, completion: @escaping (URL?) -> Void) {
        
        guard let reminderGram = reminderGram else { return }
        if let data = image.jpegData(compressionQuality: 0.4) {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let reminderGramImageStoragePath = Storage.storage().reference(withPath: "reminderGramImages").child("\(reminderGram.uid)")
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            reminderGramImageStoragePath.putData(data, metadata: metaData) { (_, error) in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
            }
            
            reminderGramImageStoragePath.downloadURL { (url, error) in
                guard let url = url else {return}
                completion(url)
            }
        }
    }
    
    
//    func uploadReminderGramImage(_ image: UIImage, toStorage storage: StorageReference, completion: @escaping (URL?) -> Void) {
//
//        if let data = image.jpegData(compressionQuality: 0.4) {
//
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            let reminderGramImageStoragePath = storage.child(UUID().uuidString).fullPath
//            uploadData(toStoragePath: reminderGramImageStoragePath, uploadData: data) { (success) in
//                if !success {
//                    print("Unable to upload image to storage at path: \(reminderGramImageStoragePath)")
//                } else {
//                    storage.child("reminderGramImages").downloadURL(completion: { (url, error) in
//                        completion(url)
//                    })
//                }
//            }
//        }
//    }
    
    
//    func uploadProfileImage(_ image: UIImage, toStorage storage: StorageReference, completion: @escaping (URL?) -> Void) {
//
//        if let data = image.jpegData(compressionQuality: 0.4) {
//
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            let profileImageStoragePath = storage.child(UUID().uuidString).fullPath
//            uploadData(toStoragePath: profileImageStoragePath, uploadData: data) { (success) in
//                if !success {
//                    print("Unable to upload image to storage at path: \(profileImageStoragePath)")
//                } else {
//                    storage.child("profileImages").downloadURL(completion: { (url, error) in
//                        completion(url)
//                        if let error = error {
//                            print(error)
//                        }
//                        print("🌚 \(url)")
//                    })
//                }
//            }
//        }
//    }
    
    
//    func uploadProfileImage(_ image: UIImage, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
//
//        let storage = Storage.storage()
//        let storageReference = storage.reference()
//
//        // storage/profileImages/image.jpg
//        let imageName = "\(UUID().uuidString).jpg"
//        let imagesReference = storageReference.child("profileImages").child(imageName)
//
//        if let imageData = image.jpegData(compressionQuality: 0.4) {
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//
//            let uploadTask = imagesReference.putData(imageData, metadata: metadata) { (metadata, error) in
//                if let error = error {
//                    print("\(error) \(error.localizedDescription)")
//                }
//
//                if let metadata = metadata {
//                    completionBlock(metadata.downloadURL(), nil)
//                } else {
//                    completionBlock(nil, error?.localizedDescription)
//                }
//            }
//        } else {
//            completionBlock(nil, "Image couldn't be convertd to Data.")
//        }
//    }
    
    
    // Download
    func downloadProfileImages(folderPath: String, success: @escaping (_ image:UIImage) -> (), failure: @escaping (_ error:Error) -> ()) {
        
        guard let currentUser = UserController.shared.currentUser else { return }
        
        // Create a reference with an initial file path and name
        let reference = Storage.storage().reference(withPath: "profileImages").child("\(currentUser.uid)").child("profilePic.png")
        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
    
    
    func downloadReminderGramImages(folderPath:String, success:@escaping (_ image:UIImage) -> (),failure: @escaping (_ error:Error) -> ()) {
        
        guard let reminderGram = reminderGram else { return }
        
        // Create a reference with an initial file path and name
        let reference = Storage.storage().reference(withPath: "reminderGramImages").child("\(reminderGram.uid)").child("\(reminderGram.subject).png")
        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage:UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
    
    
//    func fetchImageWithUrlString(urlString: String, completion: @escaping (_ success: UIImage?)->Void) {
//        guard let url = URL(string: urlString) else {return}
//        var image: UIImage?
//        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let error = error {
//                print ("💩💩 error in file \(#file), function \(#function), \(error),\(error.localizedDescription)💩💩")
//                completion(nil)
//                return
//            }
//
//            if let data = data {
//                image = UIImage(data: data)
//                completion(image)
//                print("🎅🏽\(image)")
//            }
//        }).resume()
//    }

    
    
//    func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
//        let ref = Storage.storage().reference(forURL: url.absoluteString)
//        let megaByte = Int64(1 * 1024 * 1024)
//
//        ref.getData(maxSize: megaByte) { (data, error) in
//            guard let imageData = data else { completion(nil); return }
//            completion(UIImage(data: imageData))
//        }
//    }
    
    
}
