//
//  WineFilterViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit


class WineFilterViewController: UIViewController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var mainStrip: DDWineFilter!
    @IBOutlet var bestSellingBtn: UIButton!
    @IBOutlet weak var mainView: WineFilterMainView!
    @IBOutlet weak var mainStripHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var navigationTitle : String!
    var countryArray = [String] ()
    var price = ""
    var sizeArray = [String] ()
    var sendCountry = ""
    var sendsize = ""
    var sendSort: Int!
    var sortVal = ""
    var leftSearchBarButtonItem : UIBarButtonItem?
    var isRefreshEnable: Bool = false
    var manager = AppStateManager.sharedInstance
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if navigationTitle == nil{
            self.title = "Wine Filter"
        }
        else{
            self.title = self.navigationTitle
        }
        self.setNavigationRightItems()
        self.addBackButtonToNavigationBar()
        self.bindEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideTabBarAnimated(hide: true)
        mainView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Helping Method
    
    func bindEvent(){
        //        bestSellingBtn.addTarget(WineFilterMainView(), action: #selector(WineFilterMainView.filterTapped), for: .touchUpInside)
    }
    
    func hideTabBarAnimated(hide:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
                self.tabBarController?.tabBar.isHidden = true
            } else {
                self.tabBarController?.tabBar.transform = CGAffineTransform.identity
                self.tabBarController?.tabBar.isHidden = false
            }
        })
    }
    
    func setNavigationRightItems(){
        let refreshBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh_button"), style: .plain, target: self, action: #selector(refresh))
        let doneBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "tick_icon"), style: .plain, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItems = [doneBtn, refreshBtn]
    }
    
    func refresh(){
        manager.sortBy = ""
        manager.Price = ""
        manager.Country = ""
        manager.Size = ""
        manager.countryState = [String] ()
        manager.sizeState = [String] ()
        manager.priceState = ""
        manager.sortByState = "  Best selling"
        isRefreshEnable = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionView"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
    func done(){
        let manager = AppStateManager.sharedInstance
        sendCountryfliter()
        sendSizeFilter()
        getPrices()
        getSortByValue()
        print(sendCountry)
        print(sendsize)
        print(price)
        print(sortVal)
        manager.Country = sendCountry
        manager.Size = sendsize
        manager.Price = price
        manager.sortBy = sortVal
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendCountryfliter() {
        if manager.countryState.count > 0 {
            for cntryitem in manager.countryState{
                sendCountry = sendCountry + cntryitem + ","
            }
            sendCountry = String(sendCountry.dropLast())
        }else{
            for cntryitem in countryArray{
                sendCountry = sendCountry + cntryitem + ","
            }
            sendCountry = String(sendCountry.dropLast())
        }
    }
    
    func sendSizeFilter(){
        if manager.sizeState.count > 0{
            for sizeitem in manager.sizeState{
                //let replaced = String(sizeitem.characters.filter {$0 != " "})
                sendsize = sendsize + sizeitem + "#"
            }
            sendsize = String(sendsize.dropLast())
        }else{
            for sizeitem in sizeArray{
               // let replaced = String(sizeitem.characters.filter {$0 != " "})
                sendsize = sendsize + sizeitem + "#"
            }
            sendsize = String(sendsize.dropLast())
        }
    }
    
    func getPrices(){
        if price == "Under $10"{
            price = "0,10"
        }
        if price == "$10 to $20"{
            price = "10,20"
        }
        if price == "$20 to $30"{
            price = "20,30"
        }
        if price == "$30 to $50"{
            price = "30,50"
        }
        if price == "$50 and above"{
            price = "50"
        }
    }
    
    func getSortByValue(){
        let value =  AppStateManager.sharedInstance.sortByState
        if value == "  Best selling"{
            sortVal = "0"
        }
        if value == "  Name:A to Z"{
            sortVal = "2"
        }
        if value == "  Name:Z to A"{
            sortVal = "4"
        }
        if value == "  Price:Low to high"{
            sortVal = "1"
        }
        if value == "  Price:High to low"{
            sortVal = "3"
        }
        if value.range(of:":Low") != nil {
            sortVal = "1"
        }
    }
    
    func addBackButtonToNavigationBar(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
    }
    
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - See AllFilter

extension WineFilterViewController{
    @IBAction func seeAllBtnDown(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("seeAllFilter"), object: nil)
    }
}

//MARK: - WineFilterMainViewDelegate

extension WineFilterViewController: WineFilterMainViewDelegate{
    
    func sendSelectedFilterValue(countryArray1: String, price1: String, sizeArray1: String, name: String, storeValue: String) {
        if name == "Country" {
            
            if let index = countryArray.index(of: countryArray1) {
                countryArray.remove(at: index)
            } else {
                countryArray.append(countryArray1)
            }
        }
        if name == "Price" {
            price = price1
        }
        
        if name == "Size" {
            if let index = sizeArray.index(of: sizeArray1) {
                sizeArray.remove(at: index)
            } else {
                sizeArray.append(sizeArray1)
            }
        }
        sortVal = storeValue
    }
}
