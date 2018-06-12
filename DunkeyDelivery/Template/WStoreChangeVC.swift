//
//  WStoreInfoViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol WStoreChangeDelegate {
    func callApi(item: Array<Any>)
}


class WStoreChangeVC: BaseController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var lastIndex : IndexPath!
    var selectedIndex = -1
    var pageType = -1
    var storesArray = [StoreItem]()
    var selectedStore = StoreItem()
    var isSelected: Bool = false
    var delegate: WStoreChangeDelegate!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.title = "Select a Store"
        self.tableView.tableFooterView = UIView()
        self.addBackButtonToNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        storeChangeAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helping Method
    
    func registerNib() {
        let tableViewCellNibName = UINib(nibName: "WStoreInfoChangeTC", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell")
    }
    
    //MARK: - Actions
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        if isSelected == true {
            var ids = UserDefaults.standard.array(forKey: "alcoholStoreIds")
            ids?[pageType - 2] = selectedStore.Id
            delegate?.callApi(item: ids!)
            UserDefaults.standard.set(ids, forKey: "alcoholStoreIds")
        }
        
       self.navigationController?.popToRootViewController(animated: true)
       // self.navigationController?.popViewController(animated: true)
    }
}


//MARK: -  UITableViewDelegate , UITableViewDataSource

extension WStoreChangeVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellView", for: indexPath) as! WStoreInfoChangeTC
        
        cell.radioButton.tag = indexPath.row
        cell.isCellSelected = true
        cell.separatorInset.left = 0
        cell.selectionStyle = .none
        
        if self.selectedIndex == indexPath.row{
            cell.setButtonSelected()
        }
        else{
            cell.deselectButton()
        }
      /*  if  let manger = AppStateManager.sharedInstance.selectedIndex  {
            if manger == indexPath.row {
                cell.setButtonSelected()
            }
        }*/
        
        let store = storesArray[indexPath.row]
        
        let name = AppStateManager.sharedInstance.saveSelectedStoreName
        if name.count>0{
            if name == store.BusinessName{
                cell.setButtonSelected()
            }
        }
        
        
        cell.storeNameLabel.text = store.BusinessName
        cell.storeRatingView.starSmall(items: Int(store.AverageRating))
        
        if store.MinDeliveryCharges.value != nil{
            cell.deliveryFeeLabel.text = "$\(store.MinDeliveryCharges.value!)"}
        if store.MinOrderPrice.value != nil{
            cell.minOrderPriceLabel.text = "$\(store.MinOrderPrice.value!)"}
        if store.Distance != nil{
            cell.distanceLabel.text = String(describing: store.Distance) + "m"}
        if store.MinDeliveryTime.value != nil{
            cell.timeLabel.text = String(describing: store.MinDeliveryTime.value!) + "min"}
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        selectedStore = storesArray[indexPath.row]
       // AppStateManager.sharedInstance.selectedIndex = selectedIndex
        AppStateManager.sharedInstance.saveSelectedStoreName = storesArray[indexPath.row].BusinessName
        self.tableView.reloadData()
        isSelected = true
    }
}

//MARK: - WebService

extension WStoreChangeVC {
    
    func storeChangeAPI() {
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Type": String(pageType),
            "longitude":"151.208953857422",//self.userLng
            "latitude":"-33.8826912922134",//self.userLat
            "Page":"0",
            "Items":"10"
        ]
    
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.storesArray.count != 0{
                    self.storesArray.removeAll()
                }
                print("Request Successful")
                let responseResult = result["Result"] as? NSDictionary
                let storeArr = responseResult!["Stores"] as! NSArray
                for item in storeArr{
                    let itemObj = item as! NSDictionary
                    let itemMod = StoreItem(value: itemObj)
                    self.storesArray.append(itemMod)
                }
                self.tableView.reloadData()
            }
        }
        APIManager.sharedInstance.getChangeAlcoholStore(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
            
        }
    }
}
