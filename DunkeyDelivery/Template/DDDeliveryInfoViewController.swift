//
//  DDDeliveryInfoViewController.swift
//  Template
//
//  Created by Ingic on 8/14/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol DeliveryInfoViewDelegate {
    func selectedAddress (_ value: Address)
    func selectedCreditCard(_ value: CreditCard)
}

class DDDeliveryInfoViewController: BaseController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var addressfield: DDTextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var addressArray: [Address] = []
    var creditCardArray : [CreditCard] = []
    var delegate: DeliveryInfoViewDelegate!
    var sendAddress: Address = Address()
    var sendCard: CreditCard = CreditCard()
    var selectedIndex = -1
    var rowSelectedAgain :Bool = false
    var viewCheck: String!
    var refreshControl = UIRefreshControl()
    var tableViewSelectedIndex:IndexPath?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
          if viewCheck == "Address"{
            self.title = "Delivery Information"
          }else{
            self.title = "Credit Card Information"
        }
        self.addBackButtonToNavigationBar()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addressfield.textField.textColor = Constants.APP_GRAY_COLOR
        if viewCheck == "Address"{
            self.addressfield.textField.text = "Add new address"
            getUserAddress()
        }
        else{
            self.addressfield.textField.text = "Add new credit card"
            getCreditCards()
        }
      //  setScrollView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - User Interaction
    
    
    func setScrollView(){
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        refreshControl.tintColor = Constants.APP_COLOR
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshControl)
        NSLayoutConstraint(item: refreshControl, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
         refreshData(refreshContrl: refreshControl)
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        view.addSubview(scrollView)
        refreshData(refreshContrl: refreshControl)
    }
    
    
    func didPullToRefresh(_ refresh: UIRefreshControl ) {
        refreshData(refreshContrl: refresh )
    }
    
    func refreshData(refreshContrl: UIRefreshControl ){
        refreshContrl.endRefreshing()
    }
    
    func updateButtonTapped(){
         if viewCheck == "Address"{
        delegate.selectedAddress(sendAddress)
            updateUserAddress(userId: AppStateManager.sharedInstance.loggedInUser.Id,addressId: sendAddress.Id)
        }
         else{
            delegate.selectedCreditCard(sendCard)
            updateUserCreditCard(userId: AppStateManager.sharedInstance.loggedInUser.Id, creditCardID: sendCard.Id)
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Actions
    
    @IBAction func addressFieldTapped(_ sender: Any) {
        
        if viewCheck == "Address"{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddAddressViewController") as! DDAddAddressViewController
            vc.setButtonTilte = "Continue"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddCreditCardViewController") as! DDAddCreditCardViewController
            vc.setButtonTitle = "Continue"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension DDDeliveryInfoViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if viewCheck == "Address"{
                return self.addressArray.count
            }
            else {
                return creditCardArray.count
            }
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! DDDeliveryInfoTableViewCell
            cell.selectionStyle = .none
             cell.setButtonUnSelected()
            if viewCheck == "Address"{
                
                let addressItem = addressArray[indexPath.row]
                cell.addressLabel.text = addressItem.FullAddress! + " ," + addressItem.PostalCode!
                
                if  addressItem.IsPrimary == true && rowSelectedAgain == false {
                    cell.setButtonSelected()
                }
                else {
                    cell.setButtonUnSelected()
                }

             }
                
            else {
                
                let creditItem = creditCardArray[indexPath.row]
                cell.addressLabel.text = creditItem.CCNo! //+ " ," + creditItem.PostalCode!
                
                if  creditItem.Is_Primary == 1 && rowSelectedAgain == false {
                    cell.setButtonSelected()
                }
                else {
                     cell.setButtonUnSelected()
                    }
                }
                 return cell
            } // End IndexPath.row = 0
           
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! DDDeliveryInfoTableViewCell
            
            if viewCheck == "Address"{
                cell.updateButton.setTitle("Update Address", for: .normal)
            }
            else{
                 cell.updateButton.setTitle("Update Card", for: .normal)
            }
            
           cell.updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
               return cell
        }
        
    } // end of cellForRow
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        }
        else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        rowSelectedAgain = true
        self.tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as! DDDeliveryInfoTableViewCell
        cell.setButtonSelected()
        sendAddress = Address ()
        sendCard = CreditCard()
        if viewCheck == "Address"{
           sendAddress = addressArray[indexPath.row]
        }
        else{
            sendCard  = creditCardArray[indexPath.row]
        }
    }
}

//MARK: - Web Service

extension DDDeliveryInfoViewController {
    
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
                if self.addressArray.count != 0{
                    self.addressArray.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let addressData = responseResult["addresses"] as! NSArray
                print(addressData)
                for item in addressData{
                    let addressDetail = item as! NSDictionary
                    let addressObj = Address(value:addressDetail)
                    self.addressArray.append(addressObj)
                }
                self.tableView.reloadData()
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
    
    
    // Update User Address
    
    func updateUserAddress(userId: Int ,addressId: Int){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "User_id": userId.description,
            "Address_Id": addressId.description ]
        
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! Int!
            if(response == 200){
                print("Request Successful")
                self.showSuccessWith(message: "Update selected Address")
            }
                
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        self.startLoading()
        APIManager.sharedInstance.getUpdateUserAddress(parameters: parameters, success: successClosure){ (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
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
                if self.creditCardArray.count != 0{
                    self.creditCardArray.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let creditData = responseResult["CreditCards"] as! NSArray
                print(creditData)
                for item in creditData{
                    let cardDetail = item as! NSDictionary
                    let cardObj = CreditCard(value:cardDetail)
                    self.creditCardArray.append(cardObj)
                }
                self.tableView.reloadData()
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
    
    func updateUserCreditCard(userId: Int ,creditCardID: Int){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "User_id": userId.description,
            "Creditcard_Id": creditCardID.description,
            "Mark":"true" ,
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! Int!
            if(response == 200){
                print("Request Successful")
                self.showSuccessWith(message: "Update selected Card")
            }
                
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        self.startLoading()
        APIManager.sharedInstance.getUpdateUserCreditCard(parameters: parameters, success: successClosure){ (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}


