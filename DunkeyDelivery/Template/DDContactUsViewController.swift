//
//  DDContactUsViewController.swift
//  Template
//
//  Created by Ingic on 8/8/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator
import DLRadioButton

class DDContactUsViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var textViewErrorLabel: UILabel!
    @IBOutlet weak var reasonLabel: DDLabel!
    @IBOutlet weak var reasonView: UIView!
    @IBOutlet weak var radioButton: DLRadioButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var phNumField: DDTextView!
    @IBOutlet weak var nameField: DDTextView!
    @IBOutlet weak var emailField: DDTextView!
    
    //MARK: - Variables
    
    let validator = Validator()
    var reasonCheck = false
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Email Us"
        self.addBackButtonToNavigationBar()
        setUpFields()
        setUpTextView()
        self.reasonView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideTabBarAnimated(hide: true)
        setUpTextFiledDelegate()
    }
    
    //MARK: - Helping Method
    
    func setUpTextView(){
        self.textView.text = "Add Special Instructions"
        self.textView.placeholderText = "Add Special Instructions"
        self.textView.textColor = UIColor.lightGray
        self.textView.delegate = self
    }
    
    func setUpFields(){
        if  AppStateManager.sharedInstance.loggedInUser.FullName != nil{
            self.nameField.textField.text = AppStateManager.sharedInstance.loggedInUser.FullName
        }
        else{
            if (AppStateManager.sharedInstance.loggedInUser.FirstName != nil) && (AppStateManager.sharedInstance.loggedInUser.LastName != nil){
                self.nameField.textField.text = AppStateManager.sharedInstance.loggedInUser.FirstName + " " + AppStateManager.sharedInstance.loggedInUser.LastName
            }
        }
        self.emailField.textField.text = AppStateManager.sharedInstance.loggedInUser.Email
        self.phNumField.textField.placeholder = "Phone number (optional)"
        self.textView.text = ""
        self.emailField.textField.keyboardType = .emailAddress
        self.phNumField.textField.keyboardType = .numberPad
        validator.registerField(nameField.textField, errorLabel: nameField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid  Name"), MaxLengthRule(length: 25, message: "Name length should be less than or equal to 25")])
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
        //validator.registerField(phNumField.textField, errorLabel: phNumField.errorLabel, rules: [MinLengthRule(length: 10, message: "Please enter a valid phone number"), MaxLengthRule(length: 15, message: "Please enter a valid phone number")])
    }
    
    
    func setUpTextFiledDelegate(){
        phNumField.textField.returnKeyType = .done
        phNumField.textField.delegate = self
        nameField.textField.returnKeyType = .done
        nameField.textField.delegate = self
        emailField.textField.returnKeyType = .done
        emailField.textField.delegate = self
    }
    
    func resetErrorMessages(){
        self.nameField.resetError()
        self.emailField.resetError()
        DispatchQueue.main.async {
            self.textViewErrorLabel.text = ""
        }
    }
    
    func hideReasonView(sender: Any){
        UIView.animate(withDuration: 0.15, delay: 3.0, options: [], animations: {
            self.reasonView.isHidden = true
        }, completion: nil)
    }
    
    func goBackController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Action
    
    @IBAction func radioButtonTapped(_ sender: Any) {
        
        self.reasonView.isHidden = true
        let btn = sender as! DLRadioButton
        if btn.tag == 1{
            self.reasonCheck = true
            self.reasonLabel.text = "Comment on the site"
        }
        else if btn.tag == 2{
            self.reasonCheck = true
            self.reasonLabel.text = "Question about the site"
        }
        else if btn.tag == 3{
            self.reasonCheck = true
            self.reasonLabel.text = "Report technical issue"
        }
        else{
            self.reasonCheck = true
            self.reasonLabel.text = "Business inquiry"
        }
    }
    
    @IBAction func reasonButtonTapped(_ sender: Any) {
        phNumField.textField.resignFirstResponder()
        nameField.textField.resignFirstResponder()
        emailField.textField.resignFirstResponder()
        self.reasonView.isHidden = false
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        if textView.text == "" || textView.text == "Add Special Instructions"{
            if phNumField.textField.text != ""{
                validator.registerField(phNumField.textField, errorLabel: phNumField.errorLabel, rules: [MinLengthRule(length: 10, message: "Please enter a valid phone number"), MaxLengthRule(length: 15, message: "Please enter a valid phone number")])
                validator.validate(self)
            }
            else{
                self.textViewErrorLabel.text = "This field is required"
                validator.validate(self)
            }
        }
        else{
            resetErrorMessages()
            validator.validate(self)
        }
    }
}


//MARK: - UITextViewDelegate

extension DDContactUsViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add Special Instructions"
            textView.textColor = UIColor.lightGray
        }
    }
    
}

//MARK: - UITextFieldDelegate

extension DDContactUsViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phNumField.textField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            
            return newLength <= 15 // Bool
        }
        return true
    }
}

//MARK: - ValidationDelegate

extension DDContactUsViewController: ValidationDelegate{
    func validationSuccessful() {
        if !(reasonCheck){
            self.showAlertWith(message: "Please select any reason for contact.", title: "")
        }
        else{
            if textView.text == "" || textView.text == "Add Special Instructions"{
                self.textViewErrorLabel.text = "This field is required"
            }
            else{
                self.textViewErrorLabel.text = ""
                submitContactUs()
            }
        }
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            if textView.text == "" || textView.text == "Add Special Instructions"{
                self.textViewErrorLabel.text = "This field is required"
            }
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
            
        }
    }
}

//MARK: - Web Service

extension DDContactUsViewController {
    
    func submitContactUs(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "Name": self.nameField.textField.text! ,
            "Email": self.emailField.textField.text! ,
            "Phone": self.phNumField.textField.text!,
            "Message": self.textView.text!,
            "ContactReason": self.reasonLabel.text!,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.goBackController()
                self.showSuccessWith(message: "Email sent successfully.")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.submitContactUs(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
