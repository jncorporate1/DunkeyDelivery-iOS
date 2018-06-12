//
//  WineFilterViewMore.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit


class WineFilterViewMore: UIView {

    @IBOutlet var viewMoreArrow: UIButton!
    @IBOutlet var viewMore: UIButton!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    
    var isSeeMore : Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()

        
    }
    
   
    
    @IBAction func isSeeMoreDown(_ sender: Any) {
       
        self.seeMore()
    }
    
    @IBAction func seeMoreArrowDown(_ sender: Any) {
        self.seeMore()

    }
    
    
    
    func seeMore()
    {
                
        NotificationCenter.default.post(name: Notification.Name("seeMoreDown"), object: nil)
    }
    
    @IBOutlet var view: UIView!
    
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

}
