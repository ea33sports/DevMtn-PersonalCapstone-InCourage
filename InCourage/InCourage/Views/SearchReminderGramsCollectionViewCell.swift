//
//  SearchReminderGramsCollectionViewCell.swift
//  InCourage
//
//  Created by Eric Andersen on 11/6/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class SearchReminderGramsCollectionViewCell: UICollectionViewCell {
    
    var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
