//
//  DDHomeFlowLayout.swift
//  Template
//
//  Created by Ingic on 7/7/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDHomeFlowLayout: UICollectionViewFlowLayout {
    
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
            return CGSize(width: 140 , height: 170)
        }
    }
    
    //MARK: - Helping Method
    
    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .horizontal
    }
}

