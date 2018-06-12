//
//  CustomProgressBar.swift
//  Template
//
//  Created by Jamil Khan on 8/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
@IBDesignable
class CustomProgressBar: UIView {

    
    var view: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var count: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
        //viewProg.layer.cornerRadius = viewCornerRadius
        //drawProgressLayer()
        //self.rectProgress(incremented: 80)
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
    func setProgress(value: Int, progValue: Float){
        self.progressBar.progress = progValue
    }
    

}
