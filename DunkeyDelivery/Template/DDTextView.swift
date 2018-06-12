//
//  DDTextView.swift
//  Template
//
//  Created by Ingic on 7/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

@IBDesignable class DDTextView: UIView, UITextFieldDelegate {
    
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var errorIcon: UIImageView!
    
    
    var placeHolderColorValue: UIColor?
    var view: UIView!
    
    @IBInspectable var fieldIcon: UIImage?{
        
        get{
            return icon.image
        }
        
        set(fieldIcon){
            if(fieldIcon != nil){
                icon.image = fieldIcon
            }
        }
    }
    
    @IBInspectable var placeHolderString: String?{
        
        get{
            return textField.placeholder
        }
        
        set(placeHolderString){
            textField.placeholder = placeHolderString
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
    func resetError(){
        self.errorLabel.text = ""
        self.errorIcon.isHidden = true
    }
    
    func setErrorWith(message: String){
        self.errorLabel.text = message
        self.errorLabel.isHidden = false
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
    
    func setLeftImage(named: String){
        let image = UIImage(named: named)
        self.icon.image = image
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
}
