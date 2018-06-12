//
//  HomeSummaryView.swift
//  Template
//
//  Created by Ingic on 7/6/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
@IBDesignable
class HomeSummaryView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var starView: DDStarView!
    @IBOutlet weak var menuList: UILabel!
    @IBOutlet weak var viewMenuButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var liveFeed: UIView!
    
    //MARK: - Vaiables
    
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
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    //MARK: - Helping Method
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
