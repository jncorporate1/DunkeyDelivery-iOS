//
//  BagFooterView.swift
//  Template
//
//  Created by zaidtayyab on 02/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
protocol BagFooterViewDelegate {
    func checkOutTapped()
    func addMoreItemTapped()
}

class BagFooterView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var minOrderLabel: UILabel!
    @IBOutlet weak var gainedPoints: UILabel!
    
    //MARK: - Variables
    
    var view: UIView!
    var delegate: BagFooterViewDelegate!
    
    
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
    
    //MARK: - Actions
    
    @IBAction func addmoreTapped(_ sender: Any) {
        delegate.addMoreItemTapped()
    }
    
    @IBAction func checkoutTapped(_ sender: Any) {
        delegate.checkOutTapped()
    }
}
