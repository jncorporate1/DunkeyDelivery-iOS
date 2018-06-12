//
//  DDAddCreditCardViewController.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator
import Stripe

protocol AddCreditCardDelegate {
    func completeCreditCardAddress (_ value: CreditCard)
}

class DDAddCreditCardViewController: BaseController {
    
    
    //MARK:- IBOulets
    
    @IBOutlet weak var labelField: DDSimpleTextField!
    @IBOutlet weak var zipCodeField: DDSimpleTextField!
    @IBOutlet weak var cvvField: DDSimpleTextField!
    @IBOutlet weak var dateField: DDSimpleTextField!
    @IBOutlet weak var creditCardField: DDSimpleTextField!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var optionalButtonOulet: UIButton!
    
    
    //MARK:- Varaibles
    
    let validator = Validator()
    let datePicker = UIDatePicker()
    var viewCheck = false
    var delegate: AddCreditCardDelegate?
    var creditCardObj : CreditCard!
    var setDefault : Int! = 0
    var setButtonTitle = ""
    var viewDataCheck: Bool = false
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNavigationBar()
        self.title = "Add New Credit Card"
        setFieldValidation()
        setUpDatePicker()
        setFieldsDataSource()
        setUpDataSource()
        continueButtonOutlet.setTitle(setButtonTitle, for: .normal)
        labelField.textField.delegate = self
        labelField.textField.returnKeyType = .done
        self.creditCardField.textField.delegate = self
        self.cvvField.textField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Helping Method
    
    func setUpDataSource(){
        if (viewDataCheck){
            creditCardField.textField.text = creditCardObj.CCNo!
            dateField.textField.text = creditCardObj.ExpiryDate!
            cvvField.textField.text = creditCardObj.CCV!
            zipCodeField.textField.text = creditCardObj.BillingCode!
            if let optionalLabel = creditCardObj.Label  {
                labelField.textField.text = optionalLabel
            }
            let checkMark = creditCardObj.Is_Primary
            if checkMark == 1{
                optionalButtonOulet.setImage(#imageLiteral(resourceName: "check_mark_icon"), for: .normal)
                setDefault = 0
            }else{
                setDefault = 1
                optionalButtonOulet.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
            }
        }
    }
    
    func setUpDatePicker(){
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        datePicker.backgroundColor = UIColor.white
        dateField.textField.addDoneOnKeyboardWithTarget(self, action: #selector(doneTapped), shouldShowPlaceholder: true)
    }
    
    func setFieldValidation(){
        validator.registerField(creditCardField.textField, errorLabel: creditCardField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 12, message: "Please enter a valid Credit Card number"), MaxLengthRule(length: 19, message: "Please enter a valid Credit Card number")])
        validator.registerField(cvvField.textField, errorLabel: cvvField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 3, message: "Please enter a valid CCV number"), MaxLengthRule(length: 4, message: "Invalid CCV number")])
        
        validator.registerField(zipCodeField.textField, errorLabel: zipCodeField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 5, message: "Please enter a valid Zip Code"), MaxLengthRule(length: 6, message: "Please enter a valid Zip Code")])
        creditCardField.textField.keyboardType = .numberPad
        cvvField.textField.keyboardType = .numberPad
        zipCodeField.textField.keyboardType = .numberPad
        datePicker.datePickerMode = .date
        dateField.textField.inputView = datePicker
    }
    
    func setFieldsDataSource(){
        if (self.viewCheck){
            self.creditCardField.textField.text = "111111111100"
            self.dateField.textField.text = "02/22"
            self.cvvField.textField.text = "357"
            self.zipCodeField.textField.text = "45785"
        }
    }
    
    func doneTapped(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        self.dateField.textField.text = dateFormatter.string(for: datePicker.date)
        self.view.endEditing(true)
    }
    
    func resetErrorForTextFields(){
        self.zipCodeField.resetError()
        self.cvvField.resetError()
        self.creditCardField.resetError()
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/YY"
        datePicker.minimumDate = Date()
        self.dateField.textField.text = dateFormatter.string(for: sender.date)
    }
    
    func backToController(){
        delegate?.completeCreditCardAddress(creditCardObj)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addValueToModel(){
        creditCardObj = CreditCard()
        creditCardObj.CCNo = self.creditCardField.textField.text!
        creditCardObj.ExpiryDate = self.dateField.textField.text!
        creditCardObj.CCV = self.cvvField.textField.text!
        creditCardObj.BillingCode = self.zipCodeField.textField.text!
        creditCardObj.Is_Primary = setDefault
        creditCardObj.Label = self.labelField.textField.text!
    }
    
    
    //MARK:- Actions
    
    @IBAction func CheckBoxTapped(_ sender: UIButton) {
        
        if sender.isSelected{
            setDefault = 0
            sender.isSelected = !sender.isSelected
            optionalButtonOulet.setImage(#imageLiteral(resourceName: "check_icon"), for: .normal)
        }
        else {
            setDefault = 1
            sender.isSelected = !sender.isSelected
            optionalButtonOulet.setImage(#imageLiteral(resourceName: "check_mark_icon"), for: .normal)
        }
    }
    
    @IBAction func continueButtonTApped(_ sender: Any) {
        self.resetErrorForTextFields()
        validator.validate(self)
    }
}


//MARK: - UITextFieldDelegate

extension DDAddCreditCardViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == creditCardField.textField {
            
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            
            return newLength <= 19 // Bool
        } else if textField == cvvField.textField {
            
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            
            return newLength <= 4 // Bool
        }
        return true
    }
}


//MARK:- Validation Delegate

extension DDAddCreditCardViewController: ValidationDelegate{
    func validationSuccessful() {
        if (viewDataCheck){
            editUserCreditCards()
        }
        else{
            addValueToModel()
            addUserCreditCard()
        }
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
}


//MARK:- WebService

extension DDAddCreditCardViewController {
    
    
    func addUserCreditCard() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "CCNo": creditCardObj.CCNo!,
            "ExpiryDate": creditCardObj.ExpiryDate! ,
            "CCV":  creditCardObj.CCV! ,
            "BillingCode": creditCardObj.BillingCode!,
            "Is_Primary": (creditCardObj.Is_Primary).description,
            "User_ID": AppStateManager.sharedInstance.loggedInUser.Id,
            "Label": creditCardObj.Label!, ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.backToController()
                self.showSuccessWith(message:"Card added successfully")
            }
            else if (response?.intValue ==  409){
                self.showErrorWith(message: "User with this credit card already exists.")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.addCreditCard(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    //EDIT USER CREDIT CARDS API
    
    func editUserCreditCards() {
        
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Id": creditCardObj.Id,
            "CCNo": self.creditCardField.textField.text! ,
            "ExpiryDate": self.dateField.textField.text! ,
            "CCV": self.cvvField.textField.text!,
            "BillingCode": self.zipCodeField.textField.text!,
            "Is_Primary":(setDefault).description,
            "User_ID": AppStateManager.sharedInstance.loggedInUser.Id,
            "Label" : self.labelField.textField.text! ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.backToController()
                self.showSuccessWith(message: "Card updated successfully")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.editUserCreditCard(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
