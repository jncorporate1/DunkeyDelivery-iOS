//
//  DDHomeViewController.swift
//  Template
//
//  Created by Ingic on 7/24/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Device
import CoreLocation
import RealmSwift
import Alamofire



class DDHomeViewController: BaseController, UIScrollViewDelegate {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var scrollMainView: UIScrollView!
    @IBOutlet weak var scrollViewButtons: UIScrollView!
    @IBOutlet weak var productSearchOutlet: UIButton!
    
    
    //MARK: - Variables
    
    var searchField: UITextField = UITextField()
    var locationManager: CLLocationManager!
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var startDate: Date!
    var traveledDistance: Double = 0
    var popularStores = [StoreItem]()
    var nearByStores = [StoreItem]()
    var views = [tabSummaryView]()
    var lastContentOffset: CGFloat = 0
    var mainViews = [DDMainTableView]()
    var alcoholView = DDWineMainView()
    var rideView = DDRideView()
    var uiColorArray = [UIColor]()
    var lastSelectedIndex : Int!
    var selectedIndex : Int!
    var selectedPoints : CGPoint!
    var buttonCheck : Bool!
    var buttonCheckTwo : Bool!
    var loadCheck : Bool!
    var viewCheck = false
    var rideViewHeight : CGFloat!
    var otherViewHeight : CGFloat!
    var viewsHeightArray = [0,0,0,0,0,0,0]
    var rowHeight = 110
    var revealController = SWRevealViewController()
    var tapGesture : UITapGestureRecognizer!
    var searchFrontButton : UIButton!
    var scrollCheck : Bool!
    let refreshControl = UIRefreshControl()
    var foodArray = [StoreItem]()
    var groceryArray = [StoreItem]()
    var laundryArray = [StoreItem]()
    var pharmacyArray = [StoreItem]()
    var retailArray = [StoreItem]()
    var alcoholArray = [StoreItem]()
    var array = ["Restaurants","alcohol","Grocery","Laundry","Pharmacy","Retail","ride"]
    var unselected_icons = ["food_unselected_icon","alcohol_unselected_icon","grocery_unselected_icon","laundry_unselected_icon","pharmacy_unselected_icon","retail_unselected_icon","ride_unselected_icon"]
    var selected_icons = ["food_icon","alcohol_icon","grocery_icon","laundry_icon","pharmacy_icon","retail_icon","ride_icon"]
    var popularLabelArray = ["Restaurants","alcohol","Grocery","Laundry","Pharmacy","Retail","ride"]
    //userLocation initialization
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var userLat: String!
    var userLng: String!
    var geocoder = CLGeocoder()
    var currentlocationisEnable: Bool = true
    var manager = AppStateManager.sharedInstance
    var isViewHeightEnable: Bool = false
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locManager.requestWhenInUseAuthorization()
        self.getlocationPermission()
        lastSelectedIndex = 0
        selectedIndex = 0
        buttonCheck = true
        buttonCheckTwo = true
        loadCheck = true
        setNavigationRightItems()
        setMiddleSearchBar()
        setTabBarAppearence()
        self.setDelegates()
        setViewArray()
        setColorArray()
        setViewToggle()
        rideView.delegate = self
        rideViewHeight = CGFloat(431)
        setMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeNavigationBar()
        getPoints()
        setUpNotification()
        homeWebServices()
        self.navigationController?.navigationBar.isHidden = false
        hideTabBarAnimated(hide: false)
        setViewToggle()
    }
    
    override func viewDidLayoutSubviews() {
        if (loadCheck){
            self.setUpScroll()
            loadCheck = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setUpNotification(){
        
        if UserDefaults.standard.object(forKey: "apns_token") != nil {
            let token = UserDefaults.standard.object(forKey: "apns_token") as! String
            Utility.registerPushNotification(device_apn: token)
        }
    }
    
    
    func setUpAlcoholViewFrame(){
        if alcoholArray.count != 0{
            isViewHeightEnable = true
            alcoholView.frame = CGRect(x: CGFloat(1) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height:  scrollMainView.frame.size.height )
            return
        }
        else{
            if isViewHeightEnable {
                alcoholView.frame = CGRect(x: CGFloat(1) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height:  scrollMainView.frame.size.height)
            }else{
                alcoholView.frame = CGRect(x: CGFloat(1) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height:  scrollMainView.frame.size.height + 130)
            }
        }
    }
    func homeWebServices(){
        self.startLoading()
        if AppStateManager.sharedInstance.selectedAdd != nil{
            currentlocationisEnable = false
            userLat = "\(AppStateManager.sharedInstance.selectedAdd.lat!)"
            userLng = "\(AppStateManager.sharedInstance.selectedAdd.lng!)"
            self.searchField.placeholder = "\(AppStateManager.sharedInstance.selectedAdd.state!),a \(AppStateManager.sharedInstance.selectedAdd.country!)"
        }
        else if currentlocationisEnable == true {
            if locManager.location?.coordinate.latitude != nil {
               
                currentLocationTapped()
            }
            else {
                self.searchField.placeholder = "  Search"
                userLat = "0"
                userLng = "0"
            }
        }
        AppStateManager.sharedInstance.filterTypeID = -1
        if manager.Country == "" && manager.Size == "" && manager.Price == "" && manager.sortBy == "" {
            self.startLoading()
            alcohalApiCall()
        } else {
            alcohalFilterApiCall()
        }
        categoryServices()
        scrollCheck = true
    }
    
    func categoryServices(){
        self.startLoading()
        if AppStateManager.sharedInstance.filterObj == nil {
            
            self.homeCategoryService(index: 0, refreshControl: UIRefreshControl(), categoryName:"Food")
            self.homeCategoryService(index: 2, refreshControl: UIRefreshControl(), categoryName:"Grocery")
            self.homeCategoryService(index: 3, refreshControl: UIRefreshControl(), categoryName:"Laundry")
            self.homeCategoryService(index: 4, refreshControl: UIRefreshControl(), categoryName:"Pharmacy")
            self.homeCategoryService(index: 5, refreshControl: UIRefreshControl(), categoryName:"Retail")
        }
        else{
            if AppStateManager.sharedInstance.filterObj.name == "Restaurants"{
                self.homeCategoryService(index: 0, refreshControl: UIRefreshControl(),categoryName:"Food")
            }
            if AppStateManager.sharedInstance.filterObj.name ==  "Grocery" {
                self.homeCategoryService(index: 2, refreshControl: UIRefreshControl(), categoryName:"Grocery")
            }
            if AppStateManager.sharedInstance.filterObj.name ==   "Laundry" {
                self.homeCategoryService(index: 3, refreshControl: UIRefreshControl(), categoryName:"Laundry")
            }
            if AppStateManager.sharedInstance.filterObj.name ==  "Pharmacy" {
                self.homeCategoryService(index: 4, refreshControl: UIRefreshControl(), categoryName:"Pharmacy")
            }
            if AppStateManager.sharedInstance.filterObj.name ==  "Retail" {
                self.homeCategoryService(index: 5, refreshControl: UIRefreshControl(), categoryName:"Retail")
            }}
            alcoholAPIDelegate(false)
    }
    
    func setMenuButton(){
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> () -> Void)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func setViewToggle(){
        self.revealViewController().delegate = self
        self.tapGesture = UITapGestureRecognizer(target: self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.tapGesture.isEnabled = false
        self.view.addGestureRecognizer(revealController.panGestureRecognizer())
    }
    
    func getRideButtonSize() -> Int{
        var xValue: Int = 0
        switch Device.size() {
        case .screen3_5Inch:
            xValue = 0
        case .screen4Inch:
            xValue = 0
        case .screen4_7Inch:
            xValue = 60
        case .screen5_5Inch:
            xValue = 20
        default:
            xValue = 60
        }
        return xValue
    }
    
    func setDelegates(){
        alcoholView.delegate = self
    }
    
    func setOtherNavigation(){
        setNavigationRightItems()
        setMiddleSearchBar()
        self.scrollMainView.alwaysBounceVertical = true
    }
    func setRideNavigation(){
        self.scrollMainView.contentInset = UIEdgeInsets.zero
        self.scrollMainView.scrollIndicatorInsets = UIEdgeInsets.zero
        self.navigationItem.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "Ride"
        self.scrollMainView.alwaysBounceVertical = false
        self.navigationItem.rightBarButtonItems = nil
        self.scrollMainView.contentSize.height = rideViewHeight
    }
    func setTabBarAppearence(){
        let tabBar = self.tabBarController?.tabBar
        let numberOfItems = CGFloat((tabBar?.items!.count)!)
        let tabBarItemSize = CGSize(width: (tabBar?.frame.width)! / numberOfItems, height: (tabBar?.frame.height)!)
        tabBar?.selectionIndicatorImage = UIImage.imageWithColor(color: UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0), size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        tabBar?.frame.size.width = self.view.frame.width + 4
        tabBar?.frame.origin.x = 0
        //tabBar?.frame.origin.y = 0
        
    }
    func setMiddleSearchBar(){
        self.searchField.frame = CGRect(x: 0.0, y: 0.0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 30.0)
        self.searchField.minimumFontSize = 9.0
        searchFrontButton = UIButton(frame: self.searchField.frame)
        searchFrontButton.addTarget(self, action: #selector(locationSearchTapped), for: .touchUpInside)
        self.searchField.font = UIFont(name: "Montserrat-Regular", size: 11.0)
        self.searchField.textColor = UIColor.darkGray
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "target_icon"), for: .normal)
        button.frame = CGRect(x: CGFloat(self.searchField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(currentLocationTapped), for: .touchUpInside)
        self.searchField.rightView = button
        self.searchField.rightViewMode = .always
        self.searchField.layer.masksToBounds = true
        self.searchField.layer.cornerRadius = 5.0
        self.searchField.backgroundColor = UIColor.init(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
        let paddingView = UIView(frame: CGRect(x:0, y:0, width:7, height:self.searchField.frame.height))
        self.searchField.leftView = paddingView
        self.searchField.leftViewMode = UITextFieldViewMode.always
        searchField.addSubview(searchFrontButton)
        self.searchField.endEditing(true)
        self.searchField.delegate = self
        self.navigationItem.titleView = self.searchField
    }
    
    func currentLocationTapped(){
         UserDefaults.standard.removeObject(forKey: "alcoholStoreIds")
        self.startLoading()
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorized){
            currentLocation = locManager.location
            let latitude = Double((locManager.location?.coordinate.latitude)!)
            let longtitude = Double((locManager.location?.coordinate.longitude)!)
        
            AppStateManager.sharedInstance.latitude = latitude as Double
            AppStateManager.sharedInstance.longitude = longtitude as Double

            if AppStateManager.sharedInstance.selectedAdd != nil{
                
            AppStateManager.sharedInstance.selectedAdd.lat =  latitude
            AppStateManager.sharedInstance.selectedAdd.lng =  longtitude
                
            }
            self.userLat = latitude.description
            self.userLng = longtitude.description
            
            let value = latitude.description + "," + longtitude.description
            
            self.googlePlacesAPIReverse(latnLng: value)
            
            // Get current address in form of string with reverse geocoding
            
         /*   let location = CLLocation(latitude: latitude, longitude: longtitude)
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
                self.stopLoading()
            }*/
            categoryServices()
        }
        else {
            self.stopLoading()
            showLocationAlert()
        }
    }
    
    
    
    
    func showLocationAlert(){
        UIAlertController.showAlert(
            in: self,
            withTitle: "Dunkey Delivery",
            message: "Turn on Location Services to Allow Your App to Determine Your Location",
            cancelButtonTitle: "Ok",
            destructiveButtonTitle: nil,
            otherButtonTitles: nil,
            tap: {(controller, action, buttonIndex) in
                if (buttonIndex == controller.cancelButtonIndex) {
                    print("Cancel Tapped")
                    self.navigationController?.popToRootViewController(animated: true)
                } else if (buttonIndex == controller.destructiveButtonIndex) {
                    print("Delete Tapped")
            }})
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            self.searchField.placeholder = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self.searchField.placeholder = placemark.compactAddress
                if AppStateManager.sharedInstance.selectedAdd != nil {
                AppStateManager.sharedInstance.selectedAdd.state = placemark.compactAddress
                }
            } else {
                self.searchField.placeholder = "No Matching Addresses Found"
            }
        }
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
        if self.array[self.selectedIndex] == "alcohol"{
            let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
            let wineFilter = storyboard.instantiateViewController(withIdentifier: "WineFilterViewController") as! WineFilterViewController
            wineFilter.navigationTitle = "Filter for Alcohol"
            self.navigationController?.pushViewController(wineFilter, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
            let mainFilter = storyboard.instantiateViewController(withIdentifier: "MainFilterViewController") as! MainFilterViewController
            if self.array[self.selectedIndex] == "Restaurants"{
                mainFilter.filterViewCheck = false
                mainFilter.categoryName = self.array[self.selectedIndex]
            }
            else{
                mainFilter.filterViewCheck = true
                mainFilter.categoryName = self.array[self.selectedIndex]
            }
            self.navigationController?.pushViewController(mainFilter, animated: true)
        }
    }
    
    func refreshData(refreshContrl: UIRefreshControl ){
        refreshContrl.endRefreshing()
    }
    
    // MARK: - ScrollSetup
    
    func setColorArray(){
        self.uiColorArray.append(UIColor(red:0.91, green:0.43, blue:0.18, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.09, green:0.58, blue:0.81, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.61, green:0.41, blue:0.68, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.85, green:0.30, blue:0.36, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.51, green:0.72, blue:0.28, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.87, green:0.65, blue:0.00, alpha:1.0))
        self.uiColorArray.append(UIColor(red:0.11, green:0.64, blue:0.69, alpha:1.0))
    }
    
    func setViewArray(){
        for i in 0...6{
            self.views.append(tabSummaryView())
            self.mainViews.append(DDMainTableView())
            self.mainViews[i].delegate = self
        }
    }
    func setUpScroll(){
        scrollMainView.backgroundColor = UIColor.clear
        scrollMainView.delegate = self
        scrollViewButtons.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.setUpButtonScroll()
        self.setUpMainScroll()
        self.scrollMainView.alwaysBounceVertical = true
    }
    func setUpButtonScroll(){
        for i in 0...6 {
            let buttonView = views[i]
            buttonView.frame = CGRect(x: CGFloat(i) * 62.5, y: 0.0, width: 62.5, height: 80)
            buttonView.viewTapped.tag = i
            buttonView.viewTapped.addTarget(self, action: #selector(scrollButtonTapped(sender:)), for: .touchUpInside)
            self.setView(sender: buttonView)
            scrollViewButtons.addSubview(buttonView)
        }
        scrollViewButtons.contentSize = CGSize(width: 437.5, height: 80.0)
    }
    
    func setUpMainScroll(){
        for i in 0...6 {
            if (i == 1){
                let aView = self.alcoholView
                setUpAlcoholViewFrame()
//                aView.backgroundColor = UIColor.clear
//                aView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height:  scrollMainView.frame.size.height )
//                aView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height: scrollMainView.frame.size.height + 130)
                scrollMainView.addSubview(aView)
            }

            else if (i == 6){
                let aView = self.rideView
                aView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height: scrollMainView.frame.size.height)
                scrollMainView.addSubview(aView)
            }
            else{
                let mainView = self.mainViews[i]
                mainView.viewValue = array[i]
                mainView.refreshControl.tintColor = self.uiColorArray[i]
                mainView.frame = CGRect(x: CGFloat(i) * UIScreen.main.bounds.size.width, y: 0.0, width: scrollMainView.frame.size.width, height:  scrollMainView.frame.size.height)
                scrollMainView.frame = CGRect(x: 0, y: 0, width: scrollMainView.frame.size.width, height: scrollMainView.frame.size.height)
                scrollMainView.addSubview(mainView)
                self.scrollMainView.layoutIfNeeded()
            }
        }
        scrollMainView.contentSize = CGSize(width: 7 * UIScreen.main.bounds.size.width, height: scrollMainView.frame.height )
        
    }
    func setButtonView(index: Int, lastIndex: Int){
        let selectedView = self.views[index]
        selectedView.menuIcon.image = UIImage(named: self.selected_icons[index])
        let selectedColor = self.uiColorArray[index]
        selectedView.backgroundView.backgroundColor = selectedColor
        selectedView.menuTitle.textColor = UIColor.white
        let lastView = self.views[lastIndex]
        lastView.menuIcon.image = UIImage(named: self.unselected_icons[lastIndex])
        lastView.backgroundView.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        lastView.menuTitle.textColor = UIColor.black
    }
    
    func scrollButtonTapped(sender: UIButton){
        self.scrollMainView.contentOffset.y = 0.0
        self.selectedIndex = sender.tag
        if self.selectedIndex != self.lastSelectedIndex{
            setButtonView(index: self.selectedIndex, lastIndex: self.lastSelectedIndex)
            let scrollPoint = CGPoint(x: CGFloat(sender.tag) * UIScreen.main.bounds.size.width, y: 0.0)
            self.scrollMainView.setContentOffset(scrollPoint, animated: true)
            if sender.tag == 6{
                let value = getRideButtonSize()
                self.scrollViewButtons.setContentOffset(CGPoint(x: CGFloat(value), y: 0), animated: true)
                self.setRideNavigation()
            }
            else if sender.tag == 0{
                self.scrollViewButtons.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                self.setOtherNavigation()
            }
            else{
                switch sender.tag {
                case 2:
                    self.setOtherNavigation()
                case 3:
                    self.setOtherNavigation()
                case 4:
                    self.setOtherNavigation()
                case 5:
                    self.setOtherNavigation()
                default:
                    break
                }
            }
            self.lastSelectedIndex = self.selectedIndex
        }
    }
    
    func scrollMoved(index: Int){
        self.selectedIndex = index
        if self.selectedIndex != self.lastSelectedIndex{
            setButtonView(index: self.selectedIndex, lastIndex: self.lastSelectedIndex)
            let scrollPoint = CGPoint(x: CGFloat(index) * UIScreen.main.bounds.size.width, y: 0)
            self.scrollMainView.setContentOffset(scrollPoint, animated: true)
            self.lastSelectedIndex = self.selectedIndex
        }
    }
    
    func setView(sender: tabSummaryView){
        let greyColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        switch sender.viewTapped.tag {
        case 0:
            sender.menuTitle.textColor = UIColor.white
            sender.setMenuItem(color: UIColor.orange, title: "Food", icon: "food_icon")
        case 1:
            sender.setMenuItem(color: greyColor, title: "Alcohol", icon: "alcohol_unselected_icon")
        case 2:
            
            sender.setMenuItem(color: greyColor, title: "Grocery", icon: "grocery_unselected_icon")
        case 3:
            sender.setMenuItem(color: greyColor, title: "Laundry", icon: "laundry_unselected_icon")
        case 4:
            sender.setMenuItem(color: greyColor, title: "Pharmacy", icon: "pharmacy_unselected_icon")
        case 5:
            sender.setMenuItem(color: greyColor, title: "Retail", icon: "retail_unselected_icon")
        case 6:
            sender.setMenuItem(color: greyColor, title: "Ride", icon: "ride_unselected_icon")
        default:
            break;
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let mainOffsetX : CGFloat = UIScreen.main.bounds.size.width
        let buttonOffsetX : CGFloat = 62.5
        switch scrollMainView.contentOffset.x {
        case mainOffsetX * 0:
            if (buttonCheck){
                scrollViewButtons.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                scrollMoved(index:0)
                self.setOtherNavigation()
            }
        case mainOffsetX * 1:
            scrollMoved(index:1)
            self.setOtherNavigation()
        case mainOffsetX * 2:
            scrollMoved(index:2)
            self.setOtherNavigation()
        case mainOffsetX * 3:
            scrollMoved(index:3)
            self.setOtherNavigation()
        case mainOffsetX * 4:
            scrollMoved(index:4)
            self.setOtherNavigation()
        case mainOffsetX * 5:
            self.setOtherNavigation()
            scrollMoved(index:5)
        case mainOffsetX * 6:
            if (buttonCheckTwo){
                scrollMoved(index:6)
                let value = getRideButtonSize()
                self.scrollViewButtons.setContentOffset(CGPoint(x: CGFloat(value), y: 0), animated: true)
                self.setRideNavigation()
            }
        default:
            break;
        }
    }
    
    func locationSearchTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        controller.arrayCount = 0
        controller.viewCheck = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func setUpLaundry(){
        
    }
    
    func setUpFood(){
        
    }
    
    func getlocationPermission(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.distanceFilter = 10
    }
    
    //MARK: - Action
    
    @IBAction func productSearchTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        controller.searchTile = "Kru"
        controller.viewCheck = true
        controller.isGernalSearch = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - Custom DDMainTableViewDelegate

extension DDHomeViewController: DDMainTableViewDelegate{
    func refreshData(refreshControl: UIRefreshControl, check: Bool) {
        var catName = ""
        if self.selectedIndex == 0 {catName = "Food"}
        else if self.selectedIndex == 2 {catName = "Grocery"}
        else if self.selectedIndex == 3 {catName = "Laundry"}
        else if self.selectedIndex == 4 {catName = "Pharmacy"}
        else if self.selectedIndex == 5 {catName = "Retail"}
        if (check){
            self.startLoading()
        }
        self.homeCategoryService(index: 5, refreshControl: UIRefreshControl(), categoryName:catName)
        refreshData(refreshContrl: refreshControl)
    }
    
    func tableRowSelect(data: StoreItem){
        if self.array[self.selectedIndex] == "Pharmacy"{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDPharmacyDetailViewController") as! DDPharmacyDetailViewController
            vc.storeData = data
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDRestaurantDetailViewController") as! DDRestaurantDetailViewController
            vc.viewSring = self.array[self.selectedIndex]
            vc.storeData = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openFilter(){
        showFilters()
    }
    
}


// MARK: - Custom DDRideViewDelegate

extension DDHomeViewController: DDRideViewDelegate{
    func submitTapped(params: Parameters) {
        self.rideRegister(parameters: params)
    }
}


// MARK: - Custom DDWineMainViewDelegate

extension DDHomeViewController: DDWineMainViewDelegate{
   
    func alcoholAPIDelegate(_ value: Bool) {
        AppStateManager.sharedInstance.filterTypeID = -1
        if (value){
            self.startLoading()
        }
        if manager.Country == "" && manager.Size == "" && manager.Price == "" && manager.sortBy == "" {
            alcohalApiCall()
        } else {
            alcohalFilterApiCall()
        }
    }
    
    func categoryDetailButtonDown(storeID: Int, categoryID: Int, categoryName: String){
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WineDetailViewController") as! WineDetailViewController
        controller.storeID = storeID
        controller.categoryID = categoryID
        controller.categoryName = categoryName
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func storeDetailButtonDown() {
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WStoreInfoViewController") as! WStoreInfoViewController
        controller.alcoholArray = self.alcoholArray
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func itemDetailButtonDown(data: ProductItem) {
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SingleWineViewController") as! SingleWineViewController
        controller.productData = data
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
 /*   func alcoholAPIDelegate() {
        AppStateManager.sharedInstance.filterTypeID = -1
        if manager.Country == "" && manager.Size == "" && manager.Price == "" && manager.sortBy == "" {
            self.startLoading()
            alcohalApiCall()
            self.stopLoading()
        } else {
            alcohalFilterApiCall()
        }
    }*/
}


//MARK: - UITextFieldDelegate

extension DDHomeViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

// MARK: - SWRevealViewControllerDelegate

extension DDHomeViewController: SWRevealViewControllerDelegate{
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.right{
            self.tapGesture.isEnabled = true
            self.view.isUserInteractionEnabled = true
            scrollMainView.isUserInteractionEnabled = false
            scrollViewButtons.isUserInteractionEnabled = false
            productSearchOutlet.isUserInteractionEnabled = false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.navigationItem.titleView?.isUserInteractionEnabled = false
            self.searchFrontButton.isUserInteractionEnabled = false
        }
        else if position == FrontViewPosition.left{
            self.tapGesture.isEnabled = false
            self.view.isUserInteractionEnabled = true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            scrollMainView.isUserInteractionEnabled = true
            scrollViewButtons.isUserInteractionEnabled = true
            productSearchOutlet.isUserInteractionEnabled = true
            self.navigationItem.titleView?.isUserInteractionEnabled = true
            self.searchFrontButton.isUserInteractionEnabled = true
        }
    }
}


// MARK: - CLLocation Delegate

extension DDHomeViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            self.showLocationAlert()
            break
        case .denied:
            self.showLocationAlert()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startDate == nil {
            startDate = Date()
        } else {
            print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate)))
        }
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            traveledDistance += lastLocation.distance(from: location)
            
            print("Traveled Distance:",  traveledDistance)
            print("Straight Distance:", startLocation.distance(from: locations.last!))
        }
        lastLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}

// MARK: - Web Services

extension DDHomeViewController{
    
    //MARK: - Alcohal Web Service
    
    func alcohalFilterApiCall() {
      //  self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
       let manager = AppStateManager.sharedInstance
        
        let parameters: Parameters = [
            "longitude": self.userLng,      //"73.1580938",      // "151.208953857422",
            "latitude":  self.userLat,      //"33.5208204",             // "-33.8826912922134",
            "SortBy": manager.sortBy!,
            "Country": manager.Country!,
            "Price": manager.Price!,
            "ProductNetWeight": manager.Size!,

        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.alcoholArray.count != 0{
                    self.alcoholArray.removeAll()
                }
                
                print("Request Successful")
                let responseResult = result["Result"] as? NSDictionary
                let storeArr = responseResult!["Stores"] as! NSArray
                for item in storeArr{
                    let itemObj = item as! NSDictionary
                    let itemMod = StoreItem(value: itemObj)
                    self.alcoholArray.append(itemMod)
                }
                
                var ids = [String]()
                
                self.alcoholArray.forEach({ (store) in
                    ids.append(String(store.Id))
                })
                
                UserDefaults.standard.set(ids, forKey: "alcoholStoreIds")
                self.alcoholView.setdata(alcoholArray: self.alcoholArray)
                
            }
        }
        
        APIManager.sharedInstance.alcoholFilterStore(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    func alcohalApiCall() {
        //self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        var stringID = ""
        if let ids = UserDefaults.standard.array(forKey: "alcoholStoreIds") {
            
            for index in 0..<ids.count {
                
                if index == 0 {
                    stringID = String(describing: ids[index])
                } else {
                    stringID = stringID + "," + String(describing: ids[index])
                }
            }
        }
        
        let parameters: Parameters = [
            "longitude": self.userLng,    //"73.1580938",     // "151.208953857422",
            "latitude": self.userLat,     //"33.5208204",     // "-33.8826912922134",
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
                if self.alcoholArray.count != 0{
                    self.alcoholArray.removeAll()
                }
                
                print("Request Successful")
                let responseResult = result["Result"] as? NSDictionary
                let storeArr = responseResult!["Stores"] as! NSArray
                
                 //GET FilterSize Array
                self.stopLoading()
                
                if  self.manager.filterSizeArray.count != 0{
                    self.manager.filterSizeArray.removeAll()
                }
                let proSizes = responseResult!["FilterProductSizes"] as! NSArray
                
                for items in proSizes {
                    let itemObj = items as! NSDictionary
                    let sizeObj = FilterProductSize(value: itemObj)
                    self.manager.filterSizeArray.append(sizeObj)
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
                var ids = [String]()
                self.alcoholArray.forEach({ (store) in
                    ids.append(String(store.Id))
                })
                
                UserDefaults.standard.set(ids, forKey: "alcoholStoreIds")
                
                self.setUpAlcoholViewFrame()
                self.alcoholView.setdata(alcoholArray: self.alcoholArray)
                
            }
        }
        APIManager.sharedInstance.getAlcoholHomeScreen(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    //MARK: - Home Web Service
    
    func homeCategoryService(index : Int, refreshControl: UIRefreshControl, categoryName : String){
        //self.startLoading()
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
                refreshControl.endRefreshing()
                if self.popularStores.count != 0{
                    self.popularStores.removeAll()
                }
                if self.nearByStores.count != 0{
                    self.nearByStores.removeAll()
                }
                print("Request Successful")
                let responseResult = result["Result"] as! NSDictionary
                
                let nearStores = responseResult["NearByStores"] as! NSArray
                for nearStore in nearStores{
                    let nearDic = StoreItem(value: nearStore as! NSDictionary)
                    self.nearByStores.append(nearDic)
                }
                let popularStores = responseResult["PopularStores"] as! NSArray
                
                for popStore in popularStores{
                    let popDic = StoreItem(value: popStore as! NSDictionary)
                    self.popularStores.append(popDic)
                }
    
                if index == 0{
                    var check = false
                    if self.popularStores.count == 0 && self.nearByStores.count == 0{
                        check = true
                    }
                    self.mainViews[index].setFoodArray(array: self.popularStores, tableArray: self.nearByStores, check: check)
                    self.foodArray = self.nearByStores
                    DispatchQueue.main.async {
                        self.mainViews[index].tableView.reloadData()
                    }
                    self.viewsHeightArray[index] = (self.nearByStores.count * self.rowHeight)
                }
                else if index == 2{
                    var check = false
                    if self.popularStores.count == 0 && self.nearByStores.count == 0{
                        check = true
                    }
                    self.mainViews[index].setGroceryArray(array: self.popularStores, tableArray: self.nearByStores, check: check)
                    self.groceryArray = self.nearByStores
                    DispatchQueue.main.async {
                        self.mainViews[index].tableView.reloadData()
                    }
                    self.viewsHeightArray[index] = (self.nearByStores.count * self.rowHeight)
                }
                else if index == 3{
                    var check = false
                    if self.popularStores.count == 0 && self.nearByStores.count == 0{
                        check = true
                    }
                    self.mainViews[index].setLaundryArray(array: self.popularStores, tableArray: self.nearByStores, check: check)
                    self.laundryArray = self.nearByStores
                    DispatchQueue.main.async {
                        self.mainViews[index].tableView.reloadData()
                    }
                    self.viewsHeightArray[index] = (self.nearByStores.count * self.rowHeight)
                    
                }
                else if index == 4{
                    var check = false
                    if self.popularStores.count == 0 && self.nearByStores.count == 0{
                        check = true
                    }
                    self.mainViews[index].setPharmacyArray(array: self.popularStores, tableArray: self.nearByStores, check: check)
                    self.pharmacyArray = self.nearByStores
                    DispatchQueue.main.async {
                        self.mainViews[index].tableView.reloadData()
                    }
                    self.scrollMainView.contentOffset.y = 0.0
                    self.viewsHeightArray[index] = (self.nearByStores.count * self.rowHeight)
                }
                else if index == 5{
                    var check = false
                    if self.popularStores.count == 0 && self.nearByStores.count == 0{
                        check = true
                    }
                    self.mainViews[index].setRetailArray(array: self.popularStores, tableArray: self.nearByStores, check: check)
                    self.retailArray = self.nearByStores
                    DispatchQueue.main.async {
                        self.mainViews[index].tableView.reloadData()
                    }
                    self.viewsHeightArray[index] = (self.nearByStores.count * self.rowHeight)
                }
                refreshControl.endRefreshing()
                
            }else if(response?.intValue == 403){
                self.showErrorWith(message: "Invalid Email or Password")
                refreshControl.endRefreshing()
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                refreshControl.endRefreshing()
                return
            }
            
        }
        
        if AppStateManager.sharedInstance.filterObj == nil {
            let parameterss: Parameters = [
                "catId":"\(index)",
                "lng":self.userLng,  //,"73.1580034",//self.userLng
                "lat":self.userLat, //,"33.5206762",//self.userLat
            ]
            APIManager.sharedInstance.getHomeCategory(parameters: parameterss,success: successClosure) { (error) in
                print (error)
                self.showErrorWith(message: error.localizedDescription)
                self.stopLoading()
            }
        }
        else {
            
            let  parameterss : Parameters = [
                "CategoryName" : categoryName,
                "SortBy":  (manager.filterObj.sortBy).description,
                "Rating":  (manager.filterObj.rating).description,
                "MinDeliveryTime": (manager.filterObj.minDeliveryTime).description,
                "PriceRanges": manager.filterObj.priceRange!,
                "MinDeliveryCharges": (manager.filterObj.minDelvieryCharger).description,
                "IsSpecial": (manager.filterObj.isSpecial).description,
                "IsFreeDelivery": (manager.filterObj.isFreeDelivery).description,
                "IsNewRestaurants": (manager.filterObj.isNewRestaurants).description,
                "Cuisines": manager.filterObj.cuisines!,
                "latitude": self.userLat , //Double( AppStateManager.sharedInstance.selectedAdd.lat),
                "longitude": self.userLng, //Double( AppStateManager.sharedInstance.selectedAdd.lng),]
            ]
            APIManager.sharedInstance.getStoreFilters(parameters: parameterss,success: successClosure) { (error) in
                print (error)
                self.showErrorWith(message: error.localizedDescription)
                self.stopLoading()
            }
        }
    }
    
    //MARK: - Ride Web Service
    
    func rideRegister(parameters: Parameters){
        
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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDHomeViewController") as! DDHomeViewController
                self.navigationController?.pushViewController(vc, animated: true)
                self.showSuccessWith(message: "Rider registered successfully.")
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.rideRegister(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    //MARK: - Setting WebService
    
    func getPoints() {
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters : Parameters = [:]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            if(response?.intValue == 200){
                print("Success")
                let responseResult = result["Result"] as! NSDictionary
                print(responseResult)
                let stateManger = AppStateManager.sharedInstance.settingObj
                stateManger.Point = responseResult["Point"] as! Int
                stateManger.Currency = responseResult["Currency"] as? String
                stateManger.DeliveryFee = responseResult["DeliveryFee"] as! Int
                stateManger.Tip = responseResult["Tip"] as! Int
                stateManger.ContactNo = ( responseResult["ContactNo"] as! String)
            }
            else{
                if let errorMessage = result["Message"] as? String{
                    self.showErrorWith(message: errorMessage)
                    return
                }
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getSettings(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}


//MARK: -  GoogleAPI

extension DDHomeViewController{
    
    func googlePlacesAPIReverse(latnLng: String){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "latlng":latnLng,
            "sensor":"true"]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let responseArr = result ["results"] as! NSArray
            if responseArr.count > 0 {
                let value =  responseArr[0] as? NSDictionary
                if AppStateManager.sharedInstance.selectedAdd != nil {
                    AppStateManager.sharedInstance.selectedAdd.state = value!["formatted_address"] as? String
                }
                self.searchField.placeholder = value!["formatted_address"] as? String
            }
            else{
                self.searchField.placeholder = "Location Seraching"
            }
        }
        
        APIManager.sharedInstance.googlePlacesAPIReverse(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
