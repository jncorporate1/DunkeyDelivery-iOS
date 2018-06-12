//
//  DDMainFilterTableViewCell.swift
//  Template
//
//  Created by Ingic on 8/7/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DLRadioButton

var PriceRange = [String]()

class DDMainFilterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var radioButtonTwo: DLRadioButton!
    @IBOutlet var curTitle: UILabel!
    @IBOutlet weak var radioButtonOne: DLRadioButton!
    @IBOutlet weak var labelFour: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var starLargeView: DDStarLargeView!
    @IBOutlet weak var specialOfferSwitch: UISwitch!
    @IBOutlet weak var freeDeliverySwitch: UISwitch!
    @IBOutlet weak var newRestaurantSwitch: UISwitch!
    @IBOutlet weak var Sixtymin: DLRadioButton!
    @IBOutlet weak var fourthFivemin: DLRadioButton!
    @IBOutlet weak var tenDollar: DLRadioButton!
    @IBOutlet weak var fifteenDolar: DLRadioButton!
    @IBOutlet weak var twentyDolar: DLRadioButton!
    
    var oneCheck = false
    var twoCheck = false
    var threeCheck = false
    var fourCheck = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func labelFourTapped(_ sender: Any) {
        if !(fourCheck){
            labelFour.backgroundColor = Constants.APP_COLOR
            labelFour.textColor = UIColor.white
            fourCheck = !fourCheck
            PriceRange.append("$$$$")
        }
        else{
            labelFour.backgroundColor = UIColor.white
            labelFour.textColor = UIColor.gray
            fourCheck = !fourCheck
            if let index = PriceRange.index(of: "$$$$") {
                PriceRange.remove(at: index)
            }
        }
    }
    
    @IBAction func labelThreeTapped(_ sender: Any) {
        if !(threeCheck){
            labelThree.backgroundColor = Constants.APP_COLOR
            labelThree.textColor = UIColor.white
            threeCheck = !threeCheck
            PriceRange.append("$$$")
        }
        else{
            labelThree.backgroundColor = UIColor.white
            labelThree.textColor = UIColor.gray
            threeCheck = !threeCheck
            if let index = PriceRange.index(of: "$$$") {
                PriceRange.remove(at: index)
            }
        }
    }
    
    @IBAction func labelOneTapped(_ sender: Any) {
        if !(oneCheck){
            labelOne.backgroundColor = Constants.APP_COLOR
            labelOne.textColor = UIColor.white
            oneCheck = !oneCheck
            PriceRange.append("$")
        }
        else{
            labelOne.backgroundColor = UIColor.white
            labelOne.textColor = UIColor.gray
            oneCheck = !oneCheck
            if let index = PriceRange.index(of: "$") {
                PriceRange.remove(at: index)
            }
        }
    }
    
    @IBAction func labelTwoLabel(_ sender: Any) {
        
        if !(twoCheck){
            labelTwo.backgroundColor = Constants.APP_COLOR
            labelTwo.textColor = UIColor.white
            twoCheck = !twoCheck
            PriceRange.append("$$")
        }
        else{
            labelTwo.backgroundColor = UIColor.white
            labelTwo.textColor = UIColor.gray
            twoCheck = !twoCheck
            if let index = PriceRange.index(of: "$$") {
                PriceRange.remove(at: index)
            }
        }
    }
}
