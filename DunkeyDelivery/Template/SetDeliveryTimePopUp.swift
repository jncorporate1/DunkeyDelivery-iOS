//
//  SetDeliveryTimePopUp.swift
//  Template
//
//  Created by Ingic on 13/03/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
protocol deliveryTimePopUpDelegate {
    func dateButtonTapped()
    func timeButtonTapped()
    func submitButtonTapped()
    func asapButtonTapped(_ value: Int)
    func todayButonTapped(_ value: Int)
    func laterButtonTapped(_ value: Int)
}

class SetDeliveryTimePopUp: UIView {

    //MARK: - IBOutlets
    
    @IBOutlet weak var baseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var asapButtonOutlet: UIButton!
    @IBOutlet weak var todayButtonOutlet: UIButton!
    @IBOutlet weak var laterButtonOutlet: UIButton!
    @IBOutlet weak var showDateText: UILabel!
    @IBOutlet weak var showTimeText: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var selectTimeTapped: UIButton!
    @IBOutlet weak var selectDateTapped: UIButton!
    @IBOutlet weak var submitButtonTapped: UIButton!
    @IBOutlet weak var Line3Outlet: UIView!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var Line1: UIView!
    @IBOutlet weak var Line2: UIView!
    @IBOutlet weak var Line3: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    
    //MARK: - Varaiable
    
    var view: UIView!
    var delegate : deliveryTimePopUpDelegate!
  
    
    //MARK:- View Lifecycle
    
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
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        viewEssentials()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        addSubview(view)
    }
 
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    
    //MARK: - Helping Method
    
    func viewEssentials(){
        setAsapView()
        asapButtonOutlet.isHidden = true
        todayButtonOutlet.isHidden = true
        laterButtonOutlet.isHidden = true
    }
    
    func setAsapView(){
        baseViewHeight.constant = 180 // 200
        timeView.isHidden = true
        dateView.isHidden = true
        Line3.isHidden = true
        Line2.isHidden = true
        Line1.isHidden = false
    }
    
    func setTodayView(){
        baseViewHeight.constant = 240//251.5
        timeView.isHidden = false
        dateView.isHidden = true
        Line3.isHidden = true
        Line2.isHidden = false
        Line1.isHidden = false
    }
    
    func setLaterView(){
        baseViewHeight.constant = 303
        timeView.isHidden = false
        dateView.isHidden = false
        Line3.isHidden = false
        Line2.isHidden = false
        Line1.isHidden = false
    }
    
    func changeButton(index: Int){
        switch index {
        case 0:
            asapButtonOutlet.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            todayButtonOutlet.backgroundColor = UIColor.white
            laterButtonOutlet.backgroundColor = UIColor.white
            laterButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            todayButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            asapButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            
        case 1:
            todayButtonOutlet.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            asapButtonOutlet.backgroundColor = UIColor.white
            laterButtonOutlet.backgroundColor = UIColor.white
            todayButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            asapButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            laterButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            
        case 2:
            laterButtonOutlet.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            todayButtonOutlet.backgroundColor = UIColor.white
            asapButtonOutlet.backgroundColor = UIColor.white
            asapButtonOutlet.setTitleColor(UIColor.black, for: .normal)
            laterButtonOutlet.setTitleColor(UIColor.white, for: .normal)
            todayButtonOutlet.setTitleColor(UIColor.black, for: .normal)
        default:
            break
        }
    }
    
    
    func setFirstTimeDate(){
    }
    
    func setTimeFirst(){
    }
    
    
    //MARK: - Actions
    
    @IBAction func submitTapped(_ sender: Any) {
        delegate?.submitButtonTapped()
    }
    @IBAction func selectTimeTapped(_ sender: Any) {
        delegate?.timeButtonTapped()
    }
    
    @IBAction func selectDateTapped(_ sender: Any) {
        delegate?.dateButtonTapped()
    }
    
    @IBAction func laterTapped(_ sender: Any) {
        setLaterView()
        changeButton(index: 2)
        delegate.laterButtonTapped(2)
    }
    
    @IBAction func asapTapped(_ sender: Any) {
        setAsapView()
        changeButton(index: 0)
        delegate.asapButtonTapped(0)
    }
    
    @IBAction func todayTapped(_ sender: Any) {
        setTodayView()
        changeButton(index: 1)
        delegate.todayButonTapped(1)
    }
}
