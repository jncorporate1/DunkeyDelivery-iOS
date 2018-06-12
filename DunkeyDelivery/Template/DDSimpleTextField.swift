//
//  DDSimpleTextField.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

@IBDesignable class DDSimpleTextField: UIView, UITextFieldDelegate {
    
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorIcon: UIImageView!
    
    
    var placeHolderColorValue: UIColor?
    var view: UIView!
    
    
    @IBInspectable var placeHolderString: String?{
        
        get{
            return textField.placeholder
        }
        
        set(placeHolderString){
            textField.placeholder = placeHolderString
        }
    }
    
    @IBInspectable var rightButtonImage: UIImage {
        get {
            return self.rightButton.image(for: .normal)!
        }
        set(newImage) {
            self.rightButton.setImage(newImage, for: .normal)
        }
    }
    @IBInspectable var errorImage: UIImage {
        get {
            
            return self.errorIcon.image!
        }
        set(errorIcon){
            self.errorIcon.image = errorIcon
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return placeHolderColorValue
        }
        set(newValue) {
            self.placeHolderColorValue = newValue
            self.textField.attributedPlaceholder = NSAttributedString(string:self.textField.placeholder != nil ? self.textField.placeholder! : textField.placeholder!, attributes:[NSForegroundColorAttributeName: newValue!
                ] as [String: UIColor])
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var isSecure: Bool{
        
        get{
            return textField.isSecureTextEntry
        }
        
        set(isSecure){
            if(isSecure){
                textField.isEnabled = false
                textField.isSecureTextEntry = true
                textField.isEnabled = true
            }else{
                textField.isEnabled = false
                textField.isSecureTextEntry = false
                textField.isEnabled = true
            }
        }
    }
    
    func resetError(){
        self.errorLabel.text = ""
    }
    
    func setErrorWith(message: String){
        self.errorLabel.text = message
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = textField.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
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
        self.textField.delegate = self
        addSubview(view)
        self.resetError()
    }
    
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setFieldAsVerified(){
        self.errorIcon.isHidden = false
        self.errorIcon.image = #imageLiteral(resourceName: "text_field_verified")
    }
    
    func setFieldAsNotVerified(){
        self.errorIcon.isHidden = false
        self.errorIcon.image = #imageLiteral(resourceName: "text_field_not_verified")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        self.resetError()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UILayoutFittingExpandedSize.width, height: 35)
    }
}

