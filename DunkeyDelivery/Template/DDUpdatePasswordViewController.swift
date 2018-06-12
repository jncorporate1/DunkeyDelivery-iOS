//
//  DDUpdatePasswordViewController.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator

class DDUpdatePasswordViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var conPassword: DDTextView!
    @IBOutlet weak var passwordField: DDTextView!
    
    //MARK: - Variable
    
    let validator = Validator()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Update Password"
        self.addBackButtonToNavigationBar()
        setUpFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helping Method
    
    func resetErrorForUserSignup(){
        passwordField.resetError()
        conPassword.resetError()
    }
    
    func setUpFields(){
        validator.registerField(passwordField.textField, errorLabel: passwordField.errorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        validator.registerField(conPassword.textField, errorLabel: conPassword.errorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        validator.registerField(conPassword.textField, errorLabel: conPassword.errorLabel, rules: [RequiredRule() ,ConfirmationRule(confirmField:passwordField.textField)])
    }
    
    func navigateToBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Action
    
    @IBAction func continueTapped(_ sender: Any) {
        self.resetErrorForUserSignup()
        validator.validate(self)
    }
}


//MARK: - ValidationDelegate

extension DDUpdatePasswordViewController: ValidationDelegate{
    
    func validationSuccessful() {
        
        updatePassword()
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}


//MARK:- Web Services

extension DDUpdatePasswordViewController {
    
    func updatePassword() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Password": self.passwordField.textField.text!,
            "ConfirmPassword": self.conPassword.textField.text!,
            "User_Id": AppStateManager.sharedInstance.loggedInUser.Id
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message: "Password updated successfully.")
                self.navigateToBack()
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.changePasswordMobile(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
