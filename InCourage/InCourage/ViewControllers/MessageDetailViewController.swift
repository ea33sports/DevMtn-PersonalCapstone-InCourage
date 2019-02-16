//
//  MessageDetailViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/31/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit
import FirebaseStorage

@IBDesignable
class MessageDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var imageInfoBackgroundLayer: UIView!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var loveRatingView: UIView!
    @IBOutlet weak var loveRatingLabel: UILabel!
    @IBOutlet weak var loveRatingStepper: UIStepper!
    
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram?
    var theLoveRating = 0
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setUpUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        saveLoveRating()
    }
    
    
    
    // MARK: - Functions
    func setUpUI() {
        
        imageContainer.layer.shadowColor = UIColor.black.cgColor
        imageContainer.layer.shadowOpacity = 1
        imageContainer.layer.shadowOffset = CGSize.zero
        imageContainer.layer.shadowRadius = 10
        imageContainer.layer.cornerRadius = imageContainer.frame.height / 8
        imageContainer.clipsToBounds = false
        
        messageImage.layer.borderWidth = 1
        messageImage.layer.masksToBounds = false
        messageImage.layer.borderColor = UIColor.clear.cgColor
        messageImage.layer.cornerRadius = messageImage.frame.height / 8
        messageImage.clipsToBounds = true
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = imageInfoBackgroundLayer.frame
        rectShape.position = imageInfoBackgroundLayer.center
        rectShape.path = UIBezierPath(roundedRect: imageInfoBackgroundLayer.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: (imageInfoBackgroundLayer.frame.width / 8), height: (messageImage.frame.height / 8))).cgPath

        imageInfoBackgroundLayer.layer.mask = rectShape
    }
    
    
    func updateView() {
        
        UIApplication.shared.statusBarView?.backgroundColor = .clear
        
        subjectTextField.delegate = self
        subjectTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        messageTextView.delegate = self
        
        guard let reminderGram = reminderGram else { return }
        
        StorageManager.shared.downloadReminderGramImage(folderPath: "reminderGramImages", uid: reminderGram.uid, success: { (image) in
            self.messageImage.image = image
        }) { (error) in
            print(error, error.localizedDescription)
        }
        
        subjectTextField.text = reminderGram.subject
        subjectTextField.sizeToFit()
        loveRatingLabel.text = "❤️ \(reminderGram.loveRating)"
        loveRatingLabel.sizeToFit()
        messageTextView.delegate = self
        messageTextView.text = reminderGram.message
        
        theLoveRating = reminderGram.loveRating
        
        loveRatingStepper.minimumValue = Double(reminderGram.loveRating - (reminderGram.loveRating * 2))
        loveRatingStepper.maximumValue = .infinity
        
        
        
//        if let receiver = receiverUser {
//            downloadProfileImage(folderPath: "profileImages", user: receiver.uid, success: { (image) in
//                DispatchQueue.main.async {
//                    self.senderProfilePic.image = image
//                }
//            }) { (error) in
//                print(error)
//            }
//            senderLabel.text = "To: \(receiver.username)"
//
//        } else if let sender = senderUser {
//            downloadProfileImage(folderPath: "profileImages", user: sender.uid, success: { (image) in
//                DispatchQueue.main.async {
//                    self.senderProfilePic.image = image
//                }
//            }) { (error) in
//                print(error)
//        }
//            senderLabel.text = "From: \(sender.username)"
//        }
    }
    
    
//    func downloadProfileImage(folderPath: String, user: String, success: @escaping (_ image: UIImage) -> (), failure: @escaping (_ error: Error) -> ()) {
//
//        let reference = Storage.storage().reference(withPath: "profileImages").child(user).child("profilePic.png")
//
//        // Create a reference with an initial file path and name
//
//        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
//            if let _error = error{
//                print(_error)
//                failure(_error)
//            } else {
//                if let _data  = data {
//                    let myImage: UIImage! = UIImage(data: _data)
//                    success(myImage)
//                }
//            }
//        }
//    }
    
    
//    func fetchSender(id: String, completion: @escaping (User) -> Void) {
//
//        guard let reminderGram = reminderGram else { fatalError() }
//        Endpoint.database.collection("users").document(reminderGram.sender).getDocument { (snapshot, error) in
//
//            if let error = error {
//                print("😤 Error getting user \(error) \(error.localizedDescription)")
//            }
//
//            if let document = snapshot {
//                guard let userDictionary = document.data(),
//                    let sender = User(userDictionary: userDictionary) else { fatalError() }
//                completion(sender)
//            }
//        }
//    }
//
//
//    func fetchReceiver(id: String, completion: @escaping (User) -> Void) {
//
//        guard let reminderGram = reminderGram else { fatalError() }
//        Endpoint.database.collection("users").document(reminderGram.receiver).getDocument { (snapshot, error) in
//
//            if let error = error {
//                print("😤 Error getting user \(error) \(error.localizedDescription)")
//            }
//
//            if let document = snapshot {
//                guard let userDictionary = document.data(),
//                    let receiveree = User(userDictionary: userDictionary) else { fatalError() }
//                completion(receiveree)
//            }
//        }
//    }
    
    
//    func downloadReminderGramImage(folderPath: String, success: @escaping (_ image: UIImage) -> (),failure: @escaping (_ error:Error) -> ()) {
//
//        guard let currentProfile = ProfileController.shared.currentProfile,
//            let reminderGram = reminderGram else { return }
//
//        // Create a reference with an initial file path and name
//        let reference = Storage.storage().reference(withPath: "reminderGramImages").child(currentProfile.uid).child("\(reminderGram.uid).png")
//        reference.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
//            if let _error = error{
//                print(_error)
//                failure(_error)
//            } else {
//                if let _data  = data {
//                    let myImage:UIImage! = UIImage(data: _data)
//                    success(myImage)
//                }
//            }
//        }
//    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveChanges()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        saveChanges()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func updateLoveRating(value: Int) {
        guard let reminderGram = reminderGram else { return }
        let loveRating = theLoveRating
        let updatedLoveRating = loveRating + value
        loveRatingLabel.text = "❤️ \(updatedLoveRating)"
        reminderGram.loveRating = updatedLoveRating
    }
    
    
    func saveLoveRating() {
        guard let reminderGram = reminderGram else { return }
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).updateData(["loveRating" : reminderGram.loveRating])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    
    func saveChanges() {
        guard let reminderGram = reminderGram,
            let subjectText = subjectTextField.text,
            let messageText = messageTextView.text
            else { return }
        
        ReminderGramController.shared.updateReminderGram(reminderGram: reminderGram, newSubject: subjectText, newMessage: messageText, newLoveRating: reminderGram.loveRating)
    }
    
    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loveRatingStepperStepped(_ sender: UIStepper) {
        updateLoveRating(value: Int(sender.value))
    }
}
