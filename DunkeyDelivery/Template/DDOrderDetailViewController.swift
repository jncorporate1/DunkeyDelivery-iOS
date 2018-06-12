//
//  DDOrderDetailViewController.swift
//  Template
//
//  Created by Ingic on 8/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDOrderDetailViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var userStoreData = UserStoreOrders()
    var orderDetail = Order()
    var userObj = User()
    var orderArr = [Order]()
    var userStoreArr = [UserStoreOrders] ()
    var appDel = UIApplication.shared.delegate as! AppDelegate
    var isView: Bool = false
    var isnotification : Bool = false
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Order Detail"
        self.addBackButtonToNavigationBar()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appDel = UIApplication.shared.delegate as! AppDelegate
        if appDel.isOrderScreen{
            self.notificationBackButton()
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            let type = 0 //userObj.Role
            let id = AppStateManager.sharedInstance.loggedInUser.Id
            let norderId = UserDefaults.standard.object(forKey: "orderID") as! String
            let norderStoreId = UserDefaults.standard.object(forKey: "orderStoreID") as! String
            self.getOrderNotificationHistory(userID: id,orderId: norderId,storeId: norderStoreId ,signInType: type,currentOrder: true,pageSize: 10,pageNo: 0)
        }
        else{
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension DDOrderDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            if isView == true{
                return orderArr.count
            }
            else{
                return userStoreData.OrderItems.count
            }
        }
        else{
            if appDel.isOrderScreen {
                return 0
            }
            else{
                return 1
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DDOrderDetailTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            //for Notification
            if isView == true {
                _ = orderArr[0]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DDOrderDetailTableViewCell
                let order = userStoreArr[0].OrderDeliveryTime!
                if order.count > 0 {
                    let splitOrderDate = order.components(separatedBy: " ")
                    if splitOrderDate.count > 1 {
                        _ = splitOrderDate[0]
                    let time   = splitOrderDate[1]
                    let dn     = splitOrderDate[2]
                    let date   = Utility.convertDateFormatter(date: order, withFormat: "dd MMM yyyy")
                    cell.orderDateLabel.text = "\(date)"
                    cell.orderTimeLabel.text = "\(time) \(dn)"
                    cell.orderTipAmount.text = "$ \(orderArr[0].TipAmount)%"
                    cell.orderTax.text = "$" + (orderArr[0].TotalTaxDeducted).description
                    }
                    else{
                        cell.orderDateLabel.text = ""
                        cell.orderTimeLabel.text = ""
                    }
                }
                else{
                    cell.orderDateLabel.text = ""
                    cell.orderTimeLabel.text = ""
                }
                return cell
            } // End Notification
                
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DDOrderDetailTableViewCell
                let order = userStoreData.OrderDeliveryTime!
                if order.count > 0 {
                    let time = Utility.convertDateFormatter(date: order, withFormat: "hh:mm a")
                    let date = Utility.convertDateFormatter(date: order, withFormat: "dd MMM yyyy")
                    cell.orderDateLabel.text = "\(date)"
                    cell.orderTimeLabel.text = "\(time)"
                    cell.orderTipAmount.text = "$\(orderDetail.TipAmount)"
                    cell.orderTax.text =  "$" + (orderDetail.TotalTaxDeducted).description
                }
                else{
                    cell.orderDateLabel.text = ""
                    cell.orderTimeLabel.text = ""
                }
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.section == 2{
            if isView == true {
                let item = userStoreArr[0].OrderItems[0]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDOrderDetailTableViewCell
                cell.productName.text = item.Name
                let url = item.ImageUrl?.getURL()
                cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                cell.quantity.text =  (item.Qty).description
                cell.quantity.layer.cornerRadius = 12
                cell.quantity.textAlignment = .center
                cell.quantity.layer.masksToBounds = true
                cell.quantity.backgroundColor = Constants.APP_COLOR
                cell.productPrice.text = "Price $" + "\(item.Price)"
                cell.selectionStyle = .none
                return cell
            }
            else{
                let item = userStoreData.OrderItems[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDOrderDetailTableViewCell
                cell.productName.text = item.Name
                let url = item.ImageUrl?.getURL()
                cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                cell.quantity.text =  (item.Qty).description
                cell.quantity.layer.cornerRadius = 12
                cell.quantity.textAlignment = .center
                cell.quantity.layer.masksToBounds = true
                cell.quantity.backgroundColor = Constants.APP_COLOR
                cell.productPrice.text = "Price $" + "\(item.Price)"
                cell.selectionStyle = .none
                return cell
            }
        }
        else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! DDOrderDetailTableViewCell
            if isView == true {
                cell.subTotalLabel.text = "$" + (userStoreArr[0].Subtotal).description
                cell.deliveryfee.text = "$" + (orderArr[0].DeliveryFee).description
                cell.totalLabel.text = (orderArr[0].Total).description
                /*cell.tipFeeLabel.text = "$ \(orderArr[0].TipAmount)%"
                cell.taxLabel.text = "$" + (orderArr[0].TotalTaxDeducted).description*/
                cell.selectionStyle = .none
                return cell
            }
            else{
                cell.subTotalLabel.text = "$" + (userStoreData.Subtotal).description
                cell.deliveryfee.text =  "$" + (orderDetail.DeliveryFee).description
                cell.totalLabel.text = "$" + (orderDetail.Total).description
             /*   cell.tipFeeLabel.text = "$\(orderDetail.TipAmount)"
                cell.taxLabel.text = "$" + (orderDetail.TotalTaxDeducted).description*/
                cell.selectionStyle = .none
                return cell
            }
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DDOrderDetailTableViewCell
            if isView == true {
                cell.deliveryAddLabel.text = orderArr[0].DeliveryDetails_Address
                cell.separatorInset.left = 0
                cell.selectionStyle = .none
            }
            else{
                cell.deliveryAddLabel.text = orderDetail.DeliveryDetails_Address
                cell.separatorInset.left = 0
                cell.selectionStyle = .none
            }
            return cell
        }
        
    } //End of cellforRow
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 80
        }
        else if indexPath.section == 1{
            if isnotification == true {
                return 0
            }else{
                return 90
            }
        }
        else if indexPath.section == 2{
            return 100
        }
        else if indexPath.section == 3{
            return 80
        }
        else {
            return 90
        }
    }
}

//MARK: - WEb Service

extension DDOrderDetailViewController {
    
    
    
    
    func getOrderNotificationHistory( userID: Int,orderId: String,storeId: String ,signInType: Int,currentOrder: Bool,pageSize: Int,pageNo: Int){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "UserId": userID.description,
            "OrderId": orderId,
            "StoreOrder_Id": storeId,
            "SignInType": signInType.description,
            "IsCurrentOrder": currentOrder.description,
            "PageSize": pageSize.description,
            "PageNo": pageNo.description
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                let responseResult = result["Result"] as! NSDictionary
                if self.orderArr.count != 0{
                    self.orderArr.removeAll()
                }
                if let orderItems = responseResult["orders"] as? NSArray{
                    for item in orderItems {
                        let itemObj = item as! NSDictionary
                        let ordObj = Order(value: itemObj)
                        self.orderArr.append(ordObj)
                        
                        let storeOrderObj = itemObj["StoreOrders"] as? NSArray
                        for item in storeOrderObj! {
                            let itemObj = item as! NSDictionary
                            let storeObj = UserStoreOrders(value: itemObj)
                            self.userStoreArr.append(storeObj)
                        }
                    }
                    self.appDel.isOrderScreen = false
                    self.isView = true
                    self.tableView.reloadData()
                }
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.getOrderNotification(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
