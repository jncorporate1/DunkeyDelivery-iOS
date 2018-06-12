//
//  DDMainView.swift
//  Template
//
//  Created by Ingic on 7/24/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Device
import Kingfisher
import RealmSwift
import Alamofire
import SDWebImage

protocol DDMainViewDelegate {
    func rowSelect(data: StoreItem)
    func openFilter()
    //    func setTableHeight()
}
@IBDesignable
class DDMainView: UIView {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var popularLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightIconButton: UIButton!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var array = ["food","alcohol","grocery","laundry","pharmacy","retail","ride"]
    var viewValue = ""
    var delegate: DDMainViewDelegate!
    var  foodArray = [StoreItem]()
    var groceryArray = [StoreItem]()
    var laundryArray = [StoreItem]()
    var pharmacyArray = [StoreItem]()
    var retailArray = [StoreItem]()
    var foodTableArray = [StoreItem]()
    var groceryTableArray = [StoreItem]()
    var laundryTableArray = [StoreItem]()
    var pharmacyTableArray = [StoreItem]()
    var retailTableArray = [StoreItem]()
    var viewString : String!
    var view: UIView!
    var viewCheck : Bool!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        let colletionViewSecondCellNibName = UINib(nibName: "DDHomeCollectionViewSecondCell", bundle:nil)
        self.collectionView.register(colletionViewSecondCellNibName, forCellWithReuseIdentifier: "secondCell")
        let colletionViewCellNibName = UINib(nibName: "DDHomeCollectionViewCell", bundle:nil)
        self.collectionView.register(colletionViewCellNibName, forCellWithReuseIdentifier: "Cell")
        let tableViewCellNibName = UINib(nibName: "DDHomeTableViewCell", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "homeTableCell")
        self.viewCheck = false
        self.tableView.tableFooterView = UIView()
        return nibView
    }
    
    func setUpMainScroll(){
        scrollView.delegate = self
        tableView.delegate = self
        scrollView.bounces = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        tableView.sizeToFit()
        self.view.layoutIfNeeded()
    }
    
    func setMainScrollContent(){
        var contentRect : CGRect = CGRect.zero
        for views in self.scrollView.subviews{
            
            if views == tableView{
                
            }
            else{
                contentRect = contentRect.union(views.frame)
            }
        }
        contentRect.size.height = contentRect.size.height + tableView.contentSize.height
        self.scrollView.layoutIfNeeded()
    }
    
    func showRightView(){
        self.rightLabel.isHidden = false
        self.rightIconButton.isHidden = false
    }
    
    func hideRightView(){
        self.rightLabel.isHidden = true
        self.rightIconButton.isHidden = true
    }
    
    @IBAction func rightIconButtonTapped(_ sender: Any) {
        delegate.openFilter()
    }
    
    func didSelectMenu(sender: UIButton){
        let index = sender.tag
        var storeData = StoreItem()
        switch viewValue {
        case "food":
            storeData = foodArray[index]
        case "grocery":
            storeData = groceryArray[index]
        case "laundry":
            storeData = laundryArray[index]
        case "pharmacy":
            storeData = pharmacyArray[index]
        case "retail":
            storeData = retailArray[index]
            
        default:
            break
        }
        
        self.rowSelect(storeData: storeData)
    }
    
    func rowSelect(storeData: StoreItem){
        delegate.rowSelect(data: storeData)
    }
    
    func setTableHeight(){
        if foodTableArray.count != 0{
            print(tableView.frame)
        }
    }
    
    func setUpLaundry(){
        
    }
    func setFoodArray(array: [StoreItem], tableArray: [StoreItem]){
        self.foodArray = array
        self.foodTableArray = tableArray
        self.collectionView.reloadData()
        setTableHeight()
    }
    
    func setGroceryArray(array : [StoreItem], tableArray: [StoreItem]){
        self.groceryArray = array
        self.groceryTableArray = tableArray
        self.collectionView.reloadData()
        setTableHeight()
    }
    
    func setLaundryArray(array: [StoreItem], tableArray: [StoreItem]){
        self.laundryArray = array
        self.laundryTableArray = tableArray
        self.collectionView.reloadData()
        setTableHeight()
    }
    
    func setPharmacyArray(array: [StoreItem], tableArray: [StoreItem]){
        self.pharmacyArray = array
        self.pharmacyTableArray = tableArray
        self.collectionView.reloadData()
        setTableHeight()
    }
    
    func setRetailArray(array: [StoreItem], tableArray: [StoreItem]){
        self.retailArray = array
        self.retailTableArray = tableArray
        self.collectionView.reloadData()
        setTableHeight()
    }
}

extension DDMainView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewValue {
        case "food":
            print(self.foodTableArray.count)
            return foodTableArray.count
        case "grocery":
            print("grocery")
            return groceryTableArray.count
        case "laundry":
            print("laundry")
            return laundryTableArray.count
        case "pharmacy":
            print("pharmacy")
            return pharmacyTableArray.count
        case "retail":
            print("retail")
            return retailTableArray.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewValue {
        case "food":
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            
            let item = foodTableArray[indexPath.row]
            cell.companyName.text = item.BusinessName
            cell.starView.starSmall(items: 1)
            if item.ImageUrl != nil {
                let url = URL(string: item.ImageUrl)
                
                cell.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            cell.selectionStyle = .none
            
            return cell
        case "grocery":
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            let item = groceryTableArray[indexPath.row]
            cell.companyName.text = item.BusinessName
            if item.ImageUrl != nil {
                let url = URL(string: item.ImageUrl)
                cell.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            cell.starView.starSmall(items: 1)
            cell.selectionStyle = .none
            
            return cell
        case "laundry":
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            let item = laundryTableArray[indexPath.row]
            cell.companyName.text = item.BusinessName
            if item.ImageUrl != nil {
                let url = URL(string: item.ImageUrl)
                cell.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            cell.starView.starSmall(items: 1)
            cell.selectionStyle = .none
            return cell
        case "pharmacy":
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            let item = pharmacyTableArray[indexPath.row]
            cell.companyName.text = item.BusinessName
            if item.ImageUrl != nil {
                let url = URL(string: item.ImageUrl)
                cell.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            cell.starView.starSmall(items: 1)
            cell.selectionStyle = .none
            return cell
        case "retail":
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            let item = retailTableArray[indexPath.row]
            cell.companyName.text = item.BusinessName
            if item.ImageUrl != nil {
                let url = URL(string: item.ImageUrl)
                cell.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            cell.starView.starSmall(items: 1)
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
            cell.selectionStyle = .none
            return cell
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var storeData = StoreItem()
        switch viewValue {
        case "food":
            storeData = foodTableArray[indexPath.row]
        case "grocery":
            storeData = groceryTableArray[indexPath.row]
        case "laundry":
            storeData = laundryTableArray[indexPath.row]
        case "pharmacy":
            storeData = pharmacyTableArray[indexPath.row]
        case "retail":
            storeData = retailTableArray[indexPath.row]
            
        default:
            break
        }
        
        self.rowSelect(storeData: storeData)
        
    }
}

extension DDMainView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewValue {
        case "food":
            print("food")
            return foodArray.count
        case "grocery":
            print("grocery")
            return groceryArray.count
        case "laundry":
            print("laundry")
            return laundryArray.count
        case "pharmacy":
            print("pharmacy")
            return pharmacyArray.count
        case "retail":
            print("retail")
            return retailArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch viewValue {
        case "food":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            
            let foodItem = foodArray[indexPath.row]
            if foodItem.ImageUrl != nil {
                let url = URL(string: foodItem.ImageUrl)
                cell.summaryView.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            
            cell.summaryView.companyName.text = foodItem.BusinessName
            cell.summaryView.starView.starSmall(items: 2)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
            
        case "grocery":
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let groceryItem = groceryArray[indexPath.row]
            if groceryItem.ImageUrl != nil{
                let url = URL(string: groceryItem.ImageUrl)
                cell.summaryView.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
            }
            
            cell.summaryView.companyName.text = groceryItem.BusinessName
            cell.summaryView.starView.starSmall(items: 3)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "laundry":
            print("laundry")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let laundryItem = laundryArray[indexPath.row]
            if laundryItem.ImageUrl != nil {
                let url = URL(string: laundryItem.ImageUrl)
                cell.summaryView.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
                
            }
            cell.summaryView.companyName.text = laundryItem.BusinessName
            cell.summaryView.starView.starSmall(items: 4)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "pharmacy":
            print("pharmacy")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let pharmacyItem = pharmacyArray[indexPath.row]
            if pharmacyItem.ImageUrl != nil {
                let url = URL(string: pharmacyItem.ImageUrl)
                cell.summaryView.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
                
            }
            cell.summaryView.companyName.text = pharmacyItem.BusinessName
            cell.summaryView.starView.starSmall(items: 4)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        case "retail":
            print("retail")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! DDHomeCollectionViewSecondCell
            let retailItem = retailArray[indexPath.row]
            if retailItem.ImageUrl != nil {
                let url = URL(string: retailItem.ImageUrl)
                cell.summaryView.companyLogo.sd_setImage(with: url, placeholderImage: UIImage(named:"burger1"))
                
            }
            cell.summaryView.companyName.text = retailItem.BusinessName
            cell.summaryView.starView.starSmall(items: 4)
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DDHomeCollectionViewCell
            cell.summaryView.viewMenuButton.tag  = indexPath.row
            cell.summaryView.viewMenuButton.addTarget(self, action: #selector(didSelectMenu(sender:)), for: .touchUpInside)
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
