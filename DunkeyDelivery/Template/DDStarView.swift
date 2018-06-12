//
//  DDStarView.swift
//  Template
//
//  Created by Ingic on 7/7/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
@IBDesignable
class DDStarView: UIView {
    
    @IBOutlet weak var smallCount: UILabel!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    
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
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    func starSmall(items: Int){
        switch items {
            
        case 0:
            image1.image = UIImage(named: "star_unfilled_small")
            image2.image = UIImage(named: "star_unfilled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = UIColor.gray
            self.smallCount.text = "0"
        case 1:
            image1.image = UIImage(named: "star_filled_small")
            image2.image = UIImage(named: "star_unfilled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = Constants.APP_COLOR
            self.smallCount.text = "1"
        case 2:
            image1.image = UIImage(named: "star_filled_small")
            image2.image = UIImage(named: "star_filled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = Constants.APP_COLOR
            self.smallCount.text = "2"
        case 3:
            image1.image = UIImage(named: "star_filled_small")
            image2.image = UIImage(named: "star_filled_small")
            image3.image = UIImage(named: "star_filled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = Constants.APP_COLOR
            self.smallCount.text = "3"
        case 4:
            image1.image = UIImage(named: "star_filled_small")
            image2.image = UIImage(named: "star_filled_small")
            image3.image = UIImage(named: "star_filled_small")
            image4.image = UIImage(named: "star_filled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = Constants.APP_COLOR
            self.smallCount.text = "4"
        case 5:
            image1.image = UIImage(named: "star_filled_small")
            image2.image = UIImage(named: "star_filled_small")
            image3.image = UIImage(named: "star_filled_small")
            image4.image = UIImage(named: "star_filled_small")
            image5.image = UIImage(named: "star_filled_small")
            self.smallCount.textColor = Constants.APP_COLOR
            self.smallCount.text = "5"
        default:
            image1.image = UIImage(named: "star_unfilled_small")
            image2.image = UIImage(named: "star_unfilled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
        }
        func hideCount(){
            self.smallCount.isHidden = true
        }
    }

    func setWhite(items: Int){
        self.smallCount.textColor = UIColor.white
        
        switch items {
            
        case 0:
            image1.image = UIImage(named: "star_unfilled_small")
            image2.image = UIImage(named: "star_unfilled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "0"
        case 1:
            image1.image = UIImage(named: "star_white_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "1"
        case 2:
            image1.image = UIImage(named: "star_white_small")
            image2.image = UIImage(named: "star_white_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "2"
        case 3:
            image1.image = UIImage(named: "star_white_small")
            image2.image = UIImage(named: "star_white_small")
            image3.image = UIImage(named: "star_white_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "3"
        case 4:
            image1.image = UIImage(named: "star_white_small")
            image2.image = UIImage(named: "star_white_small")
            image3.image = UIImage(named: "star_white_small")
            image4.image = UIImage(named: "star_white_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "4"
        case 5:
            image1.image = UIImage(named: "star_white_small")
            image2.image = UIImage(named: "star_white_small")
            image3.image = UIImage(named: "star_white_small")
            image4.image = UIImage(named: "star_white_small")
            image5.image = UIImage(named: "star_white_small")
            self.smallCount.textColor = UIColor.white
            self.smallCount.text = "5"
        default:
            image1.image = UIImage(named: "star_unfilled_small")
            image2.image = UIImage(named: "star_unfilled_small")
            image3.image = UIImage(named: "star_unfilled_small")
            image4.image = UIImage(named: "star_unfilled_small")
            image5.image = UIImage(named: "star_unfilled_small")
        }
    }
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

