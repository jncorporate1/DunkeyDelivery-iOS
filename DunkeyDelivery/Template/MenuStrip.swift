//
//  MenuStrip.swift
//  Template
//
//  Created by Jamil Khan on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit



class MenuStrip: UIView {
    
    //MARK: - IBOutlet
    
    @IBOutlet  var mWine: UIButton!
    @IBOutlet  var mBeer: UIButton!
    @IBOutlet  var mLiquor: UIButton!
    @IBOutlet  var parentView: UIView!
    
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
    
    func wineBtnInstance() -> UIButton{
        return mWine
    }
    
    func bindEvent(){
        mWine.addTarget(WineDetailViewController(), action: #selector(WineDetailViewController.mWineBtnDown(_:)), for: UIControlEvents.touchDown)
        mBeer.addTarget(WineDetailViewController(), action: #selector(WineDetailViewController.mBeerBtnDown(_:)), for: UIControlEvents.touchDown)
        mLiquor.addTarget(WineDetailViewController(), action: #selector(WineDetailViewController.mLiquorBtnDown(_:)), for: UIControlEvents.touchDown)
    }
    
    func mWineSelected(){
        mWine.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
    
    func mLiquorSelected(){
        mLiquor.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
    
    func mBeerSelected(){
        mBeer.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
    
    func toggleButtonColor(_ id : Int){
        switch id {
        case 0:
            mWine.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mBeer.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
            mLiquor.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            break
        case 1:
            mWine.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mBeer.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mLiquor.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
            break
        case 2:
            mWine.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
            mBeer.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mLiquor.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            break
        default:
            mWine.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mBeer.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            mLiquor.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
    }
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
        toggleButtonColor(3)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    //MARK: - Actions
    
    @IBAction func mBeerDown(_ sender: Any) {
        toggleButtonColor(0)
    }
    
    @IBAction func mLiquorDown(_ sender: Any) {
        toggleButtonColor(1)
    }
    
    @IBAction func mWineDown(_ sender: Any) {
        toggleButtonColor(2)
    }
}
