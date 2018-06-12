//
//  DDWineStoreInfo.swift
//  Template
//
//  Created by Jamil Khan on 7/27/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit




@IBDesignable

class DDWineStoreInfo: UIView {
    
    
    @IBOutlet weak var deliveryTitleLabel: UILabel!
    @IBOutlet weak var deliveryChardesLabel: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var minimumPrice: UILabel!
    
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
        addSubview(view)
    }
    
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
        
    }

    @IBAction func seeDetail(_ sender: Any) {
    }
    
}
