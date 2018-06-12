//
//  DCMenuStrip.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DCMenuStrip: UIView {
    
    //MARK: -  IBOutlets
    
    @IBOutlet weak var mEntireLoad: UIButton!
    @IBOutlet weak var mItemize: UIButton!
    
    //MARK: - Varialbes
    
    var view: UIView!
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    //MARK: - Helping Method
    
    func selection(_ btn: UIButton){
        self.unSelect()
        btn.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
    
    func unSelect(){
        mEntireLoad.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        mItemize.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        self.mEntireLoad.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    //MARK: - Actions
    
    @IBAction func itemizeDown(_ sender: Any) {
        let btn = sender as! UIButton
        self.selection(btn)
        NotificationCenter.default.post(name: Notification.Name("itemizeDown"), object: nil)
    }
    
    @IBAction func entireLoadDown(_ sender: Any) {
        let btn = sender as! UIButton
        self.selection(btn)
        NotificationCenter.default.post(name: Notification.Name("entireLoadDown"), object: nil)
    }
}
