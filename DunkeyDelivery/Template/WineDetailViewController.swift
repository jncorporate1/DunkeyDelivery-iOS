//
//  WineDetailViewController.swift
//  Template
//
//  Created by Jamil Khan on 7/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
protocol WineDetailViewControllerDelegate : class {
    func menuStripSelected(index :Int)
}

enum CurrentView {
    case WINEV
    case LIQUORV
    case BEERV
}

class WineDetailViewController: BaseController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mWine: UIButton!
    @IBOutlet weak var mBeer: UIButton!
    @IBOutlet weak var mLiquor: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var menuStrip: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaibles
    
    var selectedIndex : Int!
    var lastSelectedIndex : Int!
    var searchField: UITextField = UITextField()
    var viewCheck: Bool = false
    weak var delegate : WineDetailViewControllerDelegate!
    var viewsArray = [Int: UIView]()
    var curView : CurrentView!
    var storeID = 0
    var categoryID = 0
    var categoryName = ""
    var CategoryParentId = 0
    var islast: Bool?
    var wineData = [Category]()
    var liqourData = [Category]()
    var beerData = [Category]()
    var finalProducts = [ProductItem]()
    var manager = AppStateManager.sharedInstance
    var isDirectlygoToSubCat:Bool = false
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastSelectedIndex = 0
        selectedIndex = 0
        //storeCategory()
        //        viewCheck = true
        //self.setUpScroll()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.scrollView.contentInset = UIEdgeInsets.zero
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
        
        // storeCategory()
        if manager.sortBy == "" && manager.Price == "" && manager.Country == "" && manager.Size == "" {
            storeCategory()
        }
        else{
            storeCategoryFilter()
        }
        addWineCategoryMainViewToSubView()
    }
    
    func addWineCategoryMainViewToSubView(){
        viewCheck = true
        hideTabBarAnimated(hide:true)
        let aView = DDWineCategoryMainView()
        aView.delegate = self
        scrollView.addSubview(aView)
        self.addBackButtonToNavigationBarCustom()
        setNavigationRightItems()
        setMiddleSearchBar()
        self.navigationController?.navigationBar.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (viewCheck){
            self.setUpScroll()
            viewCheck = false
        }
        let menu = menuStrip as! MenuStrip
        menu.toggleButtonColor(3)
        
        if (viewCheck){
            self.setUpScroll()
            viewCheck = false
        }
        
        if categoryName.lowercased() == "wine" {
            let aView = menuStrip as! MenuStrip
            mWineBtnDown(aView.mWine)
        }
        
        if categoryName.lowercased() == "liquor" {
            let aView = menuStrip as! MenuStrip
            mLiquorBtnDown(aView.mLiquor)
        }
        
        if categoryName.lowercased() == "beer" {
            let aView = menuStrip as! MenuStrip
            mBeerBtnDown(aView.mBeer)
        }
        
        /*/if(viewsArray != nil){
         for var i in (0..<viewsArray.count + 1){
         if let aView = viewsArray[i] as? DDWineAllCategories{
         aView.delegate = self
         scrollView.addSubview(aView)
         scrollView.bringSubview(toFront: aView)
         if(i == 1)
         {
         aView.title.text = "All Straight whiskey"
         }
         else if(i == 2)
         {
         aView.title.text = "All beer"
         }
         aView.frame = CGRect(x:CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
         }
         }
         }*/
    }
    
    
    //MARK: - Helping Method
    
    
    func loadMenuStripNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MenuStrip", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func loadMainViewNib() -> UIView{
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DDWineCategoryMainView", bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setMiddleSearchBar(){
        self.searchField.frame = CGRect(x: 0.0, y: 0.0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 30.0)
        self.searchField.minimumFontSize = 9.0
        let frontButton = UIButton(frame: self.searchField.frame)
        frontButton.addTarget(self, action: #selector(locationSearchTapped), for: .touchUpInside)
        self.searchField.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        self.searchField.textColor = UIColor.darkGray
        self.searchField.rightViewMode = .always
        self.searchField.layer.masksToBounds = true
        self.searchField.layer.cornerRadius = 5.0
        self.searchField.placeholder = "  Search your product here..."
        self.searchField.backgroundColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        let padding = 10
        let size = 18
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = #imageLiteral(resourceName: "search_grey_icon")
        outerView.addSubview(iconView)
        self.searchField.leftView = outerView
        self.searchField.leftViewMode = UITextFieldViewMode.always
        searchField.addSubview(frontButton)
        self.searchField.endEditing(true)
        self.searchField.delegate = self
        self.navigationItem.titleView = self.searchField
    }
    
    func locationSearchTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        controller.arrayCount = 0
        controller.viewCheck = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        let filterItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter_icon"), style: .plain, target: self, action: #selector(showFilters))
        self.navigationItem.rightBarButtonItems = [cartItem, filterItem]
    }
    
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showFilters(){
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WineFilterViewController") as! WineFilterViewController
        if(curView == .WINEV){
            controller.navigationTitle = "Wine Filter"
            AppStateManager.sharedInstance.filterTypeID = 0
            manager.category = wineData
        }
        if(curView == .LIQUORV){
            controller.navigationTitle = "Liquor Filter"
            AppStateManager.sharedInstance.filterTypeID = 0
            manager.category = liqourData
        }
        if(curView == .BEERV){
            controller.navigationTitle = "Beer Filter"
            AppStateManager.sharedInstance.filterTypeID = 1
            manager.category = beerData
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func registerTableView() {
        let tableViewCellNibName = UINib(nibName: "DDWineTableViewCell2", bundle:nil)
        tableView.register(tableViewCellNibName, forCellReuseIdentifier: "cell2")
        
        let tableViewCellNibName2 = UINib(nibName: "DDWineTableViewCell3", bundle:nil)
        tableView.register(tableViewCellNibName2, forCellReuseIdentifier: "cell3")
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
            
        else if(indexPath.section == 2){
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
            
        else if(indexPath.section == 4) {
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
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension WineDetailViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var cell : UITableViewCell!
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DDWineTableViewCell2
            self.setText(cell, indexPath)
            //self.bindCategoriesEvents(cell)
            return cell
        }
        else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDWineTableViewCell3
            // cell.colDelegate = self
            //cell.colDelegate = self as! DDWineCategoryCollectionDelegate
            //self.bindCategoriesEvents(cell)
            return cell
        }
        
        if(indexPath.section == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DDWineTableViewCell2
            //  self.bindCategoriesEvents(cell)
            self.setText(cell, indexPath)
            return cell
        }
        else if (indexPath.section == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDWineTableViewCell3
            // self.bindCategoriesEvents(cell)
            return cell
        }
        
        if(indexPath.section == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! DDWineTableViewCell2
            // self.bindCategoriesEvents(cell)
            self.setText(cell, indexPath)
            return cell
        }
            
        else if (indexPath.section == 5){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! DDWineTableViewCell3
            // self.bindCategoriesEvents(cell)
            return cell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 30
        }
        else if (indexPath.section == 1){
            return 140
        }
        else if (indexPath.section == 2){
            return  30
        }
        if (indexPath.section == 3){
            return 140
        }
        if (indexPath.section == 4){
            return 30
        }
        if (indexPath.section == 5){
            return 140
        }
        return 0
    }
}

//MARK: - SetUp ScrollView

extension WineDetailViewController
{
    func setUpScroll(){
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        for i in 0...2{
            let mainView = DDWineCategoryMainView()
            mainView.delegate = self
            mainView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            if i == 0 {
                mainView.setData(storeData: wineData)
            } else if i == 1 {
                mainView.setData(storeData: liqourData)
            } else if i == 2 {
                mainView.setData(storeData: beerData)
            }
            scrollView.addSubview(mainView)
        }
        scrollView.contentSize = CGSize(width: 3 * UIScreen.main.bounds.size.width, height: scrollView.contentSize.height)
    }
    
    func scrollMoved(index: Int){
        self.selectedIndex = index
        if self.selectedIndex != self.lastSelectedIndex{
            let scrollPoint = CGPoint(x: CGFloat(index) * UIScreen.main.bounds.size.width, y: 0)
            self.scrollView.setContentOffset(scrollPoint, animated: true)
            self.lastSelectedIndex = self.selectedIndex
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let mainOffsetX : CGFloat = UIScreen.main.bounds.size.width
        switch scrollView.contentOffset.x {
        case mainOffsetX * 1:
            scrollMoved(index:1)
        case mainOffsetX * 2:
            scrollMoved(index:2)
        case mainOffsetX * 3:
            scrollMoved(index:3)
        case mainOffsetX * 4:
            scrollMoved(index:4)
        case mainOffsetX * 5:
            scrollMoved(index:5)
        case mainOffsetX * 6:
            scrollMoved(index:6)
        default:
            break;
        }
    }
}


//MARK: - Button Selection

extension WineDetailViewController {
    
    @IBAction func mWineBtnDown(_ sender: Any) {
        let btn = sender as! UIButton
        self.selection(btn)
        selectedIndex = 0
        self.scrollMoved(index: 0)
        curView = .WINEV
        manager.parentName = "Wine"
        
    }
    @IBAction func mBeerBtnDown(_ sender: Any) {
        let btn = sender as! UIButton
        self.selection(btn)
        selectedIndex = 2
        self.scrollMoved(index: 2)
        curView = .BEERV
        manager.parentName = "Beer"
    }
    
    @IBAction func mLiquorBtnDown(_ sender: Any) {
        let btn = sender as! UIButton
        self.selection(btn)
        selectedIndex = 1
        self.scrollMoved(index: 1)
        curView = .LIQUORV
        manager.parentName = "Liquor"
    }
    
    func selection(_ btn: UIButton){
        btn.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
}


//MARK: - DDWineCategoryMainViewProtocol

extension WineDetailViewController : DDWineCategoryMainViewProtocol
{
    func productTapped(item: ProductItem) {
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleWineViewController") as! SingleWineViewController
        controller.productData = item
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func productsView() {
        if islast! {
            if finalProducts.count > 0 {
                let aView = DDWineAllCategories()
                let adView = DDWineCategoryMainView()
                
                aView.delegate = self //as! DDWineAllCategoriesDelegate
                scrollView.addSubview(aView)
                scrollView.bringSubview(toFront: aView)
                
                adView.tableView.bringSubview(toFront: aView)
                if(selectedIndex == 1){
                    aView.title.text = "All Straight whiskey"
                }
                else if(selectedIndex == 2){
                    aView.title.text = "All Beer"
                }
                else if (selectedIndex == 0){
                    aView.title.text = "All Wine"
                }
                aView.setupData(productData: finalProducts)
                viewsArray.updateValue(aView, forKey: selectedIndex)
                aView.frame = CGRect(x:CGFloat(selectedIndex) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            }
            
        } else {
            let aView = DDWineCategoryMainView()
            aView.delegate = self
            scrollView.addSubview(aView)
            aView.tableView.reloadData()
            scrollView.bringSubview(toFront: aView)
            if selectedIndex == 0 {
                aView.setData(storeData: wineData)
            } else if selectedIndex == 1 {
                aView.setData(storeData: liqourData)
            } else if selectedIndex == 2 {
                aView.setData(storeData: beerData)
            }
            viewsArray.updateValue(aView, forKey: selectedIndex)
            aView.frame = CGRect(x:CGFloat(selectedIndex) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        }
    }
    
    func changeView(storeID: Int, CategoryID: Int, CategoryParentID: Int) {
        self.storeID = storeID
        self.categoryID = CategoryID
        self.CategoryParentId = CategoryParentID
        if selectedIndex == 0 {
            categoryName = "Wine"
        } else if selectedIndex == 1 {
            categoryName = "Liquor"
        } else if selectedIndex == 2 {
            categoryName = "Beer"
        }
        storeCategory()
    }
    
    func addBackButtonToNavigationBarCustom(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBackCustom))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
    }
    
    func goBackCustom(){
        
        if  isDirectlygoToSubCat == false {
            self.navigationController?.popViewController(animated: true)
            if(viewsArray[selectedIndex] != nil){
                let aView = viewsArray[selectedIndex] as! UIView
                aView.removeFromSuperview()
                viewsArray.removeValue(forKey: selectedIndex)
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}


//MARK: - UITextFieldDelegate

extension WineDetailViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


//MARK: - DDWineAllCategoriesDelegate

extension WineDetailViewController: DDWineAllCategoriesDelegate{
    func productCellTapped(item: ProductItem){
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleWineViewController") as! SingleWineViewController
        controller.productData = item
        self.navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - Web Service

extension WineDetailViewController {
    
    func storeCategory() {
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Request Successful")
                let resultss = result["Result"] as? NSDictionary
                //let categoriesArr = responseResult!["Categories"] as! NSDictionary
                var resultData  = ProductsArray()
                resultData = ProductsArray(value: result["Result"] as? NSDictionary!)
                var storeID = -1
                self.wineData.removeAll()
                self.liqourData.removeAll()
                self.beerData.removeAll()
                self.finalProducts.removeAll()
                print("\(resultData.Categories)")
                let wineArray = resultData.Categories.Wine
                for item in wineArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.wineData.append(itemMod)
                }
                let liquorArray = resultData.Categories.Liquor
                for item in liquorArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.liqourData.append(itemMod)
                }
                let beerArray = resultData.Categories.Beer
                for item in beerArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.beerData.append(itemMod)
                }
                let productArray = resultData.Products
                for item in productArray{
                    let itemMod = ProductItem(value: item)
                    itemMod.Store_id = storeID
                    self.finalProducts.append(itemMod)
                }
                
                
                self.islast = resultData.IsLast
                if !(self.viewCheck) {
                    self.productsView()
                } else {
                }
                
                let lastWine = resultss!["WineLastProducts"] as? NSArray
                let lastliquor = resultss!["LiquorLastProducts"] as? NSArray
                let lastbeer = resultss!["BeerLastProducts"] as? NSArray
                
                
                if self.wineData.count == 0 {
                    if lastWine?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 0
                        self.isDirectlygoToSubCat = true
                        self.finalProducts.removeAll()
                        for item in lastWine! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
                
                if self.liqourData.count ==  0 {
                    if lastliquor?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 1
                        self.isDirectlygoToSubCat = true
                        self.finalProducts.removeAll()
                        for item in lastliquor! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
                
                if self.beerData.count ==  0 {
                    if lastbeer?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 2
                        self.isDirectlygoToSubCat = true
                        self.finalProducts.removeAll()
                        for item in lastbeer! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
            }
        }
        
        categoryName = categoryName.replacingOccurrences(of: " ", with: "%20")
        
        let parameters: Parameters = [
            "Store_Id": String(storeID),     // self.userLng,
            "Category_Id": String(categoryID),    // self.userLat,
            "Category_ParentId": String(CategoryParentId),
            "CategoryName": categoryName,
            "Page": "",
            "Items": ""
        ]
        
        APIManager.sharedInstance.alcoholStoreCategoryDetail(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    func storeCategoryFilter(){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Request Successful")
                let resultss = result["Result"] as? NSDictionary
                //let categoriesArr = responseResult!["Categories"] as! NSDictionary
                var resultData  = ProductsArray()
                resultData = ProductsArray(value: result["Result"] as? NSDictionary!)
                var storeID = -1
                self.wineData.removeAll()
                self.liqourData.removeAll()
                self.beerData.removeAll()
                self.finalProducts.removeAll()
                print("\(resultData.Categories)")
                let wineArray = resultData.Categories.Wine
                for item in wineArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.wineData.append(itemMod)
                }
                let liquorArray = resultData.Categories.Liquor
                for item in liquorArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.liqourData.append(itemMod)
                }
                let beerArray = resultData.Categories.Beer
                for item in beerArray{
                    let itemMod = Category(value: item)
                    let products = itemMod.Products
                    products.forEach({ (prod) in
                        storeID = itemMod.Store_Id
                        prod.Store_id = itemMod.Store_Id
                    })
                    self.beerData.append(itemMod)
                }
                let productArray = resultData.Products
                for item in productArray{
                    let itemMod = ProductItem(value: item)
                    itemMod.Store_id = storeID
                    self.finalProducts.append(itemMod)
                }
                self.islast = resultData.IsLast
                if !(self.viewCheck) {
                    self.productsView()
                } else {
                }
                
                let lastWine = resultss!["WineLastProducts"] as? NSArray
                let lastliquor = resultss!["LiquorLastProducts"] as? NSArray
                let lastbeer = resultss!["BeerLastProducts"] as? NSArray
                
                
                if self.wineData.count == 0 {
                    if lastWine?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 0
                        self.finalProducts.removeAll()
                        for item in lastWine! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
                
                if self.liqourData.count ==  0 {
                    if lastliquor?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 1
                        self.finalProducts.removeAll()
                        for item in lastliquor! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
                
                if self.beerData.count ==  0 {
                    if lastbeer?.count != 0 {
                        self.viewCheck = false
                        self.selectedIndex = 2
                        self.finalProducts.removeAll()
                        for item in lastbeer! {
                            let items = item as! NSDictionary
                            let objArr = ProductItem(value: items)
                            self.finalProducts.append(objArr)
                        }
                        self.islast = resultData.IsLast
                        self.productsView()
                    }
                }
            }
        }
        
        let parameters: Parameters = [
            "SortBy": manager.sortBy!,
            "Country": manager.Country!,
            "Price": manager.Price!,
            "Size": manager.Size!,
            "Type_Id":categoryID.description,
            "ParentName":manager.parentName!,
            "ProductNetWeight": manager.Size!,
            ]
        
        APIManager.sharedInstance.getAlcoholSubFilters(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
