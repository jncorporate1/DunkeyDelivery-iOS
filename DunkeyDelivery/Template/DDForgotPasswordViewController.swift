//
//  DDForgotPasswordViewController.swift
//  Template
//
//  Created by Ingic on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator
class DDForgotPasswordViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var emailField: DDTextView!
    
    //MARK: - Variable
    
    let validator = Validator()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.setLoginNavigationBar()
        self.title = "Forgot Password"
        self.addBackButtonToNavigationBar()
        setUpFields()
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.returnKeyType = .done
        emailField.textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setUpFields(){
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
    }
    
    func showMessage(){
        UIAlertController.showAlert(in: self,
                                    withTitle: "Reset",
                                    message: "An email has been sent to your account with password reset link",
                                    cancelButtonTitle: "OK",
                                    destructiveButtonTitle: nil,
                                    otherButtonTitles: nil,
                                    tap: {(controller, action, buttonIndex) in
                                        
                                        if (buttonIndex == controller.cancelButtonIndex) {
                                            self.navigationController?.popToRootViewController(animated: true)
                                            print("Cancel Tapped")
                                        } else if (buttonIndex == controller.destructiveButtonIndex) {
                                            print("Delete Tapped")
                                        } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                                            print("Other Button Index \(buttonIndex - controller.firstOtherButtonIndex)")
                                        }
        })
    }
    
    
    func resetErrorMessage(){
        self.emailField.resetError()
    }
    

    //MARK: - Action
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        resetErrorMessage()
        validator.validate(self)
    }
}


//MARK: - ValidationDelegate

extension DDForgotPasswordViewController: ValidationDelegate{
    
    func validationSuccessful() {
        self.forgotPassword()
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
      
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage 
            error.errorLabel?.isHidden = false
        }
    }
}

//MARK: - UITextFieldDelegate

extension DDForgotPasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}

//MARK: - Web Service

extension DDForgotPasswordViewController{
    func forgotPassword(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "email":self.emailField.textField.text!,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showMessage()
                self.showSuccessWith(message: "Email sent successfully.")
            }else if(response?.intValue == 409){
                let responseResult = result["Result"] as! NSDictionary
                let errorMessage = responseResult["ErrorMessage"] as! String
                self.emailField.setErrorWith(message: errorMessage)
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
                
            }
        }
        APIManager.sharedInstance.forgotPassword(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
