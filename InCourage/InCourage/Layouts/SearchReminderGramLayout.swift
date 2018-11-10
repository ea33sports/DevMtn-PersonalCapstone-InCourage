//
//  SearchReminderGramLayout.swift
//  InCourage
//
//  Created by Eric Andersen on 11/8/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class SearchReminderGramLayout: UICollectionViewFlowLayout {
    
    let innerSpace: CGFloat = 1.0
    let numberOfCellsOnRow: CGFloat = 2
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace
    }
    
    func itemHeight() -> CGFloat {
        return ((collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace) * 1.5
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight())
        }
        get {
            return CGSize(width: itemWidth(),height: itemHeight())
        }
    }
}
