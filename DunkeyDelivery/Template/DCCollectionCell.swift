//
//  DCCollectionCell.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
protocol DCCollectionCellDelegate {
    func stepperValueChanged(value:Int, indexPath:IndexPath)
}

@IBDesignable

class DCCollectionCell: UICollectionViewCell {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var view: DCCollectionCellView!
    
    //MARK: - Variables
    
    var delegate : DCCollectionCellDelegate!
    var indexPath:IndexPath!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.delegate = self
    }
}

//MARK: - DCCollectionCellViewDelegate

extension DCCollectionCell: DCCollectionCellViewDelegate{
    func stepperValueChanged(value: Int) {
        delegate.stepperValueChanged(value: value,indexPath: self.indexPath)
    }
}
