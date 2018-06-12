//
//  DDWashFoldViewController.swift
//  Template
//
//  Created by Ingic on 7/29/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator
class DDWashFoldViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var weightField: DDSimpleTextField!
    @IBOutlet weak var storeDescription: UILabel!
    
    
    //MARK: - Variables
    
    let validator = Validator()
    var laundry: Laundry!
    var storeData : StoreItem!
    var dateNtime : String!
    var desc: String!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wash & Fold"
        self.addBackButtonToNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.setUpFields()
        desc = laundry.Description!
        storeDescription.text = desc
        setNavigationRightItems()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setUpFields(){
        self.weightField.textField.keyboardType = .decimalPad
        validator.registerField(weightField.textField, errorLabel: weightField.errorLabel, rules: [RequiredRule(),MinLengthRule(length:1)])
    }
    func resetErrorForUserSignup(){
        weightField.resetError()
    }
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
    }
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func navigateToNext(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Action
    
    @IBAction func addToBagTapped(_ sender: Any) {
        resetErrorForUserSignup()
        validator.validate(self)
    }
}

//MARK: - ValidationDelegate

extension DDWashFoldViewController: ValidationDelegate{
    func validationSuccessful() {
        requestGetCloth()
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        for (field, error) in errors {
            //             if let field = field as? UITextField {
            // field.layer.borderColor = UIColor.red.cgColor
            // field.layer.borderWidth = 1.0
            //           }
            //            DDLogError(error.errorMessage)
            
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}


//MARK: - Web Service

extension DDWashFoldViewController {
    
    
    //MARK: - Submit Estimate weight
    
    func requestGetCloth() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "Store_Id": (laundry.Store_Id).description,
            "User_Id": (AppStateManager.sharedInstance.loggedInUser.Id).description,
            "Weight": self.weightField.textField!.text!,
            "AdditionalNote": " ",
            "PickUpTime":dateNtime,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message: "Weight added successfully.")
                self.navigateToNext()
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.requestGetClothes(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
