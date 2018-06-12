//
//  WStoreInfoChangeTC.swift
//  Template
//
//  Created by Jamil Khan on 8/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DLRadioButton
class WStoreInfoChangeTC: UITableViewCell {
    
    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeRatingView: DDStarView!
    @IBOutlet weak var deliveryFeeLabel: UILabel!
    @IBOutlet weak var minOrderPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var isCellSelected = Bool()
//    @IBOutlet weak var radioButton: DLRadioButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateCellUI(){
        
        if(self.isCellSelected){
            self.setButtonSelected()
            self.isCellSelected = false
        }else{
            self.deselectButton()
            self.isCellSelected = true
        }
        
    }
    
    func setButtonSelected(){
        radioButton.isSelected = true

    }
    func deselectButton(){
        radioButton.isSelected = false

    }
}
