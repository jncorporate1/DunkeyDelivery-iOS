//
//  WineFilterSort.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DLRadioButton

class WineFilterSort: UIView {

    @IBOutlet weak var distanceButton: DLRadioButton!
    var view: UIView!
    
    @IBOutlet  var showAllBtn: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @IBAction func btnDown(_ sender: Any) {
        var btn = sender as! DLRadioButton
        let imageDataDict:[String: String] = ["text": (btn.titleLabel?.text)!]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentTitle"), object: nil, userInfo: imageDataDict)
    }
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        distanceButton.isSelected = true
        addSubview(view)
    }
    
    @IBAction func showAll(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("showAllDown"), object: nil)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
