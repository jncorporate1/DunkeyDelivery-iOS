//
//  DDWineFilter.swift
//  Template
//
//  Created by Ingic on 8/6/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DLRadioButton

class DDWineFilter: UIView {
    
    @IBOutlet weak var divView: UIView!
    @IBOutlet weak var bestSellingButton: DLRadioButton!
    @IBOutlet weak var priceLowToHigh: DLRadioButton!
    @IBOutlet weak var nameAtoZ: DLRadioButton!
    @IBOutlet weak var nameZtoA: DLRadioButton!
    @IBOutlet weak var priceHighToLow: DLRadioButton!
    
    
    @IBOutlet  var showAllBtn: UIButton!
    
    var view: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        let selectedButton = AppStateManager.sharedInstance.sortByState
       if selectedButton == "  Price:Low to high" {priceLowToHigh.isSelected = true}
       if selectedButton ==  "  Price:High to low" {priceHighToLow.isSelected = true}
       if selectedButton ==  "  Name:Z to A" {nameZtoA.isSelected = true}
       if selectedButton ==  "  Name:A to Z" {nameAtoZ.isSelected = true}
       if selectedButton ==  "  Best selling" {bestSellingButton.isSelected = true}
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
        
    }
    
    @IBAction func showAll(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showAllDown"), object: nil)
    }
    
    @IBAction func btnDow(_ sender: Any) {
        var btn = sender as! DLRadioButton
        let imageDataDict:[String: String] = ["text": (btn.titleLabel?.text)!]
        AppStateManager.sharedInstance.sortByState = (btn.titleLabel?.text)!
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentTitle"), object: nil, userInfo: imageDataDict)
    }
}
