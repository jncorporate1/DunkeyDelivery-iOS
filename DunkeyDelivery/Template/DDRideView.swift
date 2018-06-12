//
//  DDRideView.swift
//  Template
//
//  Created by Ingic on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator

protocol DDRideViewDelegate  {
    func submitTapped(params: Parameters)
    
}

@IBDesignable
class DDRideView: UIView {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var zipCode: DDSimpleTextField!
    @IBOutlet weak var phNumField: DDSimpleTextField!
    @IBOutlet weak var bussName: DDSimpleTextField!
    @IBOutlet weak var emailField: DDSimpleTextField!
    @IBOutlet weak var bussType: DDSimpleTextField!
    @IBOutlet weak var fullname: DDSimpleTextField!
    
    //MARK:- Variables
    
    var view: UIView!
    let validator = Validator()
    var delegate : DDRideViewDelegate!
    var rideObj : Ride = Ride()
    
    //MARK: - Views Method
    
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
        setFieldValidation()
        addSubview(view)
    }
    func setFieldValidation(){
        validator.registerField(bussName.textField, errorLabel: bussName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 4, message: "Please enter a valid name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(bussType.textField, errorLabel: bussType.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a state name"), MaxLengthRule(length: 50, message: "")])
        
        validator.registerField(fullname.textField, errorLabel: fullname.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid street name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(phNumField.textField, errorLabel: phNumField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 10, message: "Please enter a valid phone number"), MaxLengthRule(length: 15, message: "Please enter a valid phone number")])
        validator.registerField(zipCode.textField, errorLabel: zipCode.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 5, message: "Please enter a valid zip code"), MaxLengthRule(length: 6, message: "Please enter a valid zip code")])
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
        phNumField.textField.keyboardType = .numberPad
        zipCode.textField.keyboardType = .numberPad
    }
    
    func resetErrorForTextFields(){
        
        self.bussName.resetError()
        self.bussType.resetError()
        self.fullname.resetError()
        self.phNumField.resetError()
        self.zipCode.resetError()
        self.emailField.resetError()
        
    }

    @IBAction func submit(_ sender: Any) {
        resetErrorForTextFields()
        validator.validate(self)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
}

//MARK: - ValidationDelegate

extension DDRideView: ValidationDelegate{
    func validationSuccessful() {
        let parameters: Parameters = [
            
            "FullName": self.fullname.textField.text! ,
            "BusinessName":self.bussName.textField.text! ,
            "BusinessType": self.bussType.textField.text!,
            "Email": self.emailField.textField.text!,
            "ZipCode":self.zipCode.textField.text!,
            "Phone": self.phNumField.textField.text!,
            "Status" : 0,
            "SignInType":  1]
        
        delegate.submitTapped(params: parameters)
       print("Message: Success")
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}


