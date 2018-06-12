//
//  DDProductTableViewCell.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import GMStepper
protocol DDProductCellDelegate {
    func stepperValueUpdate(value: Int)
   // func sendDeliverytype (_ value: Int)
}

class DDProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var quantityStepper: GMStepper!
    @IBOutlet weak var addToBagButton: UIButton!
    @IBOutlet weak var specialInstructionsTextView: UITextView!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productDetail: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var storeProductName: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var priceViewHide: UIView!
    @IBOutlet weak var seeMoreButtonOutlet: UIButton!
    
    var delegate : DDProductCellDelegate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func viewEssentials(){
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    func resetQuantity(){
        quantityStepper.value = 0
    }
    
    func stepperValueChanged(){
        delegate.stepperValueUpdate(value: Int(quantityStepper.value))
    }
    
    func setUpTextView(){
        self.specialInstructionsTextView.text = "Add Special Instructions"
        self.specialInstructionsTextView.placeholderText = "Add Special Instructions"
        self.specialInstructionsTextView.textColor = UIColor.lightGray
        self.specialInstructionsTextView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func changeButton(index: Int){
      /*  switch index {
        case 0:
           self.homeButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.customButton.backgroundColor = UIColor.white
            self.workButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.black, for: .normal)
            self.customButton.setTitleColor(UIColor.black, for: .normal)
            self.homeButton.setTitleColor(UIColor.white, for: .normal)
            frequency = "Home"
            sendDeliverytype(0)
         
        case 1:
            self.workButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.customButton.backgroundColor = UIColor.white
            self.homeButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.white, for: .normal)
            self.customButton.setTitleColor(UIColor.black, for: .normal)
            self.homeButton.setTitleColor(UIColor.black, for: .normal)
            frequency = "Work"
            sendDeliverytype(1)
         
        case 2:
            self.customButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.workButton.backgroundColor = UIColor.white
            self.homeButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.black, for: .normal)
            self.customButton.setTitleColor(UIColor.white, for: .normal)
            self.homeButton.setTitleColor(UIColor.black, for: .normal)
            frequency = "Custom"
            sendDeliverytype(2)
         
        default:
            break
        }*/
    }

}
extension DDProductTableViewCell: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Special Instructions"
            textView.textColor = UIColor.lightGray
        }
    }
}
