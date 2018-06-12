//
//  MainFilterViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Realm

class MainFilterViewController: BaseController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var menuButtonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuButtons: FilterMenuStrip!
    @IBOutlet weak var mainStripHeight: NSLayoutConstraint!
    @IBOutlet weak var mainStrip: WineFilterSort!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var mainView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: - Varaiables
    
    var realm: Realm!
    var filterRowHeight : Int!
    var filterCheck : Bool!
    var selectedIndex : Int!
    var lastSelectedIndex : Int!
    var viewCheck : Bool!
    var filterViewCheck: Bool!
    var currentText : String!
    var estDeliverTimeCell: DDMainFilterTableViewCell!
    var minDeliveryCell: DDMainFilterTableViewCell!
    var speicalOffer: Bool = false
    var freeDelivery: Bool = false
    var newRestaurant: Bool = false
    var cuisineArray = [Cuisine] ()
    var selectedCuisineArray = [String]()
    var sortBy: Int = -1
    var sendPrice = ""
    var sendCuisine = ""
    var minDelivryTime : Int = 0
    var minDelivryCharge : Double = 0
    var sendLat: Double = 0
    var sendLong: Double = 0
    var filterArray = [FilterItem]()
    var categoryName: String!
    var isRefreshEnable: Bool = false
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (filterViewCheck){
            self.menuButtons.isHidden = true
            self.menuButtonsHeightConstraint.constant = 0
        }
        else{
            self.menuButtons.isHidden = false
            self.menuButtonsHeightConstraint.constant = 40
            getCuisine()
        }
        viewSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewCheck = true
        setNavigationRightItems()
        filterRowHeight = 0
        filterCheck = false
        hideTabBarAnimated(hide: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if (viewCheck){
            viewCheck = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: - Helping Method
    
    func viewSetUp() {
        self.selection(menuButtons.mFilter)
        self.title = "Filter"
        self.addBackButtonToNavigationBar()
        lastSelectedIndex = 0
        selectedIndex = 0
        if AppStateManager.sharedInstance.filterObj == nil {
            currentText = "Distance"
        }
        else{
            currentText = AppStateManager.sharedInstance.filterObj.sortByString
        }
        self.registerNot()
        setCordinates()
    }
    
    
    func setCordinates(){
        if AppStateManager.sharedInstance.selectedAdd != nil{
            sendLat = AppStateManager.sharedInstance.selectedAdd.lat as! Double
            sendLong = AppStateManager.sharedInstance.selectedAdd.lng as! Double
        }
        else {
            sendLat = AppStateManager.sharedInstance.latitude
            sendLong = AppStateManager.sharedInstance.longitude
        }
    }
    
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "refresh_button"), style: .plain, target: self, action: #selector(refresh))
        let filterItem = UIBarButtonItem(image: #imageLiteral(resourceName: "tick_icon"), style: .plain, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItems = [filterItem, cartItem]
    }
    
    func refresh(){
        AppStateManager.sharedInstance.clearFilterData()
        AppStateManager.sharedInstance.forSelectedItems = [String] ()
        isRefreshEnable = true
        PriceRange.removeAll()
        self.tableView.reloadData()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCollectionViewCusine"), object: nil)
    }
    
    func done(){
        if isRefreshEnable == false {
            addData()
        }
        if sortBy == -1 && largeStarValue == 0 && sendPrice == "" && minDelivryTime == 0 && minDelivryCharge == 0.0 && speicalOffer == false && freeDelivery == false && sendCuisine == "" && newRestaurant == false {
            AppStateManager.sharedInstance.filterObj = nil
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func addData(){
        AppStateManager.sharedInstance.filterObj = FilterItem()
        sendTotalCuisine()
        getPrice()
        getStoreBy()
        getEstimatetimeValue()
        getMinDeliveryValue()
        
        AppStateManager.sharedInstance.filterObj.name = categoryName
        AppStateManager.sharedInstance.filterObj.sortByString = currentText
        AppStateManager.sharedInstance.filterObj.sortBy = sortBy
        AppStateManager.sharedInstance.filterObj.rating = largeStarValue
        AppStateManager.sharedInstance.filterObj.priceRange = sendPrice
        AppStateManager.sharedInstance.filterObj.minDeliveryTime = minDelivryTime
        AppStateManager.sharedInstance.filterObj.minDelvieryCharger = minDelivryCharge
        AppStateManager.sharedInstance.filterObj.isSpecial = speicalOffer
        AppStateManager.sharedInstance.filterObj.isFreeDelivery = freeDelivery
        AppStateManager.sharedInstance.filterObj.cuisines = sendCuisine
        AppStateManager.sharedInstance.filterObj.isNewRestaurants = newRestaurant
    }
    
    func sendTotalCuisine() {
        for pitem in selectedCuisineArray{
            sendCuisine = sendCuisine + pitem + ","
        }
        sendCuisine = String(sendCuisine.dropLast())
    }
    
    func getPrice(){
        
        for item in PriceRange{
            if item == "$"{
                sendPrice = sendPrice  + "10,"
            }
            if item == "$$"{
                sendPrice = sendPrice + "100,"
            }
            if item == "$$$"{
                sendPrice = sendPrice + "1000,"
            }
            if item == "$$$"{
                sendPrice = sendPrice  + "10000,"
            }
        }
        sendPrice = String(sendPrice.dropLast())
    }
    
    func getStoreBy(){
        switch currentText {
        case "  Distance":
            sortBy = 0
            currentText = "  Distance"
            break
        case "  Rating":
            sortBy = 1
            currentText = "  Rating"
            break
        case "  Est.Delivery time":
            sortBy = 2
            currentText = "  Est.Delivery time"
            break
        case "  Price":
            sortBy = 3
            currentText = "  Price"
            break
        case "  Min Delivery":
            sortBy = 4
            currentText = "  Min Delivery"
            break
        case "  A to Z":
            sortBy = 5
            currentText = "  A to Z"
            break
        case "  Relevence":
            sortBy = 6
            currentText = "  Relevence"
            break
        default:
            print("Not Found")
        }
    }
    
    func getEstimatetimeValue(){
        
        let estTime =  self.estDeliverTimeCell.radioButtonTwo.selectedButtons().map({$0.tag})
        if estTime.count > 0{
            if estTime[0] == 0{
                print ("<30 min")
                minDelivryTime = 30
                AppStateManager.sharedInstance.filterObj.radioButtonGroup2 = 0
            }
            else if estTime[0] == 1{
                print ("<45 min")
                minDelivryTime = 45
                AppStateManager.sharedInstance.filterObj.radioButtonGroup2 = 1
            }
            else if estTime[0] == 2 {
                print ("<60 min")
                minDelivryTime = 60
                AppStateManager.sharedInstance.filterObj.radioButtonGroup2 = 2
            }
        }
        else{
            print ("NO estimate Time selected")
        }
    }
    
    func getMinDeliveryValue(){
        let minDelivery =  self.minDeliveryCell.radioButtonOne.selectedButtons().map({$0.tag})
        
        if minDelivery.count > 0 {
            
            if minDelivery[0] == 3{
                print ("<$ 5")
                minDelivryCharge = 5.0
                AppStateManager.sharedInstance.filterObj.radioButtonGroup1 = 3
            }
            else if minDelivery[0] == 4{
                print ("<$ 10")
                minDelivryCharge = 10.0
                AppStateManager.sharedInstance.filterObj.radioButtonGroup1 = 4
            }
            else if minDelivery[0] == 5 {
                print ("<$ 15")
                minDelivryCharge = 15.0
                AppStateManager.sharedInstance.filterObj.radioButtonGroup1 = 5
            }
            else if minDelivery[0] == 6{
                print ("<$ 20")
                minDelivryCharge = 20.0
                AppStateManager.sharedInstance.filterObj.radioButtonGroup1 = 6
            }
        }
        else{
            print("No minimum Delivery Time Selected")
        }
    }
    
    func filterTapped(){
        if (self.filterCheck){
            filterRowHeight = 147
            self.filterCheck = !self.filterCheck
        }
        else{
            filterRowHeight = 0
            self.filterCheck = !self.filterCheck
        }
        self.mainView.reloadData()
    }
    
    func registerNot(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeText(_:)), name: NSNotification.Name(rawValue: "currentTitle"), object: nil)
    }
    
    func changeText(_ notification: NSNotification) {
        if let title = notification.userInfo?["text"] as? String {
            currentText = title
            tableView.reloadData()
        }
    }
    
    func specialswitchValueDidChange(_ sender: UISwitch) {
        print(sender.isOn)
        speicalOffer = sender.isOn
    }
    
    func freeswitchValueDidChange(_ sender: UISwitch) {
        print(sender.isOn)
        freeDelivery = sender.isOn
    }
    
    func newRestaurantswitchValueDidChange(_ sender: UISwitch) {
        print(sender.isOn)
        newRestaurant = sender.isOn
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainFilterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell7") as! DDMainFilterTableViewCell
            cell.filterButton.isSelected = true
            cell.filterButton.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
            cell.curTitle.text = currentText
            if (self.filterRowHeight == 0){
                cell.separatorInset.left = 0
            }
            else{
                cell.separatorInset.left = 500
            }
            return cell
        }
            
        else if(indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell8") as! DDMainFilterTableViewCell
            return cell
        }
            
        else if(indexPath.section == 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DDMainFilterTableViewCell!
            if AppStateManager.sharedInstance.filterObj != nil {
                cell?.starLargeView.starLarge(items: AppStateManager.sharedInstance.filterObj.rating)
            }
            else {
                cell?.starLargeView.starLarge(items:0)
            }
            return cell!
        }
            
        else if(indexPath.section == 3) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! DDMainFilterTableViewCell!
            
            if AppStateManager.sharedInstance.filterObj != nil {
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup2 == 0{
                    cell?.radioButtonTwo.sendActions(for: .touchUpInside)
                }
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup2 == 1{
                    cell?.fourthFivemin.sendActions(for: .touchUpInside)
                }
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup2 == 2{
                    cell?.Sixtymin.sendActions(for: .touchUpInside)
                }
            }
            else {
                cell?.radioButtonTwo.isSelected = false
                cell?.fourthFivemin.isSelected = false
                cell?.Sixtymin.isSelected = false
            }
            self.estDeliverTimeCell = cell
            return cell!
        }
            
        else if(indexPath.section == 4){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! DDMainFilterTableViewCell!
            if PriceRange.count != 0 {
                for item in PriceRange {
                    if item == "$$$$" {
                        cell?.labelFour.backgroundColor = Constants.APP_COLOR
                        cell?.labelFour.textColor = UIColor.white
                    }
                    if item == "$$$" {
                        cell?.labelThree.backgroundColor = Constants.APP_COLOR
                        cell?.labelThree.textColor = UIColor.white
                    }
                    if item == "$$" {
                        cell?.labelTwo.backgroundColor = Constants.APP_COLOR
                        cell?.labelTwo.textColor = UIColor.white
                    }
                    if item == "$" {
                        cell?.labelOne.backgroundColor = Constants.APP_COLOR
                        cell?.labelOne.textColor = UIColor.white
                    }
                }
            }
            else{
                cell?.labelOne.backgroundColor = UIColor.white
                cell?.labelOne.textColor = UIColor.lightGray
                cell?.labelOne.backgroundColor = UIColor.white
                cell?.labelOne.textColor = UIColor.lightGray
                cell?.labelTwo.backgroundColor = UIColor.white
                cell?.labelTwo.textColor = UIColor.lightGray
                cell?.labelThree.backgroundColor = UIColor.white
                cell?.labelThree.textColor = UIColor.lightGray
                cell?.labelFour.backgroundColor = UIColor.white
                cell?.labelFour.textColor = UIColor.lightGray
            }
            return cell!
        }
            
        else if(indexPath.section == 5) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! DDMainFilterTableViewCell!
            if AppStateManager.sharedInstance.filterObj != nil {
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup1 == 3{
                    cell?.radioButtonOne.sendActions(for: .touchUpInside)
                }
                
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup1 == 4{
                    cell?.tenDollar.sendActions(for: .touchUpInside)
                }
                
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup1 == 5{
                    cell?.fifteenDolar.sendActions(for: .touchUpInside)
                }
                
                if AppStateManager.sharedInstance.filterObj.radioButtonGroup1 == 6{
                    cell?.twentyDolar.sendActions(for: .touchUpInside)
                }
            }
            else{
                cell?.radioButtonOne.isSelected = false
                cell?.tenDollar.isSelected = false
                cell?.fifteenDolar.isSelected = false
                cell?.twentyDolar.isSelected = false
            }
            self.minDeliveryCell = cell
            return cell!
        }
            
        else if(indexPath.section == 6){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! DDMainFilterTableViewCell!
            cell?.specialOfferSwitch.addTarget(self, action:  #selector(specialswitchValueDidChange(_:)), for: .valueChanged)
            if AppStateManager.sharedInstance.filterObj != nil {
                cell?.specialOfferSwitch.isOn = AppStateManager.sharedInstance.filterObj.isSpecial
            }else{
                cell?.specialOfferSwitch.isOn = false
            }
            return cell!
        }
            
        else if(indexPath.section == 7){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! DDMainFilterTableViewCell!
            cell?.freeDeliverySwitch.addTarget(self, action:  #selector(freeswitchValueDidChange(_:)), for: .valueChanged)
            if AppStateManager.sharedInstance.filterObj != nil {
                cell?.freeDeliverySwitch.isOn = AppStateManager.sharedInstance.filterObj.isFreeDelivery
            }
            else {
                cell?.freeDeliverySwitch.isOn = false
            }
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell6") as! DDMainFilterTableViewCell!
            cell?.newRestaurantSwitch.addTarget(self, action:  #selector(newRestaurantswitchValueDidChange(_:)), for: .valueChanged)
            if AppStateManager.sharedInstance.filterObj != nil {
                cell?.newRestaurantSwitch.isOn = AppStateManager.sharedInstance.filterObj.isNewRestaurants
            }
            else {
                cell?.newRestaurantSwitch.isOn = false
            }
            return cell!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 0){
            return 50
        }
        else if(indexPath.section == 1){
            return CGFloat(self.filterRowHeight)
        }
        else if(indexPath.section == 2){
            return 100
        }
        else if(indexPath.section == 3){
            return 150
        }
        else if(indexPath.section == 4){
            return 150
        }
        else if(indexPath.section == 5){
            return 150
        }
        else if(indexPath.section == 6){
            return 50
        }
        else if(indexPath.section == 7){
            return 50
        }
        else{
            return 50//CGFloat(self.filterRowHeight)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


//MARK: - Menu Button

extension MainFilterViewController {
    
    @IBAction func seeAllBtnDown(_ sender: Any) {
        if mainStrip.isHidden{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.mainStripHeight.constant = 147
                self.mainStrip.isHidden = false
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                self.mainStripHeight.constant = 0
                self.mainStrip.isHidden = true
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func mFilterBtnDown(_ sender: Any){
        let btn = sender as! UIButton
        self.selection(btn)
        selectedIndex = 1
        self.scrollMoved(index: 0)
    }
    
    @IBAction func mCuisineBtnDown(_ sender: Any){
        let btn = sender as! UIButton
        self.selection(btn)
        selectedIndex = 1
        self.scrollMoved(index: 1)
    }
    
    func selection(_ btn: UIButton){
        btn.setTitleColor(Constants.APP_COLOR, for: UIControlState.normal)
    }
}


//MARK: - SetUp ScrolView

extension MainFilterViewController {
    func setUpScroll(){
        scrollView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        let mainView = FilterCuisineView()
        AppStateManager.sharedInstance.cuisineObj = cuisineArray
        mainView.delegate = self
        mainView.frame = CGRect(x:  UIScreen.main.bounds.size.width, y: 0.0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.addSubview(mainView)
        scrollView.contentSize = CGSize(width: 2 * UIScreen.main.bounds.size.width, height: scrollView.contentSize.height)
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
        default:
            break;
        }
    }
}


//MARK: - FilterCuisineViewDelegate

extension MainFilterViewController: FilterCuisineViewDelegate {
    func refreshView() {
        getCuisine()
    }
    
    func sendSelectedCuisine(_ value: [String]) {
        selectedCuisineArray = value
    }
}


//MARK: - Web Service

extension MainFilterViewController {
    
    func getCuisine(){
        self.startLoading()
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [:]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                if self.cuisineArray.count != 0{
                    self.cuisineArray.removeAll()
                }
                let responseResult = result["Result"] as! NSDictionary
                let cuisineData = responseResult["cuisines"] as! NSArray
                print(cuisineData)
                for item in cuisineData{
                    let cuisineDetail = item as! NSDictionary
                    let cuisineObj = Cuisine(value:cuisineDetail)
                    self.cuisineArray.append(cuisineObj)
                }
                self.setUpScroll()
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.getCuisine(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}
