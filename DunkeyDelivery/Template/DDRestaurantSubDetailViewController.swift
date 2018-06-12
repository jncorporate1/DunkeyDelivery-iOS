//
//  DDRestaurantSubDetailViewController.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet

class DDRestaurantSubDetailViewController: BaseController {

    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var searchField: UITextField = UITextField()
    var catDetail = CategoryDetail()
    var productArr = [ProductItem]()
    var pageNum = 1
    var storeData: StoreItem!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        setUpData()
        setUpDelegates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeNavigationBar()
        self.addBackButtonToNavigationBar()
        setMiddleSearchBar()
        setNavigationRightItems()
        hideTabBarAnimated(hide:false)
        self.navigationController?.navigationBar.isHidden = false
    }
    

    //MARK: - Helping Method
    
    func setUpDelegates(){
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    func setUpData(){
        self.categoryProductService(pageNo: 0)
        if self.catDetail != nil{
            
        }
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
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
    }
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.isHeroEnabled = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func locationSearchTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        controller.viewCheck = true
        controller.proStoreId = "\(productArr[0].Store_id)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension DDRestaurantSubDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.productArr[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "subDetailCell", for: indexPath) as! DDSubDetailTableViewCell
        cell.productName.text = item.Name
        if item.Description != nil{
            cell.descrLabel.text = item.Description
        }
        let url = item.Image?.getURL()
        cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
        cell.price.text = "Price $" + (item.Price.value!.description)
        cell.setNormal()
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.productArr[indexPath.row]
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDProductViewController") as! DDProductViewController
        vc.product = item
        vc.storeData = storeData
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - UITextFieldDelegate

extension DDRestaurantSubDetailViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


//MARK: - UIScrollViewDelegate

extension DDRestaurantSubDetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if (bottomEdge >= scrollView.contentSize.height) {
            self.categoryProductService(pageNo: pageNum)
            pageNum = pageNum + 1
        }
    }
}


//MARK: - Webservice

extension DDRestaurantSubDetailViewController{
    
    func categoryProductService(pageNo: Int){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            self.stopLoading()
            return
        }
        
        let parameters: Parameters = [
            
            "Category_Id":"\(self.catDetail.Id)",
            "page_no":"\(pageNo)",
            "num_items":"10"]

        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                let responseResult = result["Result"] as! NSDictionary
                let products = responseResult["productslist"] as! NSArray
                
                for product in products{
                    let proDic = ProductItem(value: product as! NSDictionary)
                    self.productArr.append(proDic)
                }
                self.tableView.reloadData()
                
            }else if(response?.intValue == 403){
                
                self.showErrorWith(message: "Error")
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getCategoryProduct(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}


//MARK: -  DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDRestaurantSubDetailViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "No products are currently available."//"Cart is empty."
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
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = ""//"Add items in cart"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: Constants.APP_COLOR
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        // self.addmoreItemButtonTapped()
    }
}
