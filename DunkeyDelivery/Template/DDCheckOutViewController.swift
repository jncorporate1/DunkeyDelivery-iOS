//
//  DDCheckOutViewController.swift
//  Template
//
//  Created by Ingic on 7/11/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftyJSON
import Stripe

struct CartItem {
    var ItemId: Int = 0
    var ItemType: Int = 0
    var Qty: Int = 0
    var StoreId: Int = 0
    var dictionary: NSDictionary{
        return[
            "ItemId":ItemId,
            "ItemType":ItemType,
            "Qty":Qty,
            "StoreId":StoreId
        ]
    }
}
struct OrderSummary {
    var SubTotal :Double = 0
    var Tax: Double = 0
    var Tip: Double = 0
    var Total: Double = 0
    var DeliveryFee: Double = 0
    var SubTotalWDF: Double = 0
}

class DDCheckOutViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var oneTimeButton: UIButton!
    @IBOutlet weak var paypalButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cardButton: UIButton!
    
    //MARK: - Variable
    
    var footer = CheckOutFooterView()
    var header = CheckOutHeaderView()
    var cartItems = [Cart]()
    var selectedAddress: Address = Address()
    var selectedCreditCard: CreditCard = CreditCard()
    var storeCartItems = [CartItem]()
    var orderSum = OrderSummary()
    var userAddress = String()
    var paymentType : Int = 1
    var frequencyType : Int = 0
    var settingPoints: Setting!
    var orderHistoryObj = [Order] ()
    var stripeToken: String!
    var creditNumber: String!
    var ccv: String!
    var expiryDate: String!
    var creditaCardIsValid: Bool = false
    var isAddress: Bool = false
    var isCard:Bool = false
    var onceErrorShow: Bool = false
    var sendtip = ""
    var sendtax = ""
    var sendTaxPer = ""
    var sendDeliveyFee = ""
    var objOrderSummary = OrderSummary()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alwaysBounceVertical = false
        footer.delegate = self
        header.delegate = self
        tableView.tableFooterView = footer
        tableView.tableHeaderView = header
        header.tip.text = "Tip \(settingPoints.Tip)% "
        sendTaxPer = "\(settingPoints.Tip)"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let width = UIScreen.main.bounds.width
        footer.frame = CGRect(x: 0, y: 0, width: width, height: 206)
        header.frame = CGRect(x: 0, y: 0, width: width, height: 538) //with Frequency height: 680
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addBackButtonToNavigationBar()
        self.title = "Checkout"
        getCartAPI()
        setUpData()
        hideFrequencyView()
    }
    
    
    //MARK: - Helping Method
    
    func setUpData(){
        header.addressLabel.text = selectedAddress.FullAddress! + " ," + selectedAddress.PostalCode!
        let crdNmber = selectedCreditCard.CCNo!
        if crdNmber.count > 0 {
            let crdlast4 = crdNmber.substring(from:crdNmber.index(crdNmber.endIndex, offsetBy: -4))
            header.creditCardNumber.text = "Ends with "+crdlast4
            header.creditCardMonth.text = selectedCreditCard.ExpiryDate
        }
    }
    
  /*  func placeOrderButtonTapped(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDOrderScreenViewController") as! DDOrderScreenViewController
        vc.tax = sendtax
        vc.tip = sendtip
        vc.deliveyfeee = sendDeliveyFee
        vc.tipPer = sendTaxPer
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    func calculatTotalPrize (){
        var total: Double = 0
        for item in self.cartItems {
            let tprice = item.totalPrice
            total = tprice + total
        }
        self.footer.gainedPoints.text = (orderSum.SubTotalWDF * Double (self.settingPoints.Point)).description + " points"
    }
    
    func inserOrderAPI(){
        let items = AppStateManager.sharedInstance.getCartItems()
        var dicArr = [NSDictionary]()
        var dicArr1 = [NSDictionary]()
        for item in items{
            for obj in item.products{
                let item : NSDictionary = ["ItemId":obj.Id,
                                           "ItemType":obj.ItemId,
                                           "Qty":obj.quantity,
                                           "ProductSize": obj.SizeName!,
                                           "StoreId":obj.Store_id]
                dicArr.append(item)
            }
            let item1 : NSDictionary = ["Store_Id":item.scheduleTime.Store_Id,
                                        "Type_Id":item.scheduleTime.Type_Id,
                                        "OrderDateTime": item.scheduleTime.OrderDelivery_dateNtime!,
                                        "OrderDate":item.scheduleTime.OrderDelivery_dateNtime!,
                                        "MinDeliveryTime":0]
            dicArr1.append(item1)
        }
        let dic = ["CartItems":dicArr]
        
        let parameters: Parameters = [
            "UserId": AppStateManager.sharedInstance.loggedInUser.Id,
            "Cart": dic,
            "DeliveryAddress": self.userAddress,
            "PaymentMethodType": paymentType,
            "AdditionalNote": header.additionalNoteTextView.text!,
            "StripeAccessToken": stripeToken.description,
            "StoreDeliverytype": dicArr1
        ]
        self.insertOrder(parameters: parameters)
    }
    
    func addPaymentButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddCreditCardViewController") as! DDAddCreditCardViewController
        controller.setButtonTitle = "Continue"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getCartAPI(){
        let dictionary = AppStateManager.sharedInstance.getCartDic()
        let parameters: Parameters = [
            "Store": dictionary,
            "User_Id": AppStateManager.sharedInstance.loggedInUser.Id.description
        ]
        self.cartService(parameters: parameters)
    }
    
    func goToOrderScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDOrderScreenViewController") as! DDOrderScreenViewController
        controller.orderHistoryObj = orderHistoryObj
        controller.tax = "\(orderSum.Tax)"
        controller.tip = "\(orderSum.Tip)"
        controller.deliveyfeee = "\(orderSum.DeliveryFee)"
        controller.tipPer = sendTaxPer
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func gotoAddress(_ message: String){
        self.showErrorWith(message: message)
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideFrequencyView(){
        header.frequencyView.isHidden = true
        header.frequencyLabel.isHidden = true
        header.frequencyInnerView.isHidden = true
        header.frequencyLineView.isHidden = true
        header.oneTimeButton.isHidden = true
        header.weeklyButton.isHidden = true
        header.monthlyButton.isHidden = true
        header.paypalButton.isHidden = true
        header.frequencyHeight.constant = 0
        header.cardButton.isHidden = true
        header.paypalButton.isHidden = true
        header.paymentView.isHidden = true
    }
    
    func setOrderSummary(summary: NSDictionary){
        orderSum.SubTotal = summary["SubTotal"] as! Double
        orderSum.Tax = summary["Tax"] as! Double
        orderSum.Tip = summary["Tip"] as! Double
        orderSum.Total = summary["Total"] as! Double
        orderSum.DeliveryFee = summary["DeliveryFee"] as! Double
        orderSum.SubTotalWDF = summary["SubTotalWDF"] as! Double
        self.sendtip = "\(orderSum.Tip )"
        self.sendtax = "\(orderSum.Tax )"
        self.sendDeliveyFee = "\( orderSum.DeliveryFee )"
        self.header.setOrderSummaryView(sum: orderSum)
    }
    
    func setUserAddress(address: NSDictionary){
        
        if let fullAddress = address["FullAddress"] as? String{
            if let postalcode = address["PostalCode"] as? String{
                let setAddress = fullAddress + ", " + postalcode
                self.header.setUserAddress(address: setAddress)
                self.userAddress = fullAddress
                self.header.addnewAddressButton.isHidden = true
            }
        }
        else{
            self.header.setUserAddress(address: "N/A")
        }
    }
    
    func setUserCreditCard(card: NSDictionary){
        
        if let fullAddress = card["CCNo"] as? String{
            if let postalcode = card["ExpiryDate"] as? String{
                let setNumber = fullAddress
                let setMonth = postalcode
                self.creditNumber = setNumber
                self.ccv = card["CCV"] as? String
                self.expiryDate = setMonth
                self.header.setUserCreditCard(card: setNumber, month: setMonth )
                self.header.addnewCardButton.isHidden = true
            }
        }
        else{
            self.header.setUserCreditCard(card: "N/A", month: "" )
            
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension DDCheckOutViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems[section].products.count + 1//return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let storeItem = cartItems[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! DDAddToBagTableViewCell
            cell.selectionStyle = .none
            cell.storeName.text = storeItem.storeName
            cell.deliveryTime.text = "Delivery in "+"\(storeItem.minDeliveryTime)"+" min"
            cell.storePrice.text = "\(storeItem.totalPrice)"
            return cell
        }
        else{
            let item = cartItems[indexPath.section].products[indexPath.row - 1]
            if item.Name == "Delivery Fee"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "deliveryChargesCell", for: indexPath) as! DDAddToBagTableViewCell
                cell.productPrice.text = "Price $" + (item.Price.value!).description
                cell.selectionStyle = .none
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! DDAddToBagTableViewCell
                cell.productName.text = item.Name
                cell.productDes.text = item.Description
                cell.productPrice.text = "Price $"+(item.Price.value!).description
                cell.productQuantity.text = "  "+"\(item.quantity)"+"  "
                cell.productQuantity.backgroundColor = Constants.APP_COLOR
                let url = item.Image?.getURL()
                cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }
        else{
            return 100
        }
    }
}

//MARK: - CheckOutFooterViewDelegate

extension DDCheckOutViewController: CheckOutFooterViewDelegate{
    func placeOrderButtonTap() {
        onceErrorShow = false
        if isAddress == true && isCard == true {
            onceErrorShow = true
            self.showErrorWith(message: "Add at least one delivery address and card to proceed.")
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        if onceErrorShow == false {
            if isAddress == true{
                self.showErrorWith(message: "Add at least one delivery address to proceed.")
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
            if isCard == true{
                self.showErrorWith(message: "Add at least one card to proceed.")
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        if isAddress == true && onceErrorShow == false{
            self.showErrorWith(message: "Add at least one delivery address to proceed.")
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        if isCard == true && onceErrorShow == false {
            self.showErrorWith(message: "Add at least one card to proceed.")
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
        if isAddress == false && isCard == false {
            if creditaCardIsValid == false {
                self.startLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
                    self.inserOrderAPI()
                })
            }
            else {
                self.showErrorWith(message: "Your card's number is invalid")
            }
        }
    }
}

//MARK: - Stripe

extension DDCheckOutViewController{
    
    func setUpStripe(){
        self.startLoading()
        let stripCard = STPCardParams()
        let expirationDate = self.expiryDate.components(separatedBy: "/")
        let expMonth: UInt =  UInt(expirationDate[0])!
        let expYear : UInt =  UInt(expirationDate[1])!
        stripCard.number = self.creditNumber
        stripCard.cvc = self.ccv
        stripCard.expMonth = expMonth
        stripCard.expYear = expYear
        
        STPAPIClient.shared().createToken(withCard: stripCard) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                print("\(String(describing: error))") 
                self.showErrorWith(message: "Your card's number is invalid")
                self.creditaCardIsValid = true
                self.stopLoading()
                return
            }
            self.stripeToken = token.description
            self.creditaCardIsValid = false
            self.stopLoading()
        }
    }
}


//MARK: - CheckOutHeaderViewDelegate

extension DDCheckOutViewController: checkOutHeaderViewDelegate{
    
    func addNewAddress() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddAddressViewController") as! DDAddAddressViewController
        controller.setButtonTilte = "Continue"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func addNewCard() {
        addPaymentButtonTapped()
    }
    
    
    func deliverInfoTap(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDDeliveryInfoViewController") as! DDDeliveryInfoViewController
        controller.delegate = self
        controller.viewCheck = "Address"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func creditCardTap(){
        addPaymentButtonTapped()
    }
    
    func paymentMethodTapped(value: Int) {
        paymentType = value
        if value == 0 {
            print("Credit")
        }
        else{
            self.showErrorWith(message: "paypal")
        }
    }
    
    func setFrequencyTapped(value: Int) {
        frequencyType = value
    }
    
    func creditCardInfoTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDDeliveryInfoViewController") as! DDDeliveryInfoViewController
        controller.delegate = self
        controller.viewCheck = "Credit"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - DeliveryInfoView Delegate

extension DDCheckOutViewController: DeliveryInfoViewDelegate {
    
    func selectedCreditCard(_ value: CreditCard) {
        selectedCreditCard = value
    }
    
    func selectedAddress(_ value: Address) {
        selectedAddress = value
        userAddress = value.FullAddress!
    }
}


//MARK:- WebService

extension DDCheckOutViewController {
    
    //MARK:- CartService
    
    func cartService(parameters: Parameters) {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Success")
                if self.cartItems.count != 0{
                    self.cartItems.removeAll()
                }
                
                self.stopLoading()
                
                let responseResult = result["Result"] as! NSDictionary
                let stores = responseResult["Store"] as! NSArray
                let orderDetails = responseResult["OrderSummary"] as! NSDictionary
                
                var addressDetails: NSDictionary! = NSDictionary()
                var cardDetails: NSDictionary! = NSDictionary()
                
                if (responseResult["CreditCard"] as? NSDictionary) != nil {
                    cardDetails = responseResult["CreditCard"] as! NSDictionary
                    self.setUserCreditCard(card: cardDetails)
                    self.setUpStripe()
                    self.isCard = false
                    self.header.creditCardButton.isUserInteractionEnabled = true
                } else {
                    self.header.setUserCreditCard(card: "N/A", month: "" )
                    self.header.addnewCardButton.isHidden = false
                    self.header.creditCardButton.isUserInteractionEnabled = false
                    self.isCard = true
                }
                
                if (responseResult["Address"] as? NSDictionary) != nil {
                    addressDetails = responseResult["Address"] as! NSDictionary
                    self.setUserAddress(address: addressDetails)
                    self.isAddress = false
                    self.header.deliveryInformationOutlet.isUserInteractionEnabled = true
                    
                } else {
                    self.header.setUserAddress(address: "N/A")
                    self.header.addnewAddressButton.isHidden = false
                    self.isAddress = true
                    self.header.deliveryInformationOutlet.isUserInteractionEnabled = false
                }
                
                for store in stores{
                    let storeItem = store as! NSDictionary
                    let item = Cart(value: storeItem)
                    self.cartItems.append(item)
                }
                
                self.setOrderSummary(summary: orderDetails)
                self.calculatePrice(items: self.cartItems)
                self.calculatTotalPrize()
                self.tableView.reloadData()
            }
                
            else if(response?.intValue == 400){
                let dic = [String: String]()
                self.setUserAddress(address: dic as NSDictionary)
                self.setUserCreditCard(card: dic as NSDictionary)
                let responseResult = result["Result"] as! NSDictionary
                let msg = responseResult["ErrorMessage"] as! String
                //  self.gotoAddress(msg)
                self.stopLoading()
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getCartMobile(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    

    
    
    //MARK:- Insert Order
    
    func insertOrder(parameters: Parameters) {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Success")
                
                if self.orderHistoryObj.count != 0{
                    self.orderHistoryObj.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let orderObj = Order(value:responseResult)
                self.orderHistoryObj.append(orderObj)
                AppStateManager.sharedInstance.clearCartData()
                self.goToOrderScreen()
            }
            else{
                if let errorMessage = result["Message"] as? String{
                    self.showErrorWith(message: errorMessage)
                    return
                }
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.insertOrder(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
