//
//  DDWineCollectionViewLayout.swift
//  Template
//
//  Created by Jamil Khan on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDWineCollectionViewLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 2
            
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width: 120 , height: 120)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .horizontal
    }
}
