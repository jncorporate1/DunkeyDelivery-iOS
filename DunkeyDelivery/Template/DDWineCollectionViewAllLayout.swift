//
//  DDWineCollectionViewAllLayout.swift
//  Template
//
//  Created by Jamil Khan on 7/31/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDWineCollectionViewAllLayout: UICollectionViewFlowLayout {
    
    //MARK: - View Lifecycle
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    //MARK: - Helping Method
    
    override var itemSize: CGSize {
        set {
        }
        get {
            let numberOfColumns: CGFloat = 3
            let itemWidth = (self.collectionView!.frame.width) / numberOfColumns
            print(itemWidth - 5)
            return CGSize(width: (itemWidth - 5) , height: 150)
        }
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
        scrollDirection = .vertical
    }
}
