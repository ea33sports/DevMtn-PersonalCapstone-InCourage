//
//  MessageDetailViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/31/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseStorage

class MessageDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var senderProfilePic: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var loveRatingView: UIView!
    @IBOutlet weak var loveRatingLabel: UILabel!
    @IBOutlet weak var loveRatingStepper: UIStepper!
    
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram?
    var senderUser: User?
    var receiverUser: User?
    var theLoveRating = 0
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        saveLoveRating()
    }
    
    
    
    // MARK: - Functions
    func updateView() {
        
        guard let reminderGram = reminderGram else { return }
        
        downloadReminderGramImage(folderPath: "reminderGramImages", success: { (image) in
            self.messageImage.image = image
        }) { (error) in
            print(error, error.localizedDescription)
        }
        
        if let receiver = receiverUser {
            downloadProfileImage(folderPath: "profileImages", user: receiver.uid, success: { (image) in
                DispatchQueue.main.async {
                    self.senderProfilePic.image = image
                }
            }) { (error) in
                print(error)
            }
            senderLabel.text = "To: \(receiver.username)"
            
        } else if let sender = senderUser {
            downloadProfileImage(folderPath: "profileImages", user: sender.uid, success: { (image) in
                DispatchQueue.main.async {
                    self.senderProfilePic.image = image
                }
            }) { (error) in
                print(error)
            }
            senderLabel.text = "From: \(sender.username)"
        }
        
        subjectLabel.text = reminderGram.subject
        loveRatingLabel.text = "❤️ \(reminderGram.loveRating)"
        messageTextView.text = reminderGram.message
        
        loveRatingStepper.minimumValue = Double(reminderGram.loveRating - (reminderGram.loveRating * 2))
        loveRatingStepper.maximumValue = .infinity
    }
    
    
    func downloadProfileImage(folderPath: String, user: String, success: @escaping (_ image: UIImage) -> (), failure: @escaping (_ error: Error) -> ()) {
        
        let reference = Storage.storage().reference(withPath: "profileImages").child(user).child("profilePic.png")
        
        // Create a reference with an initial file path and name
       
        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
            if let _error = error{
                print(_error)
                failure(_error)
            } else {
                if let _data  = data {
                    let myImage: UIImage! = UIImage(data: _data)
                    success(myImage)
                }
            }
        }
    }
    
    
    func fetchSender(id: String, completion: @escaping (User) -> Void) {
        
        guard let reminderGram = reminderGram else { fatalError() }
        Endpoint.database.collection("users").document(reminderGram.sender).getDocument { (snapshot, error) in
            
            if let error = error {
                print("😤 Error getting user \(error) \(error.localizedDescription)")
            }
            
            if let document = snapshot {
                guard let userDictionary = document.data(),
                    let sender = User(userDictionary: userDictionary) else { fatalError() }
                completion(sender)
            }
        }
    }
    
    
    func fetchReceiver(id: String, completion: @escaping (User) -> Void) {
        
        guard let reminderGram = reminderGram else { fatalError() }
        Endpoint.database.collection("users").document(reminderGram.receiver).getDocument { (snapshot, error) in
            
            if let error = error {
                print("😤 Error getting user \(error) \(error.localizedDescription)")
            }
            
            if let document = snapshot {
                guard let userDictionary = document.data(),
                    let receiveree = User(userDictionary: userDictionary) else { fatalError() }
                completion(receiveree)
            }
        }
    }
    
    
    func downloadReminderGramImage(folderPath: String, success: @escaping (_ image: UIImage) -> (),failure: @escaping (_ error:Error) -> ()) {
        
        guard let reminderGram = reminderGram else { return }
        
        // Create a reference with an initial file path and name
        let reference = Storage.storage().reference(withPath: "reminderGramImages").child("\(reminderGram.uid).png")
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
    
    
    func updateLoveRating() {
        guard let reminderGram = reminderGram else { return }
        let loveRating = reminderGram.loveRating
        let loveDifference = Int(loveRatingStepper.value)
        let updatedLoveRating = loveRating + loveDifference
        loveRatingLabel.text = "❤️ \(updatedLoveRating)"
        theLoveRating = updatedLoveRating
    }
    
    
    func saveLoveRating() {
        guard let reminderGram = reminderGram else { return }
        reminderGram.loveRating = theLoveRating
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).updateData(["loveRating" : reminderGram.loveRating])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loveRatingStepperStepped(_ sender: UIStepper) {
        updateLoveRating()
    }
}
