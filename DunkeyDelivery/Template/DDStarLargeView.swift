//
//  DDStarLargeView.swift
//  Template
//
//  Created by Ingic on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
var largeStarValue = 0
@IBDesignable
class DDStarLargeView: UIView {
    @IBOutlet weak var image4L: UIImageView!
    @IBOutlet weak var image5L: UIImageView!
    @IBOutlet weak var image3L: UIImageView!
    @IBOutlet weak var image2L: UIImageView!
    @IBOutlet weak var image1L: UIImageView!

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
    func starLarge(items: Int){
        switch items {
        case 1:
            image1L.image = UIImage(named: "star_filled_large")
            image2L.image = UIImage(named: "star_unfilled_large")
            image3L.image = UIImage(named: "star_unfilled_large")
            image4L.image = UIImage(named: "star_unfilled_large")
            image5L.image = UIImage(named: "star_unfilled_large")
            largeStarValue = 1
        case 2:
            image1L.image = UIImage(named: "star_filled_large")
            image2L.image = UIImage(named: "star_filled_large")
            image3L.image = UIImage(named: "star_unfilled_large")
            image4L.image = UIImage(named: "star_unfilled_large")
            image5L.image = UIImage(named: "star_unfilled_large")
            largeStarValue = 2
        case 3:
            image1L.image = UIImage(named: "star_filled_large")
            image2L.image = UIImage(named: "star_filled_large")
            image3L.image = UIImage(named: "star_filled_large")
            image4L.image = UIImage(named: "star_unfilled_large")
            image5L.image = UIImage(named: "star_unfilled_large")
            largeStarValue = 3
        case 4:
            image1L.image = UIImage(named: "star_filled_large")
            image2L.image = UIImage(named: "star_filled_large")
            image3L.image = UIImage(named: "star_filled_large")
            image4L.image = UIImage(named: "star_filled_large")
            image5L.image = UIImage(named: "star_unfilled_large")
            largeStarValue = 4
    
        case 5:
            image1L.image = UIImage(named: "star_filled_large")
            image2L.image = UIImage(named: "star_filled_large")
            image3L.image = UIImage(named: "star_filled_large")
            image4L.image = UIImage(named: "star_filled_large")
            image5L.image = UIImage(named: "star_filled_large")
            largeStarValue = 5
        default:
            image1L.image = UIImage(named: "star_unfilled_large")
            image2L.image = UIImage(named: "star_unfilled_large")
            image3L.image = UIImage(named: "star_unfilled_large")
            image4L.image = UIImage(named: "star_unfilled_large")
            image5L.image = UIImage(named: "star_unfilled_large")
            largeStarValue = 0
        }
        
    }
    @IBAction func fiveTapped(_ sender: Any) {
        starLarge(items: 5)
    }
    @IBAction func fourTapped(_ sender: Any) {
        starLarge(items: 4)
    }
    @IBAction func threeTapped(_ sender: Any) {
        starLarge(items: 3)
    }
    @IBAction func twoTapped(_ sender: Any) {
        starLarge(items: 2)
    }
    @IBAction func oneTapped(_ sender: Any) {
        starLarge(items: 1)
    }
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

