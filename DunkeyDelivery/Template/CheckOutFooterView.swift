//
//  CheckOutFooterView.swift
//  Template
//
//  Created by zaidtayyab on 02/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
protocol CheckOutFooterViewDelegate {
    func placeOrderButtonTap()
}
class CheckOutFooterView: UIView {
    
    @IBOutlet weak var gainedPoints: UILabel!
    
    var view: UIView!
    var delegate: CheckOutFooterViewDelegate!
    
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
    
    @IBAction func placeOrderTapped(_ sender: Any) {
        delegate.placeOrderButtonTap()
    }

    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}
