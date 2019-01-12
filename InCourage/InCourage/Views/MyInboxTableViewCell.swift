//
//  MyInboxTableViewCell.swift
//  InCourage
//
//  Created by Eric Andersen on 11/5/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class MyInboxTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var messagePicImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
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
