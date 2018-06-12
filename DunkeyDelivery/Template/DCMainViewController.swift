//
//  DCMainViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

var dryCleanProduct = [ProductItem]()

@IBDesignable
class DCMainViewController: BaseController {
    
    
    //MARK: - IBOulet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaibles
    
    var isItemize : Bool!
    var storeID: Int = -1
    var categoryID: Int = -1
    var dateNtime: String!
    var des = ""
    var laundry: Laundry!
    var selectedDryProduct = [ProductItem]()
    var isQuantityLess: Bool!
    var objDeliverySchedule = DeliverySchedule()
    var selectedDate = ""
    var seletedTime = ""
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isItemize = false
        self.title = "Dry Cleaning"
        self.addBackButtonToNavigationBar()
        self.registerNib()
        self.registerNot()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationRightItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storeID = laundry.Store_Id
        categoryID = laundry.Id
        des = laundry.Description!
        self.navigationController?.navigationBar.isHidden = false
        getLaundryCategoryProducts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func registerNib(){
        let tableViewCellNibName = UINib(nibName: "DCCustomTableCellForCol", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell")
    }
    
    func registerNot(){
        NotificationCenter.default.addObserver(self, selector: #selector(DCMainViewController.itemizeDown(notification:)), name: Notification.Name("itemizeDown"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DCMainViewController.entireLoadDown(notification:)), name: Notification.Name("entireLoadDown"), object: nil)
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
    
    func estimateRowHeight() -> CGFloat {
        let totalitem = dryCleanProduct.count - 3
        if dryCleanProduct.count == 0{
            return 0
        }
        
        if totalitem <= 0{
            return 150.0
        }
        let value = CGFloat(150 * totalitem)
        return value
    }
    
    
    //MARK: - Actions
    
    @IBAction func addToBagTapped(_ sender: Any) {
        
        if(isItemize){
            for item in dryCleanProduct{
                if item.quantity <= 0 {
                }
                else{
                    isQuantityLess = true
                    selectedDryProduct.append(item)
                }
            }
            if isQuantityLess == true {
                objDeliverySchedule.OrderDelivery_dateNtime  = "\(selectedDate) \(seletedTime)"
                objDeliverySchedule.Type_Id = 12
                objDeliverySchedule.Store_Id = selectedDryProduct[0].Store_id
                objDeliverySchedule.Id = 0 
                AppStateManager.sharedInstance.addMultipleItemsToCart(products: selectedDryProduct, scheduleDelivery: objDeliverySchedule)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
                controller.isdealnPromotionEnable = true //for not show deliveryPopUP
                controller.objDeliverySchedule = objDeliverySchedule
                self.navigationController?.pushViewController(controller, animated: true)
            }
            else{
                self.showErrorWith(message: "Please set quantity")
            }
        }else{
            requestGetCloth()
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension DCMainViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DryCleanTableViewCell
            cell.storeDescription.text = des
            return cell
            
        }
        else if(indexPath.row == 1){
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
        }
        else if(indexPath.row == 2){
            if(isItemize){
                let rowCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DCCustomTableCellForCol
                rowCell.delegate = self as DCCustomTableCellForColDelegate
                return rowCell
            }
            else{
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3")!
            }
        }
        else if(indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! DryCleanTableViewCell
            print(cell.instruction.text)
            return cell
        }
        else if(indexPath.row == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! DryCleanTableViewCell
            if(isItemize){
                cell.addtobagOutlet.setTitle("Add to Bag", for: .normal)
            }
            else{
                cell.addtobagOutlet.setTitle("Submit", for: .normal)
            }
            return cell
        }
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 2 && isItemize){
            return self.estimateRowHeight()
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 5
    }
}


//MARK: - Toggle View

extension  DCMainViewController {
    func itemizeDown(notification: Notification) {
        isItemize = true
        tableView.reloadData()
    }
    
    func entireLoadDown(notification: Notification) {
        isItemize = false
        tableView.reloadData()
    }
}


//MARK: - Web Service

extension DCMainViewController{
    
    
    //MARK: - Get Laundry Products
    
    func getLaundryCategoryProducts(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "Store_id": storeID.description ,
            "ParentCategory_id": categoryID.description ,
            "Page":"0",
            "Items":"0"
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            if(response?.intValue == 200){
                if dryCleanProduct.count != 0 {
                    dryCleanProduct.removeAll()
                }
                let responceResult = result["Result"] as! NSDictionary
                let laundryProductItem = responceResult["Products"] as! NSArray
                for item in laundryProductItem {
                    let value = item as! NSDictionary
                    let valueAdd = ProductItem(value:value)
                    valueAdd.Store_id = value["Store_Id"] as! Int
                    dryCleanProduct.append(valueAdd)
                }
            }
        }
        APIManager.sharedInstance.getCategoryItems(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    //MARK: - Submit AdditionalNote
    
    func requestGetCloth() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let index = IndexPath(row: 3, section: 0)
        let cell = self.tableView.cellForRow(at: index) as! DryCleanTableViewCell
        let parameters: Parameters = [
            
            "Store_Id": storeID.description,
            "User_Id": (AppStateManager.sharedInstance.loggedInUser.Id).description,
            "Weight": " ",
            "AdditionalNote": cell.instruction.text,
            "PickUpTime":dateNtime,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                self.showSuccessWith(message: "Instruction added successfully.")
                //self.navigateToNext()
            }
            else if(response?.intValue == 409){
                self.showErrorWith(message: "You already requested to Get Cloths for today.")
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


//MARK: - DCCustomTableCellForColDelegate

extension DCMainViewController: DCCustomTableCellForColDelegate{
    func stepperValueChanged(value: Int, indexPath: IndexPath) {
        print( "->" + indexPath.row.description + value.description)
        dryCleanProduct[indexPath.row].quantity = value
    }
}
