//
//  MyOutboxTableViewCell.swift
//  InCourage
//
//  Created by Eric Andersen on 1/9/19.
//  Copyright © 2019 Eric Andersen. All rights reserved.
//

import UIKit

class MyOutboxTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var messagePicImageView: UIImageView!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var messageSubjectLabel: UILabel!
    @IBOutlet weak var messageLoveRatingLabel: UILabel!
    
    

    // MARK: - Properties
    var reminderGram: ReminderGram? {
        didSet {
            updateViews()
        }
    }
    
    
    
    // MARK: - Functions
    func updateViews() {
//        guard let reminderGram = reminderGram else { return }
//        messagePicImageView.image = reminderGram.image
//        senderNameLabel.text = reminderGram.sender.fullName
//        messageSubjectLabel.text = reminderGram.subject
//        messageLoveRatingLabel.text = "❤️\(reminderGram.loveRating)"
    }
    
    
    
    // MARK: - UI Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
