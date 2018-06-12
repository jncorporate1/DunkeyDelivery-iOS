//
//  DDWomeCategoryMainView.swift
//  Template
//
//  Created by Jamil Khan on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

protocol DDWineCategoryMainViewProtocol {
    func changeView(storeID: Int, CategoryID: Int, CategoryParentID: Int)
    func productTapped(item: ProductItem)
}


class DDWineCategoryMainView: UIView{
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Varaibles
    
    var wineDetail = WineDetailViewController()
    var view: UIView!
    var selectedIndex : Int!
    var delegate : DDWineCategoryMainViewProtocol?
    var storeData = [Category]()
    
    //MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        self.setupDelegate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        self.setupDelegate()
    }
    
    
    //MARK: - Helping Method
    
    func setupDelegate(){
        selectedIndex = 0
    }
    
    func xibSetup(){
        backgroundColor = .clear
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask
            = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        let tableViewCellNibName = UINib(nibName: "DDWineTableViewCell1", bundle:nil)
        self.tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell1")
        let tableViewCellNibName2 = UINib(nibName: "DDWineTableViewCell2", bundle:nil)
        self.tableView.register(tableViewCellNibName2, forCellReuseIdentifier: "cell2")
        let tableViewCellNibName3 = UINib(nibName: "DDWineTableViewCell3", bundle:nil)
        self.tableView.register(tableViewCellNibName3, forCellReuseIdentifier: "cell3")
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setData(storeData: [Category]) {
        self.storeData = storeData
        self.tableView.reloadData()
    }
}


//MARK: -  UITableViewDelegate, UITableViewDataSource

extension DDWineCategoryMainView : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDWineTableViewCell3
        let category = storeData[indexPath.row]
        cell.colDelegate = self
        cell.categoryView.sellAllCategories.tag = indexPath.row
        cell.categoryView.sellAllCategories.addTarget(self, action: #selector(DDWineCategoryMainView.seeAllDown(sender:)), for: UIControlEvents.touchUpInside)
        var storeproducts = [ProductItem]()
        category.Products.forEach { (product) in
            storeproducts.append(product)
        }
        cell.setUpData(product: storeproducts, title: category.Name!, isMain: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func setText(_ cell : DDWineTableViewCell2 , _ indexPath: IndexPath){
        
        if(indexPath.section == 0){
            switch selectedIndex {
            case 0:
                cell.cellView.categoryTitle.text = "Red"
            case 1:
                cell.cellView.categoryTitle.text = "Whiskey"
            case 2:
                cell.cellView.categoryTitle.text = "Featured Beer"
            default:
                cell.cellView.categoryTitle.text = "Red"
            }
        }
        if(indexPath.section == 2) {
            switch selectedIndex {
            case 0:
                cell.cellView.categoryTitle.text = "Sparkling"
            case 1:
                cell.cellView.categoryTitle.text = "Vodka"
            case 2:
                cell.cellView.categoryTitle.text = "Ale"
            default:
                cell.cellView.categoryTitle.text = "Red"
            }
        }
        
        if(indexPath.section == 4) {
            switch selectedIndex {
            case 0:
                cell.cellView.categoryTitle.text = "Kosher"
            case 1:
                cell.cellView.categoryTitle.text = "Liqueurs"
            case 2:
                cell.cellView.categoryTitle.text = "Ale"
            default:
                cell.cellView.categoryTitle.text = "Red"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4){
        }
    }
}


//MARK: - WineDetailViewControllerDelegate

extension DDWineCategoryMainView: WineDetailViewControllerDelegate{
    func menuStripSelected(index :Int){
        self.selectedIndex = index
    }
}


//MARK: - Send SelectedData

extension DDWineCategoryMainView {
    func seeAllDown(sender: UIButton) {
        let selectedData = self.storeData[sender.tag]
        if delegate != nil {
            delegate?.changeView(storeID: selectedData.Store_Id, CategoryID: selectedData.ParentCategoryId, CategoryParentID: selectedData.Id)
        }
    }
}

//MARK: - Send DDWineCategoryCollectionDelegate

extension DDWineCategoryMainView: DDWineCategoryCollectionDelegate{
    func alcoholCellTapped(item: ProductItem) {
        delegate?.productTapped(item: item)
    }
}



//MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDWineCategoryMainView : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        
        let text = "No Product(s) are currently available."//"Cart is empty."
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: Constants.CART_COLOR
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""//"Looks like you have no items in your cart."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: Constants.CART_COLOR,
            NSParagraphStyleAttributeName: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
 /*
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Refresh"//"Add items in cart"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: Constants.APP_COLOR
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        self.loadData()
    }*/
}
