//
//  WStoreInfoViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/5/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class WStoreInfoViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaibles
    
    var alcoholArray = [StoreItem]()
    var alcoholCategoryArray = [Category]()
    var cCount: Int = 0
    var apiCall: Bool = false
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.title = "Store Info"
        self.addBackButtonToNavigationBar()
        self.tableView.tableFooterView = UIView()
        //setUpAlcoholCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBarAnimated(hide: true)
         setUpAlcoholCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func registerNib(){
        let tableViewCellNibName = UINib(nibName: "WStoreInfoTableCell", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell")
    }
    
    
    func setUpAlcoholCategories(){
        for items in alcoholArray{
            for citems in items.Categories{
                if citems.Name == "Wine" || citems.Name == "Liquor"{
                    if cCount == 0 { // Wine & Liqour can be add on Array only One Time
                        alcoholCategoryArray.append(citems)
                        cCount = 1
                    }
                }
                if citems.Name == "Beer" {
                    alcoholCategoryArray.append(citems)
                }
            }
        }
    }
    
    func changeBtnDown(sender: UIButton) {
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WStoreChangeVC") as! WStoreChangeVC
        controller.pageType = sender.tag + 2
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func reviewButtonTapped(sender: UIButton){
        //    DDDetailViewController
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.viewCellCheck = true
        vc.navigationTilte = "Wine Wisdom"
        vc.storeData = alcoholArray[sender.tag]
        //        vc.viewCheck = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func storeInfoButtonTapped(sender: UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.viewCheck = true
        vc.navigationTilte = "Wine Wisdom"
        vc.viewCellCheck = true
        vc.storeData = alcoholArray[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - UITableViewDelegate , UITableViewDataSource

extension WStoreInfoViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if alcoholArray.count == 1 { //&& apiCall == false{
            return alcoholCategoryArray.count
        }
        else{
            return  alcoholArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 203
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WStoreInfoTableCell
        
        if alcoholArray.count == 1 {//} && apiCall == false{ //If store.count is 1 then caterories vice tableview reload
            let item = alcoholArray[0]
            let catItem = alcoholCategoryArray[indexPath.row]
            if catItem.Name == "Wine" ||  catItem.Name == "Liquor" {
                cell.mainTitleLabel.text = "Wine & liqour store"
            }
            else{
                cell.mainTitleLabel.text = "Beer store"
            }
            let url = item.ImageUrl?.getURL()
            cell.storeImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.storeNameLabel.text = item.BusinessName
            cell.ratingView.starSmall(items: Int(item.AverageRating))
            cell.ratingView.smallCount.text = String(describing: item.AverageRating)
            
            if item.MinDeliveryCharges.value != nil{
                cell.deliveryChargesLabel.text = "$ \(item.MinDeliveryCharges.value!)"}
            
            if item.MinOrderPrice.value != nil{
                cell.minimunOrderPrice.text = "$ \(item.MinOrderPrice.value!)"}
            
            if item.MinDeliveryTime.value != nil{
                cell.timeLabel.text = "\(item.MinDeliveryTime.value!)" + " min"}
            
            let value = Double (item.Distance)
            let distanceValue = Double(round(100*value)/100)
            cell.distanceLabel.text = "\(distanceValue) m"
            
            var tags = [String]()
            alcoholArray[0].storeTags.forEach({ (tag) in
                tags.append(tag.Tag)
            })
            
            if tags.count != 0 {
                cell.tag1Label.text = " "+"\(tags[0])"+"     "
                cell.tag2Label.text = " "+"\(tags[1])"+"     "
            } else {
                cell.tag1Label.isHidden = true
                cell.tag2Label.isHidden = true
            }
            cell.changeBtn.tag = indexPath.row
            cell.seeReviewButton.tag = indexPath.row
            cell.storeInfoButton.tag = indexPath.row
            cell.seeReviewButton.addTarget(self, action: #selector(reviewButtonTapped(sender:)), for: .touchUpInside)
            cell.storeInfoButton.addTarget(self, action: #selector(storeInfoButtonTapped(sender:)), for: .touchUpInside)
            return cell
        }
            
        else{
            
            let item = alcoholArray[indexPath.row]
            if indexPath.row == 0 {
                cell.mainTitleLabel.text = "Wine & liqour store"
            }
            else {
                cell.mainTitleLabel.text = "Beer store"
            }
            let url = item.ImageUrl?.getURL()
            cell.storeImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.storeNameLabel.text = item.BusinessName
            cell.ratingView.starSmall(items: Int(item.AverageRating))
            cell.ratingView.smallCount.text = String(describing: item.AverageRating)
            
            if item.MinDeliveryCharges.value != nil{
                cell.deliveryChargesLabel.text = "$ \(item.MinDeliveryCharges.value!)"}
            
            if item.MinOrderPrice.value != nil{
                cell.minimunOrderPrice.text = "$ \(item.MinOrderPrice.value!)"}
            
            if item.MinDeliveryTime.value != nil{
                cell.timeLabel.text = "\(item.MinDeliveryTime.value!)" + " min"}
            
            cell.distanceLabel.text = String(describing: item.Distance) + "m"
            
            var tags = [String]()
            alcoholArray[indexPath.row].storeTags.forEach({ (tag) in
                tags.append(tag.Tag)
            })
            
            if tags.count != 0 {
                cell.tag1Label.text = " "+"\(tags[0])"+"     "
                cell.tag2Label.text = " "+"\(tags[1])"+"     "
            } else {
                cell.tag1Label.isHidden = true
                cell.tag2Label.isHidden = true
            }
            cell.changeBtn.tag = indexPath.row
            cell.seeReviewButton.tag = indexPath.row
            cell.storeInfoButton.tag = indexPath.row
            cell.seeReviewButton.addTarget(self, action: #selector(reviewButtonTapped(sender:)), for: .touchUpInside)
            cell.storeInfoButton.addTarget(self, action: #selector(storeInfoButtonTapped(sender:)), for: .touchUpInside)
            return cell
        }
    }
}


//MARK: - WStoreChangeDelegate

extension WStoreInfoViewController:WStoreChangeDelegate{
    func callApi(item: Array<Any>) {
        // self.alcohalApiCall(item)
    }
}


//MARK: - WebService

extension WStoreInfoViewController{
    
    func alcohalApiCall(_ value : Array<Any>) {
        //self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        var stringID = ""
         //UserDefaults.standard.array(forKey: "alcoholStoreIds") {
            
            for index in 0..<value.count {
                
                if index == 0 {
                    stringID = String(describing: value[index])
                } else {
                    stringID = stringID + "," + String(describing: value[index])
                }
            }
        
        
        let parameters: Parameters = [
            "longitude": "\(AppStateManager.sharedInstance.latitude)",
            "latitude": "\(AppStateManager.sharedInstance.longitude)",
            "Page":"0",
            "Items":"2",
            "Store_Ids": stringID
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
              
                print("Request Successful")
                let responseResult = result["Result"] as? NSDictionary
                let storeArr = responseResult!["Stores"] as! NSArray
                
            /*    //GET FilterSize Array
                if  self.manager.filterSizeArray.count != 0{
                    self.manager.filterSizeArray.removeAll()
                }
                let proSizes = responseResult!["FilterProductSizes"] as! NSArray
                for items in proSizes {
                    let itemObj = items as! NSDictionary
                    let sizeObj = FilterProductSize(value: itemObj)
                    self.manager.filterSizeArray.append(sizeObj)
                }*/
                
                if self.alcoholArray.count != 0{
                    self.alcoholArray.removeAll()
                }
                
                for item in storeArr{
                    let itemObj = item as! NSDictionary
                    let itemMod = StoreItem(value: itemObj)
                    for category in itemMod.Categories {
                        let prod = category.Products
                        prod.forEach({ (product) in
                            product.Store_id = itemMod.Id
                        })
                    }
                    self.alcoholArray.append(itemMod)
                }
                 self.setUpAlcoholCategories()
                self.apiCall = true
                self.tableView.reloadData()
               
                
              /*  var ids = [String]()
                self.alcoholArray.forEach({ (store) in
                    ids.append(String(store.Id))
                })
                UserDefaults.standard.set(ids, forKey: "alcoholStoreIds")
                self.alcoholView.setdata(alcoholArray: self.alcoholArray)*/
                
            }
        }
        APIManager.sharedInstance.getAlcoholHomeScreen(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}







