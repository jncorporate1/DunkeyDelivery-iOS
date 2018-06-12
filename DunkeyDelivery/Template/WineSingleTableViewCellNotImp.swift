//
//  WineSingleCollectionViewCellNotImp.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import GMStepper
import DLRadioButton

class WineSingleTableViewCellNotImp: UITableViewCell {
    
    
    //MARK: - IBoutlet
    
    //Cell 1
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    //Cell 2
    @IBOutlet weak var productSizePrice: UILabel!
    @IBOutlet weak var productSizeName: UILabel!
    @IBOutlet weak var radioButtonOutlet: UIButton!
    @IBOutlet weak var radioButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var productSizeNameLeading: NSLayoutConstraint!
    
    //Cell 4
    @IBOutlet weak var stepper: GMStepper!
    //Cell 5
    @IBOutlet weak var totalPriceLabel: UILabel!
    //Cell 8 
    @IBOutlet weak var seeMoreButton: UIButton!
    
    //MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: - Helping Method
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setStepperFont(){
        let lblFont = UIFont(name: "Helvetica-Light", size: 12)
        stepper.labelFont = lblFont!
    }
    
    func setButtonSelected(){
        radioButtonOutlet.setImage(#imageLiteral(resourceName: "radio_button_selected"), for: .normal)
    }
    
    func setButtonUnSelected(){
        radioButtonOutlet.setImage(#imageLiteral(resourceName: "radio_button"), for: .normal)
    }
    
    func setTotalPrice(_ valueItem: String){
        totalPriceLabel.text = valueItem
    }
    
    func setStepperInitialState(){
        stepper.value = 0
    }
    
    //MARK: - Action
    
    @IBAction func radioButtonAction(_ sender: Any) {
    }
}
