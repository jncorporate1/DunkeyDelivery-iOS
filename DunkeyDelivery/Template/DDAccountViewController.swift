//
//  DDAccountViewController.swift
//  Template
//
//  Created by Ingic on 7/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator

class DDAccountViewController: BaseController{
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var emailField: DDTextView!
    @IBOutlet weak var lastNameField: DDTextView!
    @IBOutlet weak var firstNameField: DDTextView!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var cardTableView: UITableView!
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var cardButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var changePasswordOutlet: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var editIcon: UIImageView!
    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordViewHeight: NSLayoutConstraint!
    @IBOutlet weak var changePasswordLabel: DDLabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    
    //MARK:- Varaiables
    
    let validator = Validator()
    var addressTitle = [String] ()
    var addressStreet = [String] ()
    var userAddress = [Address] ()
    var creditCardDetail = [CreditCard]()
    var setCreditCardValues : CreditCard = CreditCard()
    var selectedTabPoint : CGPoint!
    
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Account"
        addbackButtonToHomeViewController()
        setupNavigatinBar()
        self.hideTabBarAnimated(hide: true)
        selectedTabPoint = CGPoint(x: 0, y: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.scrollView.setContentOffset(self.selectedTabPoint, animated: true)
        toggleChangePasswordView()
        setUpFields()
        setFieldValues()
        getCreditCards()
        getUserAddress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- Helping Method
    
    func toggleChangePasswordView(){
        
        if AppStateManager.sharedInstance.loggedInUser.Role == 5 || AppStateManager.sharedInstance.loggedInUser.Role == 6 {
            toggleView(isHide: true, changePasswordViewheight: 0.0, mainViewheight: 210.0)
        }
        else {
            toggleView(isHide: false, changePasswordViewheight: 60.0, mainViewheight: 270.0)
        }
    }
    
    func toggleView(isHide: Bool, changePasswordViewheight: CGFloat, mainViewheight: CGFloat){
        changePasswordLabel.isHidden = isHide
        topLineView.isHidden = isHide
        bottomLineView.isHidden = isHide
        changePasswordOutlet.isHidden = isHide
        arrowImage.isHidden = isHide
        editIcon.isHidden = isHide
        changePasswordView.isHidden = isHide
        changePasswordViewHeight.constant = changePasswordViewheight
        mainViewHeight.constant = mainViewheight
    }
    
    
    func setFieldValues(){
        
        if AppStateManager.sharedInstance.loggedInUser.FirstName == nil {
            let fullName =  AppStateManager.sharedInstance.loggedInUser.FullName
            var components = fullName?.components(separatedBy: " ")
            let firstName = components![0]
            let lastName = components![1]
            self.firstNameField.textField.text = firstName
            self.lastNameField.textField.text = lastName
        }
        else {
            self.firstNameField.textField.text =
                AppStateManager.sharedInstance.loggedInUser.FirstName
            self.lastNameField.textField.text = AppStateManager.sharedInstance.loggedInUser.LastName
        }
        self.emailField.textField.text = AppStateManager.sharedInstance.loggedInUser.Email
        emailField.textField.isUserInteractionEnabled = false
        lastNameField.textField.isUserInteractionEnabled = false
        firstNameField.textField.isUserInteractionEnabled = false
    }
    
    func setUpFields(){
        self.emailField.textField.keyboardType = .emailAddress
        validator.registerField(firstNameField.textField, errorLabel: firstNameField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid  Name"), MaxLengthRule(length: 25, message: "Name length should be less than or equal to 25")])
        validator.registerField(lastNameField.textField, errorLabel: lastNameField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 2, message: "Please enter a valid  Name"), MaxLengthRule(length: 25, message: "Name length should be less than or equal to 25")])
        
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
    }
    
    func setupLeftMenu(){
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> () -> Void) // Swift 3 fix
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setupNavigatinBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let yourBackImage = UIImage(named: "back_button_icon")
        self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    }
    
    func changeButton(index: Int){
        switch index {
        case 0:
            self.accountButton.setImage(UIImage(named: "addressHomeSelected"), for: .normal)
            self.cardButton.setImage(UIImage(named: "card_unselected_icon"), for: .normal)
            self.addressButton.setImage(UIImage(named: "home_unselected_icon"), for: .normal)
        case 1:
            self.accountButton.setImage(UIImage(named: "addressHomeUnselected"), for: .normal)
            self.cardButton.setImage(UIImage(named: "card_selected_icon"), for: .normal)
            self.addressButton.setImage(UIImage(named: "home_unselected_icon"), for: .normal)
        case 2:
            self.accountButton.setImage(UIImage(named: "addressHomeUnselected"), for: .normal)
            self.cardButton.setImage(UIImage(named: "card_unselected_icon"), for: .normal)
            let addressimage = UIImage(named: "home_selected_icon")
            let colorChange = addressimage?.withRenderingMode(.alwaysTemplate)
            self.addressButton.setImage(colorChange, for: .normal)
            self.addressButton.tintColor = Constants.APP_COLOR

            
        default:
            break
        }
    }
    
    func resetErrorForUserSignup(){
        firstNameField.resetError()
        lastNameField.resetError()
        emailField.resetError()
    }
    
    func goToCreditCardController(setTitle: String, selectedRow: Int){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddCreditCardViewController") as! DDAddCreditCardViewController
        
        vc.setButtonTitle = setTitle
        if selectedRow > -1 {
            vc.creditCardObj = self.creditCardDetail[selectedRow]
            vc.viewDataCheck = true
        }
        else {
            vc.delegate = self
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToAddressController(setTitle: String, selectedRow: Int){
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddAddressViewController") as! DDAddAddressViewController
        vc.setButtonTilte = setTitle
        if selectedRow > -1 {
            vc.addressObj = self.userAddress[selectedRow]
            vc.viewDataCheck = true
        }
        else {
            vc.delegate = self
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func showAlert(message: String, removedFrom: String, selectedRow :Int) {
        
        UIAlertController.showAlert(in: self,
                                    withTitle: nil,message: message,cancelButtonTitle: "No",destructiveButtonTitle: "Yes",otherButtonTitles: nil,tap: {(controller, action, buttonIndex) in
                                        
                                        if (buttonIndex == controller.cancelButtonIndex) {
                                            print("Cancel Tapped")
                                        }
                                        else if (buttonIndex == controller.destructiveButtonIndex) {
                                            if removedFrom == "Address" {
                                                self.removeFromAddress(selectedRow: selectedRow)
                                            }
                                            else {
                                                self.removeFromCard(selectedRow: selectedRow)
                                            }
                                        }
        })
    }
    
    func removeFromAddress(selectedRow: Int){
        let userItem = self.userAddress[selectedRow]
        self.removeAddress(addressId: userItem.Id, userId: userItem.User_ID)
        self.userAddress.remove(at: selectedRow)
        self.addressTableView.reloadData()
    }
    
    func removeFromCard(selectedRow: Int){
        let carditem = self.creditCardDetail[selectedRow]
        self.removeCreditCard(creditCardId: carditem.Id, userId: carditem.User_ID)
        self.creditCardDetail.remove(at: selectedRow)
        self.cardTableView.reloadData()
    }
    
    
    //MARK:- Actions
    
    @IBAction func accountButtonTapped(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
        selectedTabPoint = CGPoint(x: 0, y: 0)
        changeButton(index: 0)
    }
    
    @IBAction func addressButtonTapped(_ sender: Any) {
        print(self.view.frame.size.width)
        self.scrollView.setContentOffset(CGPoint(x:self.view.frame.size.width * 2,y:0), animated: true)
        selectedTabPoint = CGPoint(x:self.view.frame.size.width * 2, y: 0)
        self.addressTableView.reloadData()
        changeButton(index: 2)
    }
    
    @IBAction func cardButtonTapped(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x:self.view.frame.size.width,y:0), animated: true)
        selectedTabPoint = CGPoint(x:self.view.frame.size.width, y: 0)
        self.cardTableView.reloadData()
        changeButton(index: 1)
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDUpdatePasswordViewController") as! DDUpdatePasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addCreditCardDetailsTapped(_ sender: Any) {
        goToCreditCardController(setTitle: "Continue",selectedRow: -1)
    }
    
    @IBAction func addNewAddressTapped(_ sender: Any) {
        goToAddressController(setTitle: "Continue",selectedRow: -1)
    }

    @IBAction func accountContinueTapped(_ sender: Any) {
        resetErrorForUserSignup()
        validator.validate(self)
    }
    
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension DDAccountViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == cardTableView{
            return self.creditCardDetail.count
        }
        else{
            return self.userAddress.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == cardTableView{
            let cell = self.cardTableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath) as! DDCardTableViewCell
            let carditem = self.creditCardDetail[indexPath.row]
            cell.cardDetail.text = carditem.CCNo
            cell.cardSubDetail.text = carditem.ExpiryDate
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = self.addressTableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! DDCardTableViewCell
            let item = self.userAddress[indexPath.row]
            cell.cardDetail.text = item.Frequency!
            let subDetail = item.FullAddress! + "," + item.PostalCode!
            cell.cardSubDetail.text = subDetail
            cell.separatorInset.left = 0
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == cardTableView {
            print("Card \(creditCardDetail)")
            goToCreditCardController(setTitle: "Update", selectedRow: indexPath.row)
        }
        else{
            print("Address \(userAddress)")
            goToAddressController(setTitle: "Update", selectedRow: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if tableView == cardTableView {
                showAlert(message: "Are you sure you want to delete this card?", removedFrom: "Card", selectedRow: indexPath.row)
                
            }
            else {
                showAlert(message: "Are you sure you want to delete this address?", removedFrom: "Address", selectedRow: indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
}

//MARK: - Validation Delegate

extension DDAccountViewController: ValidationDelegate{
    
    func validationSuccessful() {
        self.cardButtonTapped("")
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
}

//MARK:- CustomFooter Delegate

extension DDAccountViewController: CustomFooterDelegate {
    func fotterButtonTapped() {
        
    }
}


//MARK:- AddAddress Delegate

extension DDAccountViewController: AddAdressDelegate {
    
    func completeAddress (_ value : Address){
        print(value)
        self.userAddress.append(value)
        self.addressTableView.reloadData()
    }
}


//MARK:- CreditCard Delegate

extension DDAccountViewController: AddCreditCardDelegate {
    
    func completeCreditCardAddress(_ value: CreditCard) {
        print(value)
        creditCardDetail.append(value)
        self.cardTableView.reloadData()
    }
}


//MARK:- WebService

extension DDAccountViewController {
    
    //MARK: -  EDIT PROFILE
    
    func editProfile() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "FName": self.firstNameField.textField.text!,
            "EmailAddress": self.emailField.textField.text!,
            "LName": self.lastNameField.textField.text!
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.editProfile(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    //MARK: -  GET CREDIT CARD DETAIL & GET USER ADDRESSES
    
    func getCreditCards(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "user_id":"\(AppStateManager.sharedInstance.loggedInUser.Id)",
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.creditCardDetail.count != 0{
                    self.creditCardDetail.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let creditData = responseResult["CreditCards"] as! NSArray
                print(creditData)
                for item in creditData{
                    let cardDetail = item as! NSDictionary
                    let cardObj = CreditCard(value:cardDetail)
                    self.creditCardDetail.append(cardObj)
                }
                self.cardTableView.reloadData()
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getCreditCards(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    func getUserAddress(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "user_id":"\(AppStateManager.sharedInstance.loggedInUser.Id)",
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.userAddress.count != 0{
                    self.userAddress.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let addressData = responseResult["addresses"] as! NSArray
                print(addressData)
                for item in addressData{
                    let addressDetail = item as! NSDictionary
                    let addressObj = Address(value:addressDetail)
                    self.userAddress.append(addressObj)
                }
                self.addressTableView.reloadData()
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
            
        }
        APIManager.sharedInstance.getUserAddress(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    //MARK:- REMOVE ADDRESS & CREDIT CARD
    
    func removeAddress(addressId: Int, userId: Int){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        
        let parameters: Parameters = [
            "address_id":addressId.description,
            "User_Id":userId.description,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message:"Address deleted SuccessFully" )
            }
            else if response?.intValue == 409 {
                self.showErrorWith(message: "User with this address deleted")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.removeAddress(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    func removeCreditCard(creditCardId: Int, userId: Int){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Card_Id":creditCardId.description,
            "User_Id":userId.description,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message:"Card deleted SuccessFully" )
            }
            else if response?.intValue == 409 {
                self.showErrorWith(message: "User with this credit card deleted")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.removeCreditCard(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
            
        }
    }
}

