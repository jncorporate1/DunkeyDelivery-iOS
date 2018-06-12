//
//  DDOrderViewController.swift
//  Template
//
//  Created by Ingic on 7/26/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DDOrderViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaiable
    
    var dataArray = Array<Array<String>>()
    var revealController = SWRevealViewController()
    var tapGesture : UITapGestureRecognizer!
    var orderArr = [Order] ()
    var orderCheck = [Bool]()
    var userObj = User()
    var viewCheck: Bool?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Orders"
        addMenuItemButtonToNavigationBar()
        setOrderArray()
        self.tableView.tableFooterView = UIView()
        self.tabBarController?.selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeNavigationBar()
        hideTabBarAnimated(hide:false)
        setViewToggle()
        self.tabBarController?.tabBar.tag = 1
        let type = 0 //userObj.Role
        let id = AppStateManager.sharedInstance.loggedInUser.Id
        getOrderHistory(userID: id,signInType: type,currentOrder: true,pageSize: 20,pageNo: 0)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    
    func setOrderArray(){
        dataArray.append([])
        dataArray.append(["One"])
        dataArray.append(["One"])
    }
    func setViewToggle(){
        self.revealViewController().delegate = self
        self.tapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.isEnabled = false
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
    }
    
    func eyeButtonTapped(sender: UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDOrderDetailViewController") as! DDOrderDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteButtonTapped(sender: UIButton){
        self.showToast(text: "This will be implemented in beta version.")
    }
}


//MARK: - UITableViewDelegate , UITableViewDataSource

extension DDOrderViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.orderArr.count//2//self.orderArr.count//self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 50
        }
        else{
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(orderCheck[section]){
            return 1
        }
        else{
            return self.orderArr[section].StoreOrders.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let item = orderArr[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! DDOrderTableViewCell
            cell.orderIdLabel.attributedText = self.attributedOrderString(id: item.Id)
            cell.arrowButton.tag = indexPath.section
            cell.arrowButton.addTarget(self, action: #selector(arrowTapped(sender:)), for: .touchUpInside)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! DDOrderTableViewCell
            let item = orderArr[indexPath.section].StoreOrders[indexPath.row - 1]
            let url = item.ImageUrl?.getURL()
            cell.storeImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.index = indexPath
            cell.storeName.text = item.StoreName
            cell.setStatus(status: item.Status)
            cell.delegate = self
            return cell
        }
        
    }
    
    func arrowTapped(sender: UIButton){
        if !(sender.isSelected){
            orderCheck[sender.tag] = true
        }
        else{
            orderCheck[sender.tag] = false
        }
        sender.isSelected = !sender.isSelected
        UIView.transition(with: self.view,
                          duration: 0.25,
                          options: [.curveEaseInOut, .transitionCrossDissolve],
                          animations: {
                            self.tableView.reloadData()
        }, completion: nil)
    }
    
    func attributedOrderString(id: Int)-> NSMutableAttributedString{
        let orderStr = NSMutableAttributedString()
        let idStr = NSMutableAttributedString()
        orderStr.normal("Order ID ", size: 15)
        idStr.bold("\(id)", size: 15)
        orderStr.append(idStr)
        return orderStr
    }
}


//MARK: - SWRevealViewControllerDelegate

extension DDOrderViewController: SWRevealViewControllerDelegate{
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right{
            self.tapGesture.isEnabled = true
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.tableView.isUserInteractionEnabled = false
        }
        else if position == FrontViewPosition.left{
            self.tapGesture.isEnabled = false
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.tableView.isUserInteractionEnabled = true
        }
    }
}


//MARK:- WebService

extension DDOrderViewController {
    
    
    func getOrderHistory(userID: Int,signInType: Int,currentOrder: Bool,pageSize: Int,pageNo: Int){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "UserID": userID.description,
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
                        self.orderCheck.append(false)
                    }
                    self.tableView.reloadData()
                }
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.getOrdersHistory(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
            
        }
        
    }
}

//MARK: - DDOrderTableViewCellDelegate

extension DDOrderViewController: DDOrderTableViewCellDelegate{
    func eyeButtonTap(index: IndexPath) {
        let item = orderArr[index.section].StoreOrders[index.row - 1]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDOrderDetailViewController") as! DDOrderDetailViewController
        vc.orderDetail = orderArr[index.section]
        vc.userStoreData = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func deleteButtonTap(index: IndexPath) {
        
    }
}


//MARK: -  DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDOrderViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "No Order(s)."
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 21),
            NSForegroundColorAttributeName: Color.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
}
