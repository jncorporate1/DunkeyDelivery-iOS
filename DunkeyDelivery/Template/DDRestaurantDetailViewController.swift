//
//  DDRestaurantDetailViewController.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import NYAlertViewController
import FSCalendar
import SDWebImage
import Alamofire
import DZNEmptyDataSet

class DDRestaurantDetailViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tag5: UILabel!
    @IBOutlet weak var tag4: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var displacement: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var minOrderFee: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var starView: DDStarView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var foodSectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var foodSectionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryBottomLine: UIView!
    @IBOutlet weak var categoriesLabelOutlet: UILabel!
    
    
    //MARK: - Variable
    
    var categoryDetailArr = [CategoryDetail]()
    var categorySubCat = [CategoryDetail]()
    var storeData : StoreItem!
    var subCatIndex = -1
    var selectedCount = 0
    var selectionArr = [Int]()
    var totalRecords = Int()
    var menuItems = ["Snacks and Chocolates","Biscuits","Chips","Starters","Pizza","Chicky Meal","Chicken","Snacks & Beverages","Soft Drinks","Hard Drinks"]
    var searchField: UITextField = UITextField()
    var viewSring : String!
    var calendar: FSCalendar!
    var selectedDate : String!
    var selectedTime : String!
    var viewCheck : Bool!
    var isDetailing : Bool!
    var sectionCellCheck = false
    var pageNum = 1
    var laundryCategories = [Laundry]()
    var laundryProduct = [ProductItem]()
    var tappedButton = ""
    var sendTime = ""
    var sendDate = ""
    var sendLaundryProduct: Laundry!
    var laundryProductNameArray = [String] ()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCheck = true
        isDetailing = false
        setUpData()
        self.addBackButtonToNavigationBar()
        setMiddleSearchBar()
        //self.tableView.tableFooterView = UIView()
        self.catHomeService()
        setUpDelegates()
        selectedDate =  getCurretnDate()
        selectedTime =  getCurrentTime()
        tableView.tableFooterView = UIView()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.homeNavigationBar()
        self.navigationController?.navigationBar.isHidden = false
        self.setUpView()
        getLaundryCategory()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let userDefaults = UserDefaults.standard
        userDefaults.set(self.selectionArr, forKey: "selectionArr")
    }
    
    //MARK: - Helping Method
    
    func setUpDelegates(){
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
    }
    
    func catHomeService(){
        self.startLoading()
        self.categoryDetailService(pageNo: 0)
    }
    
    func setUpData(){
        if storeData != nil{
            var tags = [String]()
            for tag in storeData.storeTags{
                tags.append(tag.Tag)
            }
            self.addTags(tagArr: tags)
        }
        self.address.text = storeData.Address
        self.companyName.text = storeData.BusinessName
        self.starView.setWhite(items: Int(storeData.AverageRating))
        if storeData.MinDeliveryCharges.value != nil{
            self.deliveryFee.text  = "$\(storeData.MinDeliveryCharges.value!)"}
        if storeData.MinOrderPrice.value != nil{
            self.minOrderFee.text = "$\(storeData.MinOrderPrice.value!)"}
        if storeData.MinDeliveryTime.value != nil{
            self.deliveryTime.text = "\(storeData.MinDeliveryTime.value!) min"}
        self.displacement.text = "\(storeData.Distance) m"
    }
    
    func addTags(tagArr: [String]){
        switch tagArr.count {
        case 0:
            tag1.isHidden = true
            tag2.isHidden = true
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 1:
            tag1.text = "   \(tagArr[0])   "
            tag2.isHidden = true
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 2:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.isHidden = true
            tag4.isHidden = true
            tag5.isHidden = true
        case 3:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.isHidden = true
            tag5.isHidden = true
        case 4:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.text = "   \(tagArr[3])   "
            tag5.isHidden = true
        case 5:
            tag1.text = "   \(tagArr[0])   "
            tag2.text = "   \(tagArr[1])   "
            tag3.text = "   \(tagArr[2])   "
            tag4.text = "   \(tagArr[3])   "
            tag5.text = "   \(tagArr[4])   "
        default:
            break
        }
    }
    
    func setUpView(){
        if self.viewSring == "Laundry"{
            self.foodSectionView.isHidden = true
            updateConstraint(value: 0)
            self.topImageView.image = #imageLiteral(resourceName: "laundry_bg")
            viewCheck = false
            hideTabBarAnimated(hide:true)
            self.tableView.reloadData()
            //tableView.tableFooterView = UIView()
        }
        else{
            viewCheck = true
            hideTabBarAnimated(hide:false)
        }
    }
    
    func updateConstraint(value: Int){
        self.foodSectionViewHeight.constant = CGFloat(value)
        self.categoriesLabelOutlet.isHidden = true
        self.categoryBottomLine.isHidden = true
        self.foodSectionView.layoutIfNeeded()
    }
    
    // Navigation
    func laundrySubmitButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCurretnDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    func getCurrentTime() -> String{
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    
    // Search
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
    
    func washFoldButtonTapped(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDWashFoldViewController") as! DDWashFoldViewController
        tappedButton = "wash & fold"
        tappedButton = tappedButton.lowercased()
        sendProductCategory(tappedButton)
        tappedButton = "wash and fold"
        tappedButton = tappedButton.lowercased()
        sendProductCategory(tappedButton)
        if sendLaundryProduct != nil {
            vc.dateNtime = sendDate + sendTime
            vc.laundry = sendLaundryProduct
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            
        }
    }
    func dryCleanerButtonTapped(){
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DCMainViewController")
            as! DCMainViewController
        tappedButton = "dry cleaning"
        tappedButton = tappedButton.lowercased()
        sendProductCategory(tappedButton)
        if sendLaundryProduct != nil {
            let assignedDate = getSelectedTimeInterval()
            let  sendDate1 = setDate(dateValue: assignedDate)
            let  sendTime1 = selectedTime
            controller.selectedDate = sendDate1
            controller.seletedTime = sendTime1!
            controller.dateNtime = sendDate + sendTime
            controller.laundry = sendLaundryProduct
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tailoringButtonTapped(){
        let storyboard = UIStoryboard(name: "WineDetail", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TailoringViewController") as! TailoringViewController
        tappedButton = "tailoring"
        tappedButton = tappedButton.lowercased()
        sendProductCategory(tappedButton)
        if sendLaundryProduct != nil {
            let assignedDate = getSelectedTimeInterval()
            let  sendDate1 = setDate(dateValue: assignedDate)
            let  sendTime1 = selectedTime
            controller.selectedDate = sendDate1
            controller.seletedTime = sendTime1!
            controller.laundry = sendLaundryProduct
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func locationSearchTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        controller.arrayCount = 0
        controller.viewCheck = true
        controller.proStoreId = "\(storeData.Id)"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func moveToNextView(cat: CategoryDetail){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDRestaurantSubDetailViewController") as! DDRestaurantSubDetailViewController
        vc.catDetail = cat
        vc.storeData = storeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendProductCategory(_ value: String)  {
        for item in self.laundryCategories{
            let name = (item.Name)?.lowercased()
            if name == value {
                sendLaundryProduct = item
            }
                //Donot need this condition Becuz there is no type for shirts and pants
                //Server side wrong item insert
            else {
                
            }
        }
    }
    
    func getSelectedTimeInterval() -> Date{
        
        let timeIntervalStr = selectedDate + ", " + selectedTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, hh:mm a" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        return dateFormatter.date(from: timeIntervalStr)!
    }
    
    
    func setDate(dateValue: Date)-> String{
        let formater2 = DateFormatter()
        formater2.dateFormat = "yyyy-MM-dd"
        let result2 = formater2.string(from: dateValue)
        return result2
    }
    
    //MARK: - Action
    
    @IBAction func cartTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func aboutButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.viewCheck = true
        vc.storeData = self.storeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func reviewButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDDetailViewController") as! DDDetailViewController
        vc.storeData = self.storeData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDSearchViewController") as! DDSearchViewController
        vc.viewCheck = true
        vc.proStoreId = (storeData.Id).description
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension DDRestaurantDetailViewController: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension DDRestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.viewCheck){
            return self.categoryDetailArr.count
        }
        else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.viewCheck){
            if self.selectionArr.contains(section){
                return self.categoryDetailArr[section].SubCategories.count + 1
            }
            else{
                return 1
            }
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.viewCheck){
            var cell : DDDetailTableViewCell!
            if self.selectionArr.contains(indexPath.section)
            {
                let itemCat = self.categoryDetailArr[indexPath.section]
                
                if indexPath.row == 0{
                    cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DDDetailTableViewCell
                    cell.menuItem.text = itemCat.Name
                    cell.arrowImage.image = UIImage(named: "arrow_right.png")
                    cell.selectionStyle = .none
                }
                else{
                    let index = indexPath.row - 1
                    let itemSub = self.categoryDetailArr[indexPath.section].SubCategories[index]
                    cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! DDDetailTableViewCell
                    cell.detailedItem.text = itemSub.Name
                    cell.selectionStyle = .none
                }
            }
            else
            {
                let itemCat = self.categoryDetailArr[indexPath.section]
                cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DDDetailTableViewCell
                cell.menuItem.text = itemCat.Name
                cell.arrowImage.image = UIImage(named: "arrow_right.png")
                cell.selectionStyle = .none
            }
            cell.separatorInset.left = 0
            self.tableView.separatorStyle = .singleLine
            return cell
        }
        else {
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "laundryCell", for: indexPath) as! DDLaundryTableViewCell
                self.tableView.separatorStyle = .singleLine
                cell.washFoldButton.addTarget(self, action: #selector(washFoldButtonTapped), for: .touchUpInside)
                cell.dryCleanerButton.addTarget(self, action: #selector(dryCleanerButtonTapped), for: .touchUpInside)
                cell.tailoringButton.addTarget(self, action: #selector(tailoringButtonTapped), for: .touchUpInside)
                cell.selectionStyle = .none
                
                cell.washNfoldView.isHidden = true
                cell.washNfoldViewWidth.constant = 0
                cell.dryCleanView.isHidden = true
                cell.dryCleanViewWidth.constant = 0
                cell.tailoringView.isHidden = true
                cell.tailoringViewWidth.constant = 0
                
                for itemName in laundryProductNameArray {
                    var name = itemName.lowercased()
                    name = name.removingWhitespaces()
                    switch(itemName.lowercased()){
                    case "wash & fold":
                        cell.washNfoldView.isHidden = false
                        cell.washNfoldViewWidth.constant = 116
                        break
                    case "wash and fold":
                        cell.washNfoldView.isHidden = false
                        cell.washNfoldViewWidth.constant = 116
                        break
                    case "dry cleaning":
                        cell.dryCleanView.isHidden = false
                        cell.dryCleanViewWidth.constant = 116
                        break
                    case "tailoring":
                        cell.tailoringView.isHidden = false
                        cell.tailoringViewWidth.constant = 116
                        break
                    case " tailoring":
                        cell.tailoringView.isHidden = false
                        cell.tailoringViewWidth.constant = 116
                        break
                    default:
                        print("no element found")
                    }
                    cell.layoutIfNeeded()
                }
                
                return cell
            }
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "laundryDateCell", for: indexPath) as! DDLaundryTableViewCell
                if self.selectedDate != nil{
                    //set selected date
                    cell.dateLabel.text = self.selectedDate
                }
                else{
                    //set nil
                    cell.dateLabel.text = self.getCurretnDate()
                }
                sendDate = cell.dateLabel.text!
                cell.selectionStyle = .none
                self.tableView.separatorStyle = .singleLine
                return cell
            }
            else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "laundryTimeCell", for: indexPath) as! DDLaundryTableViewCell
                if self.selectedTime != nil{
                    cell.timeLabel.text = self.selectedTime
                }
                else{
                    cell.timeLabel.text = self.getCurrentTime()
                }
                sendTime =  cell.timeLabel.text!
                cell.selectionStyle = .none
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "laundryButtonCell", for: indexPath) as! DDLaundryTableViewCell
                // cell.laundrySubmitButton.addTarget(self, action: #selector(laundrySubmitButtonTapped), for: .touchUpInside)
                cell.laundrySubmitButton.isHidden = true
                cell.selectionStyle = .none
                self.tableView.separatorStyle = .singleLine
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.viewCheck){
            return 60.0
        }
        else{
            if indexPath.section == 0{
                if laundryProductNameArray.count > 0{
                    return 189
                }
                else{
                    return 0
                }
                
            }
            else{
                return 82
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.viewCheck){
            
            let item = self.categoryDetailArr[indexPath.section]
            if item.SubCategories.count != 0{
                if self.selectionArr.contains(indexPath.section){
                    let indexOfSelection = self.selectionArr.index(of: indexPath.section)
                    self.selectionArr.remove(at: indexOfSelection!)
                    if indexPath.row == 0{
                        self.tableView.reloadData()
                    }
                    else{
                        self.moveToNextView(cat: self.categoryDetailArr[indexPath.section].SubCategories[indexPath.row - 1])
                    }
                }
                else{
                    self.selectionArr.append(indexPath.section)
                    tableView.reloadData()
                }
            }
            else{
                self.moveToNextView(cat: item)
                //doesnot have any sub categories
            }
        }
        else{
            if indexPath.section == 1{
                //select Date
                self.selectDate()
            }
            else if indexPath.section == 2{
                //select time
                self.selectTime()
            }
        }
    }
}


// MARK: - Time and Date

extension DDRestaurantDetailViewController: FSCalendarDelegate, FSCalendarDataSource {
    func selectTime(){
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.tintColor = Constants.APP_COLOR
        timePicker.setValue(Constants.APP_COLOR, forKey: "textColor")
        let alertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertViewController.transitionStyle = .fade
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(_ action) in
            self.dismiss(animated: true, completion: { _ in })
        }))
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive, handler: {(_ action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            var timeStr = ""
            timeStr = dateFormatter.string(from: timePicker.date)
            self.selectedTime = timeStr
            self.dismiss(animated: true, completion: { _ in })
            self.tableView.reloadData()
        }))
        alertViewController.alertViewBackgroundColor = UIColor.white
        alertViewController.cancelButtonTitleColor = UIColor.gray
        alertViewController.cancelButtonColor = UIColor.white
        alertViewController.destructiveButtonColor = UIColor.white
        alertViewController.destructiveButtonTitleColor = Constants.APP_COLOR
        alertViewController.title = NSLocalizedString("Select Time", comment: "")
        alertViewController.message = NSLocalizedString("", comment: "")
        let contentView = UIView(frame: CGRect.zero)
        contentView.addSubview(timePicker)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[calendar(300)]|", options: [], metrics: nil, views: ["calendar": timePicker]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[calendar]-|", options: [], metrics: nil, views:  ["calendar": timePicker]))
        alertViewController.alertViewContentView = contentView
        present(alertViewController, animated: true, completion: { _ in })
        
    }
    func selectDate(){
        let alertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertViewController.transitionStyle = .fade
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(_ action) in
            self.dismiss(animated: true, completion: { _ in })
        }))
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive, handler: {(_ action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            var dateStr = ""
            if self.calendar.selectedDate == nil {
                dateStr = dateFormatter.string(from: Date())
            } else {
                dateStr = dateFormatter.string(from: self.calendar.selectedDate!)
            }
            self.selectedDate = dateStr
            self.dismiss(animated: true, completion: { _ in })
            self.tableView.reloadData()
        }))
        alertViewController.alertViewBackgroundColor = UIColor.white
        alertViewController.cancelButtonTitleColor = UIColor.gray
        alertViewController.cancelButtonColor = UIColor.white
        alertViewController.destructiveButtonColor = UIColor.white
        alertViewController.destructiveButtonTitleColor = Constants.APP_COLOR
        alertViewController.title = NSLocalizedString("Select Date", comment: "")
        alertViewController.message = NSLocalizedString("", comment: "")
        let contentView = UIView(frame: CGRect.zero)
        self.calendar = FSCalendar(frame: CGRect.zero)
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        
        let vc = UIViewController()
        vc.view.addSubview(calendar)
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.calendar.backgroundColor = UIColor.white
        self.calendar.appearance.headerTitleColor = Constants.APP_COLOR
        self.calendar.appearance.subtitleWeekendColor = Constants.APP_COLOR
        self.calendar.appearance.selectionColor = Constants.APP_COLOR
        self.calendar.appearance.weekdayTextColor = UIColor.black
        self.calendar.appearance.todayColor = UIColor.clear
        self.calendar.appearance.titleTodayColor = UIColor.black
        self.calendar.select(Date())
        
        
        contentView.addSubview(self.calendar)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[calendar(300)]|", options: [], metrics: nil, views: ["calendar": self.calendar]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[calendar]-|", options: [], metrics: nil, views:  ["calendar": self.calendar]))
        alertViewController.alertViewContentView = contentView
        present(alertViewController, animated: true, completion: { _ in })
        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        print(calendar.selectedDate!)
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        //self.calendar.appearance.selectionColor = UIColor.white
        return true
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
}

// MARK: - UIScrollViewDelegate

extension DDRestaurantDetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //        code
        if (self.viewCheck){
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
            if (bottomEdge >= scrollView.contentSize.height) {
                self.startLoading()
                self.categoryDetailService(pageNo: pageNum)
                pageNum = pageNum + 1
            }
        }
    }
}

//MARK: - Web Service

extension DDRestaurantDetailViewController{
    
    func categoryDetailService(pageNo: Int){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        let parameters: Parameters = [
            
            "store_id":"\(self.storeData.Id)",
            "page_no":"\(pageNo)",
            "num_items":"10"]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                let responseResult = result["Result"] as! NSDictionary
                let categories = responseResult["ParentCategories"] as! NSArray
                let deliverytypeArray = responseResult["DeliveryTypes"] as! NSArray
                let appManger = AppStateManager.sharedInstance
               
                if appManger.deliveryTypes.count != 0 {
                    appManger.deliveryTypes.removeAll()
                }
                
                for ditem in deliverytypeArray{
                    let items = DeliverySchedule(value: ditem as! NSDictionary)
                    appManger.deliveryTypes.append(items)
                }
                
                for category in categories{
                    let catDic = CategoryDetail(value: category as! NSDictionary)
                    self.categoryDetailArr.append(catDic)
                }
                if self.categoryDetailArr.count != 0{
                    self.foodSectionView.isHidden = false
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
        APIManager.sharedInstance.getCategoryDetail(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    func getLaundryCategory(){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "Store_id":storeData.Id.description,
            "Page":"0",
            "Items":"0"
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                
                if self.laundryCategories.count != 0 {
                    self.laundryCategories.removeAll()
                    self.laundryProductNameArray.removeAll()
                }
                
                let responceResult = result["Result"] as! NSDictionary
                let laundryItem = responceResult["Categories"] as! NSArray
                
                for item in laundryItem {
                    let value = item as! NSDictionary
                    let valueAdd = Laundry(value:value)
                    self.laundryCategories.append(valueAdd)
                    self.laundryProductNameArray.append(valueAdd.Name!)
                }
                self.tableView.reloadData()
            }
        }
        APIManager.sharedInstance.getLaundryParentCategory(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}

//MARK: - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDRestaurantDetailViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "No categories are currently available."//"Cart is empty."
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
