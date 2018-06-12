//
//  DDSearchViewController.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Alamofire
import DZNEmptyDataSet
import MapKit
struct PlaceInfo {
    var formattedAddress: String!
    var streetAddress : String!
    var addressLine : String!
    var city : String!
    var state : String!
    var stateCode : String!
    var zipCode : String!
    var country : String!
    var countryCode : String!
    var lat : Double!
    var lng : Double!
}


class DDSearchViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Varaiables
    
    var searchField: DDSimpleTextField = DDSimpleTextField()
    var arrayCount = 2
    var searchTile = ""
    var location = CLLocationCoordinate2D()
    var placeArr = [PlaceInfo]()
    var productArray = [ProductItem]()
    var sendProductValue: ProductItem = ProductItem()
    var viewCheck : Bool!
    var isGernalSearch: Bool = false
    var proStoreId = ""
    var store: StoreItem!
    var index: Int = -1
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        searchField.textField.delegate = self
        if proStoreId != ""{
            self.getStoreSchedule(storeId: proStoreId, homeCheck: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addBackButtonToNavigationBar()
        navigationItem.titleView?.sizeToFit()
        productArray.removeAll()
        tableView.reloadData()
        setSerachField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchField.textField.placeholder = "search"
    }
    
    
    //MARK: - Helping Method
    
    func setSerachField(){
        searchField.rightButton.setImage(UIImage(named: "cross_white_icon"), for: .normal)
        searchField.rightButton.addTarget(self, action: #selector(searchRightButtonTapped), for: .touchUpInside)
        searchField.textField.backgroundColor = UIColor.clear
        searchField.textField.placeholder = "search"
        searchField.view.backgroundColor = UIColor.clear
        searchField.backgroundColor = UIColor.clear
        searchField.placeHolderColor = UIColor.white
        searchField.textField.textColor = UIColor.white
        searchField.bottomView.backgroundColor = UIColor.white
        searchField.textField.keyboardType = .webSearch
        searchField.frame = CGRect(x: 0, y: 0, width: UILayoutFittingExpandedSize.width, height: 35)
        self.navigationItem.titleView = searchField
    }
    
    func searchRightButtonTapped(){
        searchField.textField.text = ""
        arrayCount = 0
        self.tableView.reloadData()
    }
    
    func getLocationAddress(location: NSDictionary){
        let lat = location["lat"] as! Double
        let lng = location["lng"] as! Double
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
    }
    
    func setAddressInfo(address: NSDictionary)-> PlaceInfo{
        let formattedAddress = address["formatted_address"] as! String
        let geo = address["geometry"] as! NSDictionary
        let loc = geo["location"] as! NSDictionary
        var place = PlaceInfo()
        let addressComponents = address["address_components"] as! NSArray
        
        place.formattedAddress = formattedAddress
        place.lat = loc["lat"] as! Double
        place.lng = loc["lng"] as! Double
        for add in addressComponents{
            let address = add as! NSDictionary
            let types = address["types"] as! NSArray
            for ty in types{
                let type = ty as! String
                if type == "street_number"{
                    place.streetAddress = address["long_name"] as! String
                }
                else if type == "route"{
                    place.addressLine = address["long_name"] as! String
                }
                else if type == "locality"{
                    place.city = address["long_name"] as! String
                }
                else if type == "administrative_area_level_1"{
                    place.state = address["long_name"] as! String
                    place.stateCode = address["short_name"] as! String
                }
                else if type == "postal_code"{
                    place.zipCode = address["long_name"] as! String
                }
                else if type == "country"{
                    place.country = address["long_name"] as! String
                    place.countryCode = address["short_name"] as! String
                }
            }
        }
        return place
    }
}


//MARK: -   UITableViewDataSource, UITableViewDelegate

extension DDSearchViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewCheck){
            return self.productArray.count
        }
        else{
            return self.placeArr.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (viewCheck){
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! DDSubDetailTableViewCell
            cell.selectionStyle = .none
            let item = productArray[indexPath.row]
            let url = item.Image?.getURL()
            cell.searchImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.searchName.text = item.Name!
            cell.searchDescription?.text = item.Description!
            cell.searchPrice?.text = "Price $" + ((item.Price.value)?.description)!
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! DDSubDetailTableViewCell
            let item = self.placeArr[indexPath.row]
            cell.selectionStyle = .none
            cell.address.text = item.formattedAddress
            
            var subAddressString = ""
            if item.city != nil && item.city != ""{
                subAddressString = item.city + " "
            }
            if item.stateCode != nil && item.stateCode != ""{
                if subAddressString.isEmpty{
                    subAddressString = item.stateCode
                }
                else{
                    subAddressString = subAddressString + ", " + item.stateCode
                }
            }
            if item.zipCode != nil && item.zipCode != ""{
                if subAddressString.isEmpty{
                    subAddressString = item.zipCode
                }
                else{
                    subAddressString = subAddressString + " " + item.zipCode
                }
            }
            cell.subAddress.text = subAddressString
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchField.textField.resignFirstResponder()
        if (viewCheck){
            index = indexPath.row
            self.getStoreSchedule(storeId: "\(productArray[indexPath.row].Store_id)", homeCheck: true)
        }
        else{
//            UserDefaults.standard.array(forKey: "alcoholStoreIds")
            UserDefaults.standard.removeObject(forKey: "alcoholStoreIds")
            let item = self.placeArr[indexPath.row]
            AppStateManager.sharedInstance.selectedAdd = item
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDHomeViewController") as! DDHomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (viewCheck){
            return 100
        }
        else{
            return 65
        }
    }
    
    func goToProductView(_ value: Int){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDProductViewController") as! DDProductViewController
        let item = productArray[value]
        vc.product = item
        vc.storeData = store
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//MARK: -  DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDSearchViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "No Result(s)"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = ""//"Your streams will be visible here"
        
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
        let text = ""//"Refresh"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: view.tintColor
            ] as [String : Any]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        print("Tapped")
    }
}


//MARK: - Textfield Delegate

extension DDSearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchField.textField{
            if textField.text != ""{
                let str = textField.text?.replacingOccurrences(of: " ", with: "%20")
                self.getProductByNameApi(str!,storeId: proStoreId,items: "20",page: "0")
            }
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if newString.length >= 3{
            if (newString.length % 3 == 0){
                
                var searchValue = newString as String
                searchValue = searchValue.replacingOccurrences(of: " ", with: "%20")
                
                if viewCheck == true {
                    self.getProductByNameApi(searchValue,storeId: proStoreId,items: "20",page: "0")
                }else {
                    self.getGooglePlacesAPI(string: searchValue)
                }
            }
        }
        return true
    }
}


//MARK: - WebService

extension DDSearchViewController{
    func getGooglePlacesAPI(string: String){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "api_key":"\(Constants.GOOGLE_API_KEY)",
            "search_string":"\(string)"]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let responseArr = result["results"] as! [[String:Any]]
            for resp in responseArr{
                if resp.count != 0 {
                    self.placeArr.removeAll()
                }
                let responseRes = resp as NSDictionary
                self.placeArr.append(self.setAddressInfo(address: responseRes))
                
            }
            self.tableView.reloadData()
 
        }
        APIManager.sharedInstance.googlePlacesAPI(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    // GET PRODUCT BY NAME API
    
    
    func getProductByNameApi(_ searchValue: String,storeId: String,items: String,page: String){
        
        self.startLoading()
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
                
                if self.productArray.count != 0 {
                    self.productArray.removeAll()
                }
                
                let responceResult = result["Result"] as! NSDictionary
                let searchItem = responceResult["productslist"] as! NSArray
                
                for item in searchItem {
                    let value = item as! NSDictionary
                    let valueAdd = ProductItem(value:value)
                    self.productArray.append(valueAdd)
                }
                self.tableView.reloadData()
            }
            else{
              //  self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        if isGernalSearch == true {
            let parameters: Parameters = [
                
                "search_string": searchValue ,
                "Items": items,
                "Page": page,
                ]
            
            APIManager.sharedInstance.getGernalProductByName(parameters: parameters,success: successClosure) { (error) in
                print (error)
                self.showErrorWith(message: error.localizedDescription)
                self.stopLoading()
            }
        }
        else {
            
            let parameters: Parameters = [
                
                "search_string": searchValue ,
                "Store_id": proStoreId,
                "Items": items,
                "Page": page,
                ]
            
            APIManager.sharedInstance.getProductByName(parameters: parameters,success: successClosure) { (error) in
                print (error)
                self.showErrorWith(message: error.localizedDescription)
                self.stopLoading()
            }
        }
    }
    
    //GET Store Schedulle
    
    func getStoreSchedule(storeId: String, homeCheck: Bool){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            "Store_Id": storeId,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                let responseResult = result["Result"] as! NSDictionary
                let storeitemss = responseResult["Store"] as! NSDictionary
                if let storeItems = responseResult["Store"] as? NSDictionary{
                    let storeObj = StoreItem(value: storeItems)
                    self.store = storeObj
                }
                
                let deliverytypeArray = storeitemss["StoreDeliveryTypes"] as! NSArray
                let appManger = AppStateManager.sharedInstance
                
                for ditem in deliverytypeArray{
                    let items = DeliverySchedule(value: ditem as! NSDictionary)
                    appManger.deliveryTypes.append(items)
                }
                if (homeCheck){
                    self.goToProductView(self.index)
                }
            }
            else{
               // self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        
        APIManager.sharedInstance.getStoreSchedule(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
