//
//  MessageDetailViewController.swift
//  InCourage
//
//  Created by Eric Andersen on 10/31/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var senderProfilePic: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var loveRatingLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var loveRatingStepper: UIStepper!
    
    
    
    // MARK: - Properties
    var reminderGram: ReminderGram?
    
    
    
    // MARK: - UI Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updateLoveRating()
    }
    
    
    
    // MARK: - Functions
    func updateView() {
        
        guard let reminderGram = reminderGram else { return }
//        let profilePic = reminderGram.sender.profilePic
        
        StorageManager.shared.downloadProfileImages(folderPath: "profileImages", success: { (image) in
            DispatchQueue.main.async {
                self.senderProfilePic.image = image
            }
        }) { (error) in
            print(error)
        }
        
        StorageManager.shared.downloadReminderGramImages(folderPath: "reminderGramImages", success: { (image) in
            DispatchQueue.main.async {
                self.messageImage.image = image
            }
        }) { (error) in
            print(error)
        }
        
        Endpoint.database.collection("reminderGrams").document(reminderGram.uid).getDocument { (snapshot, error) in
            
            if let error = error {
                print("🌺 Error fetching reminderGram. \(error) \(error.localizedDescription)")
            }
            
            if let document = snapshot {
                
            }
        }
        
//        senderLabel.text = "From: \(reminderGram.sender.fullName)"
        subjectLabel.text = reminderGram.subject
        loveRatingLabel.text = "❤️\(reminderGram.loveRating)"
        messageTextView.text = reminderGram.message
        
        loveRatingStepper.maximumValue = .infinity
    }
    
    
    func updateLoveRating() {
        guard let reminderGram = reminderGram else { return }
        reminderGram.loveRating = Int(loveRatingLabel.text ?? "") ?? 0
        ReminderGramController.shared.updateReminderGram(reminderGram: reminderGram, newLoveRating: Int(loveRatingLabel.text ?? "") ?? 0)
    }
    
    
    
    // MARK: - Actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loveRatingStepperStepped(_ sender: UIStepper) {
        guard let reminderGram = reminderGram else { return }
        loveRatingLabel.text = "❤️\(reminderGram.loveRating ?? 0 + Int(sender.value))"
    }
}



extension MessageDetailViewController {
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
