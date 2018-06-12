//
//  WineFilterMainView.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol WineFilterMainViewDelegate {
    func sendSelectedFilterValue( countryArray1: String ,price1: String, sizeArray1: String, name: String ,storeValue: String)
}

class WineFilterMainView: UIView {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var menuStrip: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaibles
    
    var view: UIView!
    var viewCheck : Bool!
    var isSeeMore : Bool!
    var filterCheck : Bool!
    var filterRowHeight : CGFloat!
    var currentTitle : String!
    var mainStrip = WFSeeAllView()
    var seeMoreView = WineFilterViewMore()
    var countryArray = ""
    var priceValue = ""
    var sizeArray = ""
    var delegate: WineFilterMainViewDelegate!
    var sendSortValue = ""
    var collectionViewObj = WineFilterTableCell()
    var manger = AppStateManager.sharedInstance
    var filterSizeArray = [String]()
    
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        self.registerNot()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        self.registerNot()
    }
    
    func registerNot(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.isSeeMoreSelected(notification:)), name: NSNotification.Name(rawValue: "seeMoreDown"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.filterTapped(notification:)), name: NSNotification.Name(rawValue: "seeAllFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeText(_:)), name: NSNotification.Name(rawValue: "currentTitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataOfTableView), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
        isSeeMore = false
        filterCheck = false
        filterRowHeight = 121
        currentTitle = AppStateManager.sharedInstance.sortByState
        sendSortValue = "  Best selling"
        let id = AppStateManager.sharedInstance.filterTypeID
        setUpSizeArray(id)
        self.tableView.tableFooterView = UIView()
    }
    
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        mainStrip.divView.isHidden = true
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        let tableViewCellNibName = UINib(nibName: "WineFilterTableCell", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell")
        return nibView
    }
    
    
    //MARK: - Helping Method
    
    func isSeeMoreSelected(notification: Notification){
        isSeeMore = !isSeeMore
        if (isSeeMore){
            seeMoreView.viewMore.setTitle("View less", for: .normal)
            seeMoreView.viewMoreArrow.setImage(UIImage(named: "arrow_up_green"), for: .normal)
        }
        else{
            seeMoreView.viewMore.setTitle("View more", for: .normal)
            seeMoreView.viewMoreArrow.setImage(UIImage(named: "arrow_down_green"), for: .normal)
        }
        tableView.reloadData()
    }
    
    func filterTapped(notification: Notification){
        if (self.filterCheck){
            filterRowHeight = 121
            self.filterCheck = !self.filterCheck
            self.mainStrip.divView.isHidden = true
        }
        else{
            filterRowHeight = 0
            self.filterCheck = !self.filterCheck
            self.mainStrip.divView.isHidden = false
        }
        self.tableView.reloadData()
    }
    
    func reloadDataOfTableView(){
        self.tableView.reloadData()
    }
    
    func setUpSizeArray(_ id: Int){
        
        for item in manger.filterSizeArray{
            
            if item.TypeID == id {
                let value = item.NetWeight
                if value != nil{
                filterSizeArray.append(value!)
                }
            }
            
            if id == -1 {
                let value = item.NetWeight
                if value != nil{
                filterSizeArray.append(value!)
                }
            }
            
          /*  let trimUnit = item.Unit?.replacingOccurrences(of: " ", with: "")
            let value = item.Size! + " " + trimUnit!
            filterSizeArray.append(value)*/
        }
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension WineFilterMainView : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if filterSizeArray.count > 0 {
            return 5
        }
        return 4 //6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WineFilterTableCell
        /*   if indexPath.section == 2
         {
         cell.title.text = "Type"
         }*/
        cell.delegate = self
        
        if indexPath.section == 2
        {
            cell.tag = 2
            
            cell.title.text = "Country"
            let countryArray = ["USA", "CANADA","CUBA","BRAZIL","PERU" ,"COLOMBIA"]
            cell.setUpData(collectionData: countryArray, isMultiple: true, title: "Country")
        }
        if indexPath.section == 3
        {
            cell.title.text = "Price"
            let priceArray = ["Under $10", "$10 to $20","$20 to $30","$30 to $50","$50 and above"]
            cell.setUpData(collectionData: priceArray, isMultiple: false , title: "Price")
        }
        if indexPath.section == 4
        {
            cell.title.text = "Size"
            let sizeArray = filterSizeArray  //["3 L", "1.5 L","1 L","720 mL","750 mL" ,"500 mL"]
            cell.setUpData(collectionData: sizeArray, isMultiple: true , title: "Size")
        }
        cell.separatorInset.left = 0
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 || indexPath.section == 0{
            return 0
        }
        if indexPath.section == 3 && isSeeMore == true{
            return 330
        }
        if indexPath.section == 4 {

            if filterSizeArray.count > 6{
                let countArr = filterSizeArray.count * 30
                return CGFloat(countArr)
            }
        }
        return 200
    }
    
    func changeText(_ notification: NSNotification) {
        
        if let title = notification.userInfo?["text"] as? String {
            currentTitle = title
            mainStrip.setTitle(text: currentTitle)
            sendSortValue = currentTitle
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            return mainStrip
        }
        
        /*  if section == 3{
         return seeMoreView
         }*/
        if section == 1{
            return DDWineFilter()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        /*    if section == 3
         {
         return 10
         }*/
        if section == 0{
            return 50
        }
        if section == 1{
            return filterRowHeight
        }
        return 0
    }
}


//MARK : - Send Currrent Selection

extension WineFilterMainView {
    func sendCurrentSection(section :Int){
        let param:[String: Int] = ["section": section]
        NotificationCenter.default.post(name: Notification.Name("tableViewSection"), object: nil, userInfo: param)
    }
}


//MARK : - WineFilterMainView

extension WineFilterMainView: WineFilterTableCellDelegate{
    
    func sendSelectedValue(value: String, name: String, selectedPrice: String) {
        if name == "Country" {
            countryArray = value
        }
        if name == "Price" {
            priceValue  = selectedPrice
        }
        if name == "Size" {
            sizeArray = value
        }
        delegate.sendSelectedFilterValue(countryArray1: countryArray, price1: priceValue, sizeArray1: sizeArray, name: name, storeValue: sendSortValue )
    }
}

