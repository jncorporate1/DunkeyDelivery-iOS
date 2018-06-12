//
//  DDWineMainView.swift
//  Template
//
//  Created by Jamil Khan on 7/27/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import ObjectiveC

protocol DDWineMainViewDelegate  {
    func storeDetailButtonDown()
    func categoryDetailButtonDown(storeID: Int, categoryID: Int, categoryName: String)
    func itemDetailButtonDown(data: ProductItem)
    func alcoholAPIDelegate(_ value: Bool)
}


class DDWineMainView: UIView {
    
    
    @IBOutlet weak var cstTabelViewTop: NSLayoutConstraint!
    @IBOutlet  var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var delegate: DDWineMainViewDelegate!
    var store1Name = ""
    var store1Price = ""
    var store1Time = ""
    var store2Name = ""
    var store2Price = ""
    var store2Time = ""
    var alcoholDataArray = [StoreItem]()
    var view: UIView!
    var viewCheck : Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.registerNotification()
        xibSetup()
    }
    
    
    func setdata(alcoholArray: [StoreItem]) {
        alcoholDataArray = alcoholArray
        tableView.reloadData()
        view.backgroundColor = UIColor.clear
//        tableView.emptdata
        
      /*if alcoholArray.count == 0 {
            cstTabelViewTop.constant = 130
        } else {
            cstTabelViewTop.constant = 0
        }
        self.view.layoutIfNeeded()*/
    }
    
    func registerNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("collectionViewItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemSelected(notification:)), name: Notification.Name("collectionViewItem"), object: nil)
    }
    
    func itemSelected(notification: Notification){
        //let product = notification.userInfo!["data"]
        //self.itemDetailButtonDown(data: product as! ProductItem)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        
    }
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        //view.frame.size.height = 700
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
       
        viewEssentials()
        return nibView
    }
    func viewEssentials(){
        let tableViewCellNibName = UINib(nibName: "DDWineTableViewCell1", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell1")
        let tableViewCellNibName3 = UINib(nibName: "DDWineTableViewCell3", bundle:nil)
        self.tableView.register(tableViewCellNibName3, forCellReuseIdentifier: "cell3")
        refreshControl.tintColor = UIColor(red:0.09, green:0.58, blue:0.81, alpha:1.0)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
//        tableView
        self.viewCheck = false
    }
    @objc private func refreshData(_ sender: Any) {
        refreshControl.endRefreshing()
        delegate.alcoholAPIDelegate(false)
    }
}


extension DDWineMainView : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.alcoholDataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alcoholDataArray[section].Categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DDWineTableViewCell1
            cell.cellView.storeName.text = alcoholDataArray[indexPath.section].BusinessName
            var charges = 0.0
            if alcoholDataArray[indexPath.section].MinDeliveryCharges.value != nil{
            charges = alcoholDataArray[indexPath.section].MinDeliveryCharges.value!}
            if charges != 0.0 {
                cell.cellView.deliveryTitleLabel.text = "Delivery Fee"
                cell.cellView.deliveryChardesLabel.alpha = 1.0
                cell.cellView.deliveryChardesLabel.text = "$\(charges)"
            }
            if alcoholDataArray[indexPath.section].MinOrderPrice.value != nil{
              cell.cellView.minimumPrice.text = "$\(alcoholDataArray[indexPath.section].MinOrderPrice.value!)"}
            
            if alcoholDataArray[indexPath.section].MinDeliveryTime.value != nil{
            var devTime = alcoholDataArray[indexPath.section].MinDeliveryTime.value!
            devTime = Int(devTime)
            cell.cellView.deliveryTime.text = "\(devTime)" + " min"}
            self.bindStoreDetailEvents(cell)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDWineTableViewCell3
            
            let category = alcoholDataArray[indexPath.section].Categories[indexPath.row - 1]
            
            cell.delegate = self
            cell.colDelegate = self
            cell.index = indexPath
            
            var products = [ProductItem]()
            category.Products.forEach({ (prod) in
                products.append(prod)
            })
            
            cell.viewEsssentials(storeID: alcoholDataArray[indexPath.section].Id, categoryID: category.Id, categoryName: category.Name!)
            cell.setUpData(product: products, title: category.Name!, isMain: true)
            return cell
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 80
        }
        else {
            return 180
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    
    func bindCategoriesEvents(_ cell: DDWineTableViewCell2)
    {
        print(cell.tag)
        
        cell.cellView.sellAllCategories.addTarget(self, action: #selector(DDWineMainView.categoryDetail(cell:)),
                                                  for: UIControlEvents.touchUpInside)
        
    }
    func bindStoreDetailEvents(_ cell: DDWineTableViewCell1)
    {
        cell.cellView.detailBtn.addTarget(self, action: #selector(storeDetail), for: .touchUpInside)
    }
    
    func storeDetail()
    {
        delegate.storeDetailButtonDown()
        
    }
    
    func categoryDetail(cell: DDWineTableViewCell2) {
        print(cell.tag)
    }
    
    
    func itemDetailButtonDown(data: ProductItem){
        delegate.itemDetailButtonDown(data: data)
        
    }
    
}

extension DDWineMainView: DDWineCategoryDelegate{
    func seeAllTappped(storeID: Int, categoryID: Int, categoryName: String) {
        delegate.categoryDetailButtonDown(storeID: storeID, categoryID: categoryID, categoryName: categoryName)
    }
    
}


extension DDWineMainView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
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
        delegate.alcoholAPIDelegate(true)
    }
}

extension DDWineMainView: DDWineCategoryCollectionDelegate{
    func alcoholCellTapped(item: ProductItem) {
        delegate.itemDetailButtonDown(data: item)
    }
}
