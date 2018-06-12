//
//  DCCollectionCellView.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import GMStepper

protocol DCCollectionCellViewDelegate {
    func stepperValueChanged(value:Int)
}

class DCCollectionCellView: UIView {
    
    //MARK: -  IBOutlets
    
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var view: UIView!
    
    //MARK: - Variables
    
    var isCellValueChanged = false
    var delegate:DCCollectionCellViewDelegate!
    var selectedLaudaryProduct: ProductItem!
    var selectedImageName: String!
    var selectedIndexPath: IndexPath!
    var imageName: String!
    
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        let lblFont = UIFont(name: "Helvetica-Light", size: 12)
        stepper.labelFont = lblFont!
    }
    
    //MARK: - Helping Method
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
        
    }
    
    func updateCellUI(){
        if isCellValueChanged {
            let url = self.selectedImageName.getURL()
            self.imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
        }else{
            let url = self.imageName.getURL()
            self.imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
        }
    }
    
    func stepperValueChanged(){
        delegate.stepperValueChanged(value:Int(stepper.value))
        print("Stepper value changed")
        print(self.selectedLaudaryProduct.Id)
        if self.stepper.value > 0 {
            self.isCellValueChanged = true
        }else{
            self.isCellValueChanged = false
        }
        self.updateCellUI()
    }
}
