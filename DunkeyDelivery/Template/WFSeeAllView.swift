//
//  WFSeeAllView.swift
//  Template
//
//  Created by Jamil Khan on 8/8/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class WFSeeAllView: UIView {
    @IBOutlet weak var divView: UIView!
    @IBOutlet var view: UIView!

    @IBOutlet var selectedTitle: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func seeFilter(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("seeAllFilter"), object: nil)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
        
    }
    
    
    func setTitle(text: String)
    {
        selectedTitle.text = text
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
    

}
