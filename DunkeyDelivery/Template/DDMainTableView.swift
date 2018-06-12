//  DDMainTableView.swift
//  Template
//
//  Created by Ingic on 9/14/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol DDMainTableViewDelegate {
    func tableRowSelect(data: StoreItem)
    func openFilter()
    func refreshData(refreshControl: UIRefreshControl, check: Bool)
    
    //    func setTableHeight()
}
class DDMainTableView: UIView {
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var view: UIView!
    var collectionSubView = DDMainCollectionCell()
    var viewValue = ""
    var foodArray = [StoreItem]()
    var groceryArray = [StoreItem]()
    var laundryArray = [StoreItem]()
    var pharmacyArray = [StoreItem]()
    var retailArray = [StoreItem]()
    var foodCollectionArray = [StoreItem]()
    var groceryCollectionArray = [StoreItem]()
    var laundryCollectionArray = [StoreItem]()
    var pharmacyCollectionArray = [StoreItem]()
    var retailCollectionArray = [StoreItem]()
    let refreshControl = UIRefreshControl()
    var popularLabelArray = ["Restaurants","alcohol","Grocery","Laundry","Pharmacy","Retail","ride"]
    var delegate: DDMainTableViewDelegate!
    var emptyCheck = false
    
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.registerTableViewCells()
        return nibView
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    func registerTableViewCells(){
//        DDNoResultCell
        let tableViewCellOne = UINib(nibName: "DDMainOneTableViewCell", bundle:nil)
        let tableViewCellTwo = UINib(nibName: "DDMainCollectionCell", bundle:nil)
        let tableViewCellThree = UINib(nibName: "DDHomeTableViewCell", bundle:nil)
        let noResultCell = UINib(nibName: "DDNoResultCell", bundle:nil)
        
        self.tableView.register(tableViewCellOne, forCellReuseIdentifier: "CellOne")
        self.tableView.register(tableViewCellTwo, forCellReuseIdentifier: "CellTwo")
        self.tableView.register(tableViewCellThree, forCellReuseIdentifier: "homeTableCell")
        self.tableView.register(noResultCell, forCellReuseIdentifier: "noResultCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    func refreshData(){
        delegate.refreshData(refreshControl: self.refreshControl, check: false)
    }

    func didSelectMenu(index: Int){
        var storeData = StoreItem()
        switch viewValue {
        case "Restaurants":
            if foodArray.count > 0{
            storeData = foodArray[index]
            self.rowSelect(storeData: storeData)
            }
        case "Grocery":
            if groceryArray.count > 0{
            storeData = groceryArray[index]
            self.rowSelect(storeData: storeData)
            }
        case "Laundry":
            if laundryArray.count > 0{
            storeData = laundryArray[index]
            self.rowSelect(storeData: storeData)
            }
        case "Pharmacy":
            if pharmacyArray.count > 0{
            storeData = pharmacyArray[index]
            self.rowSelect(storeData: storeData)
            }
        case "Retail":
            if retailArray.count > 0{
            storeData = retailArray[index]
            self.rowSelect(storeData: storeData)
            }
        default:
            break
        }
        
        
    }
    func rowSelect(storeData: StoreItem){
        delegate.tableRowSelect(data: storeData)
    }
    func setFoodArray(array: [StoreItem], tableArray: [StoreItem], check: Bool){
        self.foodArray = tableArray
        self.emptyCheck = check
        self.foodCollectionArray = array
        self.tableView.reloadData()
    }
    func setGroceryArray(array : [StoreItem], tableArray: [StoreItem], check: Bool){
        self.groceryArray = tableArray
        self.emptyCheck = check
        self.groceryCollectionArray = array
        self.tableView.reloadData()
    }
    func setLaundryArray(array: [StoreItem], tableArray: [StoreItem], check: Bool){
        self.laundryArray = tableArray
        self.emptyCheck = check
        self.laundryCollectionArray = array
        self.tableView.reloadData()
    }
    func setPharmacyArray(array: [StoreItem], tableArray: [StoreItem], check: Bool){
        self.pharmacyArray = tableArray
        self.emptyCheck = check
        self.pharmacyCollectionArray = array
        self.tableView.reloadData()
    }
    func setRetailArray(array: [StoreItem], tableArray: [StoreItem], check: Bool){
        self.retailArray = tableArray
        self.emptyCheck = check
        self.retailCollectionArray = array
        self.tableView.reloadData()
    }
    func distanceButtonTapped(){
        delegate.openFilter()
    }
    func nearByText() -> String{
        switch viewValue {
        case "Restaurants":
            return "\(foodArray.count)"
        case "Grocery":
            return "\(groceryArray.count)"
        case "Laundry":
            return "\(laundryArray.count)"
        case "Pharmacy":
            return "\(pharmacyArray.count)"
        case "Retail":
            return "\(retailArray.count)"
            
        default:
            return "0"
        }
    }
    
}
extension DDMainTableView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if (emptyCheck){
            return 0
        }
        return 4
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return 1
        }
        else if section == 2{
            return 1
        }
        else {
            switch viewValue {
            case "Restaurants":
                if foodArray.count == 0{
                    return 1
                }
                else{
                    return foodArray.count
                }
                
            case "Grocery":
                if groceryArray.count == 0{
                    return 1
                }
                else{
                    return groceryArray.count
                }
            case "Laundry":
                if laundryArray.count == 0{
                    return 1
                }
                else{
                    return laundryArray.count
                }
                
            case "Pharmacy":
                if pharmacyArray.count == 0{
                    return 1
                }
                else{
                    return pharmacyArray.count
                }
            case "Retail":
                if retailArray.count == 0{
                    return 1
                }
                else{
                    return retailArray.count
                }
            default:
                return 0
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOne", for: indexPath) as! DDMainOneTableViewCell
            cell.setUpperView()
            cell.nearLabel.text = "Popular " + viewValue
            cell.distanceButton.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
            cell.separatorInset.left = 1000
            cell.selectionStyle = .none
            return cell
            
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellTwo", for: indexPath) as! DDMainCollectionCell
            cell.delegate = self
            cell.viewValue = self.viewValue
            cell.setFoodArray(array: foodCollectionArray)
            cell.setGroceryArray(array: groceryCollectionArray)
            cell.setPharmacyArray(array: pharmacyCollectionArray)
            cell.setLaundryArray(array: laundryCollectionArray)
            cell.setRetailArray(array: retailCollectionArray)
            cell.separatorInset.left = 1000
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellOne", for: indexPath) as! DDMainOneTableViewCell
            cell.nearLabel.text = "Near You (\(nearByText()))"
            cell.setDownView()
            cell.distanceButton.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.separatorInset.left = 1000
            return cell
        }
        else{
            switch viewValue {
            case "Restaurants":
                if foodArray.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                    
                    let item = foodArray[indexPath.row]
                    cell.companyName.text = item.BusinessName
                    cell.starView.starSmall(items: Int(item.AverageRating))
                    if item.MinOrderPrice.value != nil{
                          cell.minOrder.text = "$\(item.MinOrderPrice.value!)"}
                    if item.MinDeliveryCharges.value != nil{
                        cell.deliveryFee.text = "$\(item.MinDeliveryCharges.value!)"}
                    if item.MinDeliveryTime.value != nil{
                        cell.deliveryTime.text = " \(item.MinDeliveryTime.value!) min"}
                    if item.Distance != nil{
                        let value = Double (item.Distance)
                        let distanceValue = Double(round(100*value)/100)
                        cell.locationDisplacement.text = "\(distanceValue) m"
                        
                    }
                    
                    let url = item.ImageUrl?.getURL()
                    cell.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                    var tags = [String]()
                        for tag in item.storeTags{
                            tags.append(tag.Tag)
                        }
                        cell.setTags(tagArr: tags)
                    
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 0
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! DDNoResultCell
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 1000
                    return cell
                }
                
            case "Grocery":
                if groceryArray.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                    let item = groceryArray[indexPath.row]
                    let url = item.ImageUrl?.getURL()
                    cell.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                    cell.companyName.text = item.BusinessName
                    cell.starView.starSmall(items: Int(item.AverageRating))
                    if item.MinOrderPrice.value != nil{
                        cell.minOrder.text = "$\(item.MinOrderPrice.value!)"}
                    if item.MinDeliveryCharges.value != nil{
                        cell.deliveryFee.text = "$\(item.MinDeliveryCharges.value!)"}
                    if item.MinDeliveryTime.value != nil{
                        cell.deliveryTime.text = " \(item.MinDeliveryTime.value!) min"}
                    if item.Distance != nil{
                        let value = Double (item.Distance)
                        let distanceValue = Double(round(100*value)/100)
                        cell.locationDisplacement.text = "\(distanceValue) m"
                        
                    }
                    
                    var tags = [String]()
                    for tag in item.storeTags{
                        tags.append(tag.Tag)
                    }
                    cell.setTags(tagArr: tags)
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 0
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! DDNoResultCell
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 1000
                    return cell
                }
            case "Laundry":
                if laundryArray.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                    let item = laundryArray[indexPath.row]
                    cell.companyName.text = item.BusinessName
                    let url = item.ImageUrl?.getURL()
                    cell.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                    cell.starView.starSmall(items: Int(item.AverageRating))
                    if item.MinOrderPrice.value != nil{
                        cell.minOrder.text = "$\(item.MinOrderPrice.value!)"}
                    if item.MinDeliveryCharges.value != nil{
                        cell.deliveryFee.text = "$\(item.MinDeliveryCharges.value!)"}
                    if item.MinDeliveryTime.value != nil{
                        cell.deliveryTime.text = " \(item.MinDeliveryTime.value!) min"}
                    if item.Distance != nil{
                        let value = Double (item.Distance)
                        let distanceValue = Double(round(100*value)/100)
                        cell.locationDisplacement.text = "\(distanceValue) m"
                    }
                    var tags = [String]()
                    for tag in item.storeTags{
                        tags.append(tag.Tag)
                    }
                    cell.setTags(tagArr: tags)
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 0
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! DDNoResultCell
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 1000
                    return cell
                }
                
            case "Pharmacy":
                if pharmacyArray.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                    let item = pharmacyArray[indexPath.row]
                    cell.companyName.text = item.BusinessName
                    let url = item.ImageUrl?.getURL()
                    cell.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                    cell.starView.starSmall(items: Int(item.AverageRating))
                    if item.MinOrderPrice.value != nil{
                        cell.minOrder.text = "$\(item.MinOrderPrice.value!)"}
                    if item.MinDeliveryCharges.value != nil{
                        cell.deliveryFee.text = "$\(item.MinDeliveryCharges.value!)"}
                    if item.MinDeliveryTime.value != nil{
                        cell.deliveryTime.text = " \(item.MinDeliveryTime.value!) min"}
                    if item.Distance != nil{
                        let value = Double (item.Distance)
                        let distanceValue = Double(round(100*value)/100)
                        cell.locationDisplacement.text = "\(distanceValue) m"
                    }
                    var tags = [String]()
                    for tag in item.storeTags{
                        tags.append(tag.Tag)
                    }
                    cell.setTags(tagArr: tags)
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 0
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! DDNoResultCell
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 1000
                    return cell
                }
            case "Retail":
                if retailArray.count != 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                    let item = retailArray[indexPath.row]
                    cell.companyName.text = item.BusinessName
                    let url = item.ImageUrl?.getURL()
                    cell.companyLogo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                    cell.starView.starSmall(items: Int(item.AverageRating))
                    if item.MinOrderPrice.value != nil{
                        cell.minOrder.text = "$\(item.MinOrderPrice.value!)"}
                    if item.MinDeliveryCharges.value != nil{
                        cell.deliveryFee.text = "$\(item.MinDeliveryCharges.value!)"}
                    if item.MinDeliveryTime.value != nil{
                        cell.deliveryTime.text = " \(item.MinDeliveryTime.value!) min"}
                    if item.Distance != nil{
                        let value = Double (item.Distance)
                        let distanceValue = Double(round(100*value)/100)
                        cell.locationDisplacement.text = "\(distanceValue) m"
                    }
                    var tags = [String]()
                    for tag in item.storeTags{
                        tags.append(tag.Tag)
                    }
                    cell.setTags(tagArr: tags)
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 0
                    return cell
                }
                else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath) as! DDNoResultCell
                    cell.selectionStyle = .none
                    cell.separatorInset.left = 1000
                    return cell
                }
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! DDHomeTableViewCell
                cell.selectionStyle = .none
                cell.separatorInset.left = 0
                return cell
                
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 44
        }
        else if indexPath.section == 1{
            return 211
        }
        else if indexPath.section == 2{
            return 44
        }
        else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3{
            didSelectMenu(index: indexPath.row)
        }
        
    }
}
extension DDMainTableView: DDMainCollectionViewDelegate{
    func collectionRowSelect(data: StoreItem){
        delegate.tableRowSelect(data: data)
    }
}
extension DDMainTableView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyIcon")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "Oops!"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Store(s) are currently available."//"Your streams will be visible here"
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: UIColor.lightGray,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Refresh Store"//"Refresh"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: Constants.APP_COLOR
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        delegate.refreshData(refreshControl: refreshControl, check: true)
        //        pri ntln("Tapped")
        //        self.requestAvailableStreams(offset: 0,limit: 30, option: self.option)
        //        self.requestAvailableStreams(offset: 0,limit: 10)
    }
}
