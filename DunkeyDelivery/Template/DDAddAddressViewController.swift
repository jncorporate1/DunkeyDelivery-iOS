//
//  DDAddAddressViewController.swift
//  Template
//
//  Created by Ingic on 7/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator

protocol AddAdressDelegate {
    func completeAddress (_ value: Address)
}

class DDAddAddressViewController: BaseController {
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var phNumField: DDSimpleTextField!
    @IBOutlet weak var zipCodeField: DDSimpleTextField!
    @IBOutlet weak var cityField: DDSimpleTextField!
    @IBOutlet weak var stateField: DDSimpleTextField!
    @IBOutlet weak var floorField: DDSimpleTextField!
    @IBOutlet weak var streetField: DDSimpleTextField!
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
  
    
    //MARK:- Variables
    
    let validator = Validator()
    var viewCheck = false
    var frequency = "Home"
    var delegate : AddAdressDelegate!
    var addressObj : Address!
    var setButtonTilte = ""
    var viewDataCheck: Bool = false

    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButtonToNavigationBar()
        self.title = "Delivery Information"
        setFieldValidation()
        continueButtonOutlet.setTitle(setButtonTilte, for: .normal)
        settingDataSource()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        setTextFieldDelegate()
    }
    
    
    //MARK:- Helping Method
    
    func setTextFieldDelegate(){
        phNumField.textField.returnKeyType = .done
        phNumField.textField.delegate = self
        zipCodeField.textField.returnKeyType = .done
        zipCodeField.textField.delegate = self
        cityField.textField.returnKeyType = .done
        cityField.textField.delegate = self
        stateField.textField.returnKeyType = .done
        stateField.textField.delegate = self
        floorField.textField.returnKeyType = .done
        floorField.textField.delegate = self
        streetField.textField.returnKeyType = .done
        streetField.textField.delegate = self
    }
    
    func hideKeyBoard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DDAddAddressViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func changeButton(index: Int){
        switch index {
        case 0:
            self.homeButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.customButton.backgroundColor = UIColor.white
            self.workButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.black, for: .normal)
            self.customButton.setTitleColor(UIColor.black, for: .normal)
            self.homeButton.setTitleColor(UIColor.white, for: .normal)
            frequency = "Home"
        case 1:
            self.workButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.customButton.backgroundColor = UIColor.white
            self.homeButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.white, for: .normal)
            self.customButton.setTitleColor(UIColor.black, for: .normal)
            self.homeButton.setTitleColor(UIColor.black, for: .normal)
            frequency = "Work"
        case 2:
            self.customButton.backgroundColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
            self.workButton.backgroundColor = UIColor.white
            self.homeButton.backgroundColor = UIColor.white
            
            self.workButton.setTitleColor(UIColor.black, for: .normal)
            self.customButton.setTitleColor(UIColor.white, for: .normal)
            self.homeButton.setTitleColor(UIColor.black, for: .normal)
            frequency = "Custom"
        default:
            break
        }
    }
    
    func settingDataSource(){
        if viewDataCheck {
            streetField.textField.text = addressObj.FullAddress!
            floorField.textField.text = addressObj.Address2!
            cityField.textField.text = addressObj.City!
            stateField.textField.text = addressObj.State!
            zipCodeField.textField.text = addressObj.PostalCode!
            phNumField.textField.text = addressObj.Telephone!
            if addressObj.Frequency == "Home"{
                changeButton(index: 0)
            }
            else if addressObj.Frequency == "Work"{
                changeButton(index: 1)
            }
            else {
                changeButton(index: 2)
            }
        }
    }
    
    func setFieldValidation(){
        validator.registerField(cityField.textField, errorLabel: cityField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 4, message: "Please enter a valid city name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(stateField.textField, errorLabel: stateField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a state name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(floorField.textField, errorLabel: floorField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a floor name"), MaxLengthRule(length: 50, message: "Credit Card number should conform to xxxx-xxxx-xxxx-xxxx")])
        validator.registerField(streetField.textField, errorLabel: streetField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid street name"), MaxLengthRule(length: 50, message: "")])
        validator.registerField(phNumField.textField, errorLabel: phNumField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 10, message: "Please enter a valid phone number"), MaxLengthRule(length: 15, message: "Please enter a valid phone number")])
        validator.registerField(zipCodeField.textField, errorLabel: zipCodeField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 5, message: "Please enter a valid zip code"), MaxLengthRule(length: 6, message: "Please enter a valid Zip Code")])
        phNumField.textField.keyboardType = .numberPad
        zipCodeField.textField.keyboardType = .numberPad
    }
    
    func resetErrorForTextFields(){
        self.zipCodeField.resetError()
        self.cityField.resetError()
        self.stateField.resetError()
        self.floorField.resetError()
        self.streetField.resetError()
        self.cityField.resetError()
        self.phNumField.resetError()
    }

    func deleagteSetUp() {
        delegate?.completeAddress(addressObj)
    }
    
    func addValueToModel(){
        addressObj = Address()
        addressObj.FullAddress =  self.floorField.textField.text!
        addressObj.Address2 = self.streetField.textField.text!
        addressObj.City = self.cityField.textField.text!
        addressObj.State = self.stateField.textField.text!
        addressObj.PostalCode = self.zipCodeField.textField.text!
        addressObj.Frequency = frequency
        addressObj.Telephone = self.phNumField.textField.text!
    }
    
    func setDataToModel(){
        addValueToModel()
        deleagteSetUp()
    }
    
    func goBackController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Actions
    
    @IBAction func workButtonTapped(_ sender: Any) {
        changeButton(index: 1)
    }
    
    @IBAction func customButtonTapped(_ sender: Any) {
        changeButton(index: 2)
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        changeButton(index: 0)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.resetErrorForTextFields()
        validator.validate(self)
    }
    
}


//MARK: - UITextFieldDelegate

extension DDAddAddressViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}


//MARK:- Validation Delegate

extension DDAddAddressViewController: ValidationDelegate{
    func validationSuccessful() {
        
        if (viewDataCheck && setButtonTilte == "Update"){
          editUserAddress()
        }
        else {
        setDataToModel()
        addUserAddress()
        }
    }
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}

//MARK: - WebService

extension DDAddAddressViewController {
    
    
    func addUserAddress() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "User_ID": AppStateManager.sharedInstance.loggedInUser.Id,
            "City":  addressObj.City! ,
            "State":  addressObj.State! ,
            "Telephone":  addressObj.Telephone!,
            "FullAddress":  addressObj.FullAddress!,
            "Address2": addressObj.Address2!,
            "PostalCode": addressObj.PostalCode!,
            "Frequency": addressObj.Frequency!,
            "IsDeleted": false,
            "IsPrimary": false,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.goBackController()
                self.showSuccessWith(message:"Address added successfully")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.addAddress(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    //EDIT USER ADDRESS API
    
    func editUserAddress(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Id": addressObj.Id,
            "User_ID": AppStateManager.sharedInstance.loggedInUser.Id ,
            "City": self.cityField.textField.text! ,
            "State": self.stateField.textField.text!,
            "Telephone": self.phNumField.textField.text!,
            "FullAddress": self.streetField.textField.text!,
            "Address2": self.floorField.textField.text!,
            "PostalCode": self.zipCodeField.textField.text!,
            "Frequency": frequency,
            "IsDeleted": false,
            "IsPrimary" : false ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
               self.goBackController()
               self.showSuccessWith(message: "Address updated successfully")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.editUserAddress(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
