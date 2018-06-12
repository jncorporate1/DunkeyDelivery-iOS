//
//  DCMainViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/2/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

var tailorProduct = [ProductItem]()

@IBDesignable
class TailoringViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var storeID: Int = -1
    var categoryID: Int = -1
    var des: String!
    var laundry: Laundry!
    var selectedDate = ""
    var seletedTime = ""
    var objDeliverySchedule = DeliverySchedule()
    var selectedtailoring = [ProductItem]()
    var isQuantityLess: Bool!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.title = "Tailoring"
        self.addBackButtonToNavigationBar()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storeID = laundry.Store_Id
        categoryID = laundry.Id
        des = laundry.Description!
        self.navigationController?.navigationBar.isHidden = false
        setNavigationRightItems()
        getLaundryCategoryProducts()
        
    }
    
    //MARK: - Helping Method
    
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
    }
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func registerNib(){
        let tableViewCellNibName = UINib(nibName: "DCTailoringTableCellForCol", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell")
    }
    
    func addToBagTapped(){
        for item in tailorProduct{
            if item.quantity <= 0 {
            }
            else{
                isQuantityLess = true
                selectedtailoring.append(item)
            }
        }
        if isQuantityLess == true {
            objDeliverySchedule.OrderDelivery_dateNtime  = "\(selectedDate) \(seletedTime)"
            objDeliverySchedule.Type_Id = 12
            objDeliverySchedule.Store_Id = tailorProduct[0].Store_id
            objDeliverySchedule.Id = 0
            AppStateManager.sharedInstance.addMultipleItemsToCart(products: selectedtailoring, scheduleDelivery: objDeliverySchedule)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
            controller.isdealnPromotionEnable = true //for not show deliveryPopUP
            controller.objDeliverySchedule = objDeliverySchedule
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            self.showErrorWith(message: "Please set quantity")
        }
    }
    
    func estimateRowHeight() -> CGFloat {
        let totalitem = tailorProduct.count - 3
        
        if tailorProduct.count == 0{
            return 0
        }
        if totalitem <= 0{
            return 150.0
        }
        let value = CGFloat(150 * totalitem)
        return value
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension TailoringViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if(indexPath.row == 0){
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TailoringTableViewCell
            cell1.storeDescription.text = des
            return cell1
        }
        else if(indexPath.row == 1){
            cell = tableView.dequeueReusableCell(withIdentifier: "cell2")!
        }
        else if(indexPath.row == 2){
            let rowCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DCTailoringTableCellForCol
            rowCell.delegate = self
            return rowCell
        }
        else if(indexPath.row == 3){
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! TailoringTableViewCell
            print(cell4.instruction.text)
            return cell4
        }
        else if(indexPath.row == 4){
            let cell5 = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as! TailoringTableViewCell
            cell5.addToBagOutlet.addTarget(self, action: #selector(addToBagTapped), for: .touchUpInside)
            return cell5
        }
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 2){
            return self.estimateRowHeight()
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 5
    }
}


//MARK: - Web Service

extension TailoringViewController{
    
    //MARK: - Get Laundry Products
    
    func getLaundryCategoryProducts(){
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
                if tailorProduct.count != 0 {
                    tailorProduct.removeAll()
                }
                let responceResult = result["Result"] as! NSDictionary
                let laundryProductItem = responceResult["Products"] as! NSArray
                
                for item in laundryProductItem {
                    let value = item as! NSDictionary
                    let valueAdd = ProductItem(value:value)
                    valueAdd.Store_id = value["Store_Id"] as! Int
                    tailorProduct.append(valueAdd)
                }
                self.tableView.reloadData()
            }
        }
        APIManager.sharedInstance.getCategoryItems(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}


//MARK: - DCTailoringTableCellForColDelegate

extension TailoringViewController : DCTailoringTableCellForColDelegate{
    func stepperValueChanged(value: Int, indexPath: IndexPath) {
        
        print("->Tailor" + value.description + "indexpath" + indexPath.row.description)
        tailorProduct[indexPath.row].quantity = value
    }
}
