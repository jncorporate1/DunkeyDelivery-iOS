//
//  tabSummaryView.swift
//  Template
//
//  Created by Ingic on 7/6/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
@IBDesignable
class tabSummaryView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var viewTapped: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    
    //MARK: - Variables
    
    var view: UIView!
    var uiColorArray = [UIColor]()
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    //MARK: - HelpingMethod
    
    func setMenuItem(color: UIColor, title: String, icon: String){
        backgroundView.backgroundColor = color
        menuTitle.text = title
        menuIcon.image = UIImage(named: icon)
    }
    
    func xibSetup(){
        backgroundColor = .clear
        setColorArray()
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    func setColorArray(){
        self.uiColorArray.append(.red)
        self.uiColorArray.append(.black)
        self.uiColorArray.append(.white)
        self.uiColorArray.append(.blue)
        self.uiColorArray.append(.red)
        self.uiColorArray.append(.gray)
        self.uiColorArray.append(.green)
    }
    
    func buttonTapped(sender: UIButton){
        print(sender.tag)
        self.tag = sender.tag
        self.setView(sender: self)
    }
    
    func setView(sender: tabSummaryView){
        for i in 0...7 {
            if i == sender.tag{
                sender.backgroundView.backgroundColor = self.uiColorArray[sender.tag]
                sender.menuTitle.textColor = UIColor.white
            }
            else{
                // sender.backgroundView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
                // sender.menuTitle.textColor = UIColor.black
            }
        }
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
