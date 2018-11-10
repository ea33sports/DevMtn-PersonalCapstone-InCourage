//
//  MyMessagesTableViewCell.swift
//  InCourage
//
//  Created by Eric Andersen on 11/5/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class MyMessagesTableViewCell: UITableViewCell {

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
        guard let reminderGram = reminderGram else { return }
        messagePicImageView.image = reminderGram.image
        senderNameLabel.text = "\(reminderGram.receiver.firstName) \(reminderGram.receiver.lastName)"
        messageSubjectLabel.text = reminderGram.subject
        messageLoveRatingLabel.text = "❤️\(reminderGram.loveRating)"
    }
    
    
    
    // MARK: - UI Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
