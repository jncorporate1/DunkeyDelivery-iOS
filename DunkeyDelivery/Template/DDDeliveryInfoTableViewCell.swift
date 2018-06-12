//
//  DDDeliveryInfoTableViewCell.swift
//  Template
//
//  Created by Ingic on 8/14/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDDeliveryInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var addressRadioButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setButtonSelected(){
        addressRadioButton.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
    }
    
    func setButtonUnSelected(){
       addressRadioButton.setImage(#imageLiteral(resourceName: "radio_button"), for: .normal)
    }
}
