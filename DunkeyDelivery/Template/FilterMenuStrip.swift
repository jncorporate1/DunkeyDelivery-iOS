//
//  FilterMenuStrip.swift
//  Template
//
//  Created by Jamil Khan on 8/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class FilterMenuStrip: UIView {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mFilter: UIButton!
    @IBOutlet weak var mCuisine: UIButton!
    
    
    //MARK: - Variables
    
    var view: UIView!
    
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        self.bindEvent()
    }
    

    //MARK: - Helping Method
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func bindEvent(){
        mFilter.addTarget(MainFilterViewController(), action: #selector(MainFilterViewController.mFilterBtnDown(_:)), for: UIControlEvents.touchDown)
        mCuisine.addTarget(MainFilterViewController(), action: #selector(MainFilterViewController.mCuisineBtnDown(_:)), for: UIControlEvents.touchDown)
    }
    
    
    //MARK: - Actions
    
    @IBAction func mCuisineDown(_ sender: Any) {
        mFilter.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
    
    @IBAction func mFilterDown(_ sender: Any) {
        mCuisine.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
    }
}
