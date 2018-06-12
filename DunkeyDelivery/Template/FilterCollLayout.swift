//
//  FilterCollLayout.swift
//  Template
//
//  Created by Jamil Khan on 8/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class FilterCollLayout: UICollectionViewFlowLayout {
    
    
    //MARK: - View Lifecycle
    
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
            return CGSize(width: itemWidth - 10 , height: 30)
        }
    }
    
    //MARK: - Helping Method
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }
}
