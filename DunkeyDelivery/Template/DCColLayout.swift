//
//  DCColLayout.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DCColLayout: UICollectionViewFlowLayout {
    
    
    //MARK: - View Lifecycle
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    //MARK: - Hepling Method
    
    override var itemSize: CGSize {
        set {
        }
        get {
            let numberOfColumns: CGFloat = 3
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns )) / numberOfColumns
            return CGSize(width: itemWidth - 5 , height: 130)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
        scrollDirection = .vertical
    }
}
