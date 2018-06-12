//
//  DDStarMediumView.swift
//  Template
//
//  Created by Ingic on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
@IBDesignable
class DDStarMediumView: UIView {

    @IBOutlet weak var image4M: UIImageView!
    @IBOutlet weak var image5M: UIImageView!
    @IBOutlet weak var image3M: UIImageView!
    @IBOutlet weak var image2M: UIImageView!
    @IBOutlet weak var image1M: UIImageView!
    
    var view: UIView!
    
    
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

    func starMedium(items: Int){
        switch items {
        case 1:
            image1M.image = UIImage(named: "star_filled_medium")
        case 2:
            image1M.image = UIImage(named: "star_filled_medium")
            image2M.image = UIImage(named: "star_filled_medium")
        case 3:
            image1M.image = UIImage(named: "star_filled_medium")
            image2M.image = UIImage(named: "star_filled_medium")
            image3M.image = UIImage(named: "star_filled_medium")
        case 4:
            image1M.image = UIImage(named: "star_filled_medium")
            image2M.image = UIImage(named: "star_filled_medium")
            image3M.image = UIImage(named: "star_filled_medium")
            image4M.image = UIImage(named: "star_filled_medium")
        case 5:
            image1M.image = UIImage(named: "star_filled_medium")
            image2M.image = UIImage(named: "star_filled_medium")
            image3M.image = UIImage(named: "star_filled_medium")
            image4M.image = UIImage(named: "star_filled_medium")
            image5M.image = UIImage(named: "star_filled_medium")
        default:
            image1M.image = UIImage(named: "star_unfilled_medium")
            image2M.image = UIImage(named: "star_unfilled_medium")
            image3M.image = UIImage(named: "star_unfilled_medium")
            image4M.image = UIImage(named: "star_unfilled_medium")
            image5M.image = UIImage(named: "star_unfilled_medium")
        }
    }

    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

