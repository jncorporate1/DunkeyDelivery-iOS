//
//  DDProductViewController.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Hero
import FSCalendar
import NYAlertViewController

class DDProductViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var product = ProductItem()
    var quantityValue : Int! = 0
    var quantityCheck : Bool = false
    var isViewDealnPromotion: Bool = false
    var packageProduct = [PackageProduct]()
    var packageCountFour = [PackageProduct]()
    var countArray : Bool = false
    var isSeeMoreEnable : Bool = false
    var calendar: FSCalendar!
    var selectedDate : String!
    var selectedTime : String!
    var sort = SetDeliveryTimePopUp()
    var scheduleDate = Date()
    var maxDate = [Date] ()
    var storeData : StoreItem!
    var objDeliverySchedule = DeliverySchedule()
    var arrDeliverySchedule = [DeliverySchedule]()
    var todayDay:String = ""
    var todayTime:String = ""
    var cartObj: Cart! = Cart()
    var showPopUp: Bool!
    var setdatetoShow: String = ""
    var setTimeToShow: String = ""
    var ifScheduleSelected: Bool = false
    
    
    //MARK: -  View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideTabBarAnimated(hide: true)
        setUpPackageData()
        if isViewDealnPromotion != true {
            let schCalendar = Calendar.Component.day.self
            maxDate = self.generateDates(startDate: scheduleDate, addbyUnit: schCalendar, value: 4)
            arrDeliverySchedule = AppStateManager.sharedInstance.deliveryTypes
            self.asapButtonTapped(0)
            self.assignTimeAtStart()
            self.assignDateFirstTime()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.homeNavigationBar()
        quantityCheck = true
        tableView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
        self.addBackButtonToNavigationBar()
        self.title = product.Name
        setNavigationRightItems()
    }
    
    
    //MARK: - Helping Method
    
    func setUpPackageData(){
        packageCountFour = [PackageProduct]()
        
        if packageProduct.count > 4 {
            let items = packageProduct[0..<4]
            if packageCountFour.count != 0{
                packageCountFour.removeAll()
            }
            for item in items{
                packageCountFour.append(item)
                print(" - > add on packageCountFour greater \(item.Id)")
            }
            countArray = true
        }
        else{
            if packageCountFour.count != 0{
                packageCountFour.removeAll()
            }
            for item in packageProduct{
                packageCountFour.append(item)
                print(" - > add on packageCountFour less \(item.Id)")
            }
            countArray = false
        }
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
    
    func addToBagButtonTapped(sender: UIButton){
        if quantityValue == 0{
            self.showErrorWith(message: "Please set quantity")
            return
        }
        
        if isViewDealnPromotion == false{ // deal & Promotion check
            
            if (AppStateManager.sharedInstance.isStoreExsists(storeId: storeData.Id)){ // if store is already exist delivery schedule popUP can't show
                if arrDeliverySchedule.count > 0 { // if there is no delivery schecdule in store by default ASAP will be send to the service
                for item in arrDeliverySchedule{
                    if item.Type_Id == 0{
                        sort.asapButtonOutlet.isHidden = false
                    }
                    if item.Type_Id == 1{
                        sort.todayButtonOutlet.isHidden = false
                    }
                    if item.Type_Id == 2{
                        sort.laterButtonOutlet.isHidden = false
                    }
                }
                sort.buttonView.layoutIfNeeded()
                sort.delegate = self
                sort.frame = self.view.frame
                self.view.addSubview(sort)
                todayDay = self.setDate(dateValue: scheduleDate)
                self.setTimePicker(0.0)
                } // arrDeliverySchedule count > 0
                else{
                    objDeliverySchedule.Store_Id = product.Store_id
                    objDeliverySchedule.Type_Id = 0
                    objDeliverySchedule.Type_Name = "ASAP"
                    todayTime = Utility.getCurrentTime()
                    todayDay = Utility.getCurretnDate()
                    self.submitButtonTapped()
                }
            }//if store is already exist delivery schedule
            else{
                self.submitButtonTapped()
            }
        }// deal & Promotion check
        else{
            self.submitButtonTapped()
        }
    }
    
    func setTimePicker(_ value: Float){
        let date2 = scheduleDate.addingTimeInterval(TimeInterval(value * 60.0))
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm a"
        formatter1.amSymbol = "AM"
        formatter1.pmSymbol = "PM"
        let timeResult = formatter1.string(from: date2)
        self.sort.showTimeText.text =  "\(timeResult)"
        todayTime = "\(timeResult)"
    }
    
    
    func setTime(_ value: Float){
        let selectedTimeInterval = getSelectedTimeInterval()
        let date2 = selectedTimeInterval.addingTimeInterval(TimeInterval(value * 60.0))
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm a"
        formatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let timeResult = formatter1.string(from: date2)
        self.sort.showTimeText.text =  "\(timeResult)"
        todayTime = "\(timeResult)"
    }
    
    func getSelectedTimeInterval() -> Date{
        let timeIntervalStr = selectedDate + ", " + selectedTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy, hh:mm a"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") 
        return dateFormatter.date(from: timeIntervalStr)!
    }
    
    func setDate(dateValue: Date)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd LLLL yyyy"
        let result = formatter.string(from: dateValue)
        self.sort.showDateText.text = result
        setdatetoShow = result
        let formater2 = DateFormatter()
        formater2.dateFormat = "yyyy-MM-dd"
        let result2 = formater2.string(from: dateValue)
        return result2
    }
    
    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date] {
        var dates = [Date]()
        var date = startDate!
        let endDate = Calendar.current.date(byAdding: addbyUnit, value: value, to: date)!
        while date < endDate {
            date = Calendar.current.date(byAdding: addbyUnit, value: 1, to: date)!
            dates.append(date)
        }
        return dates
    }
    
    
    
    func didTapOnSeeMore(){
        if isSeeMoreEnable == false {
            if packageCountFour.count != 0{
                packageCountFour.removeAll()
            }
            for item in packageProduct{
                packageCountFour.append(item)
            }
            isSeeMoreEnable = true
            self.tableView.reloadData()
        }
        else{
            setUpPackageData()
            isSeeMoreEnable = false
            self.tableView.reloadData()
        }
    }
}



//MARK: -  UITableViewDataSource, UITableViewDelegate

extension DDProductViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isViewDealnPromotion == true{
            return 10
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isViewDealnPromotion == true{
            if section == 4{
                if packageProduct.count > 4 {
                    print("- > packageCountFour ")
                    return packageCountFour.count
                }
                else{
                    print("- > packageProduct ")
                    return packageProduct.count
                }
            }
        }
        else{
            return 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //// IF  deal and promotion View
        
        if isViewDealnPromotion == true{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                let url = product.Image?.getURL()
                if url != nil {
                    cell.productImage.contentMode = .scaleAspectFill
                }
                else{
                    cell.productImage.contentMode = .scaleAspectFit
                    
                }
                cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                return cell
            }
                
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell", for: indexPath) as! DDProductTableViewCell
                cell.productName.text = self.product.Name
                cell.productDetail.text = self.product.Description
                cell.selectionStyle = .none
                return cell
            }
    
            else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "storeHeader", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.storeName.text = self.product.BusinessName
                return cell
            }
            else if indexPath.section == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "productHeader", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0.0 , cell.bounds.size.width , 0.0, -cell.bounds.size.width)
                
                return cell
            }
                
            else if indexPath.section == 4{
                let cell = tableView.dequeueReusableCell(withIdentifier: "storeProductDetail", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0.0 , cell.bounds.size.width , 0.0, -cell.bounds.size.width)
                let packageItem = packageProduct[indexPath.row]
                cell.storeProductName.text = packageItem.Product?.Name
                cell.quantity.text =  packageItem.Qty!
                cell.quantity.layer.cornerRadius = 12
                cell.quantity.textAlignment = .center
                cell.quantity.layer.masksToBounds = true
                cell.quantity.backgroundColor = Constants.APP_COLOR
                return cell
            }
                
            else if indexPath.section == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "seeMore", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0.0 , cell.bounds.size.width , 0.0, -cell.bounds.size.width)
                
                if  isSeeMoreEnable == true {
                    cell.seeMoreButtonOutlet.addTarget(self, action: #selector(didTapOnSeeMore), for: .touchUpInside)
                    cell.seeMoreButtonOutlet.setTitle(" See Less", for: .normal)
                }
                else{
                    cell.seeMoreButtonOutlet.addTarget(self, action: #selector(didTapOnSeeMore), for: .touchUpInside)
                    cell.seeMoreButtonOutlet.setTitle(" See More", for: .normal)
                }
                return cell
            }
                
            else if indexPath.section == 6{
                let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.priceLabel.text = "$"+(self.product.Price.value!).description
                cell.priceViewHide.isHidden = false
                return cell
            }
            else if indexPath.section == 7{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityCell", for: indexPath) as! DDProductTableViewCell
                cell.viewEssentials()
                if (quantityCheck){
                    cell.resetQuantity()
                    quantityCheck = false
                }
                cell.delegate = self
                cell.quantityStepper.buttonsFont = UIFont(name: "Montserrat-Regular", size: 11.0)!
                cell.quantityStepper.labelFont = UIFont(name: "Montserrat-Regular", size: 11.0)!
                cell.selectionStyle = .none
                
                return cell
            }
            else if indexPath.section == 8{
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! DDProductTableViewCell
                let quant = Double(quantityValue)
                let totalPrice = quant * Double (self.product.Price.value!)
                cell.totalCost.text = "$"+"\(totalPrice)"
                cell.selectionStyle = .none
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addToBagCell", for: indexPath) as! DDProductTableViewCell
                cell.setUpTextView()
                cell.selectionStyle = .none
                cell.addToBagButton.addTarget(self, action: #selector(self.addToBagButtonTapped(sender:)), for: .touchUpInside)
                return cell
            }
            
        }// IF (end) deal and promotion View
            
        else{
            
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "pictureCell", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                let url = product.Image?.getURL()
                if url != nil {
                    cell.productImage.contentMode = .scaleAspectFill
                }
                else{
                    cell.productImage.contentMode = .scaleAspectFit
                }
                cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                return cell
            }
            else if indexPath.section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "productDetailCell", for: indexPath) as! DDProductTableViewCell
                cell.productName.text = self.product.Name
                cell.productDetail.text = self.product.Description
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! DDProductTableViewCell
                cell.selectionStyle = .none
                cell.priceViewHide.isHidden = true
                cell.priceLabel.text = "$"+(self.product.Price.value!).description
                return cell
            }
                
            else if indexPath.section == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuantityCell", for: indexPath) as! DDProductTableViewCell
                cell.viewEssentials()
                if (quantityCheck){
                    cell.resetQuantity()
                    quantityCheck = false
                }
                cell.delegate = self
                cell.quantityStepper.buttonsFont = UIFont(name: "Montserrat-Regular", size: 11.0)!
                cell.quantityStepper.labelFont = UIFont(name: "Montserrat-Regular", size: 11.0)!
                
                cell.selectionStyle = .none
                return cell
            }
            else if indexPath.section == 4{
                let cell = tableView.dequeueReusableCell(withIdentifier: "totalCell", for: indexPath) as! DDProductTableViewCell
                let quant = Double(quantityValue)
                let totalPrice = quant * Double (self.product.Price.value!)
                cell.totalCost.text = "$"+"\(totalPrice)"
                cell.selectionStyle = .none
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addToBagCell", for: indexPath) as! DDProductTableViewCell
                cell.setUpTextView()
                cell.selectionStyle = .none
                cell.addToBagButton.addTarget(self, action: #selector(self.addToBagButtonTapped(sender:)), for: .touchUpInside)
                return cell
            }
            
        }
    }// cellForRowAt
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isViewDealnPromotion == true{
            if indexPath.section == 0{
                return 180
            }
            else if indexPath.section == 1{
                return 100
            }
                
            else if indexPath.section == 2{
                return 65
            }
            else if indexPath.section == 3{
                return 35
            }
            else if indexPath.section == 4{
                return 40
            }
            else if indexPath.section == 5{
                if countArray == true{
                    print("- > countArray 60")
                    return 60
                }
                else{
                    if packageProduct.count > 4 {
                        print("- > packageCountFour ")
                        return 60
                    }
                    else{
                        print("- > packageProduct ")
                        return 0
                    }
                }
            }
            else if indexPath.section == 6{
                return 55
            }
            else if indexPath.section == 7{
                return 80
            }
            else if indexPath.section == 8{
                return 55
            }
            else{
                return 220
            }
        }// IF (end) deal and promotion View
            
        else{
            if indexPath.section == 0{
                return 180
            }
            else if indexPath.section == 1{
                return 100
            }
            else if indexPath.section == 2{
                return 55
            }
            else if indexPath.section == 3{
                return 80
            }
            else if indexPath.section == 4{
                return 55
            }
            else{
                return 220
            }
        }
    } // heightForRowAt
    
} // UITableViewDataSource, UITableViewDelegate




//MARK: - DDProductCellDelegate

extension DDProductViewController: DDProductCellDelegate{
    func stepperValueUpdate(value: Int) {
        print(value)
        quantityValue = value
        self.product.quantity = value
        self.tableView.reloadData()
    }
}


// MARK: - FSCalendarDelegate, FSCalendarDataSource

extension DDProductViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    func assignDateFirstTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        selectedTime = dateFormatter.string(from: Date())
    }
    
    func assignTimeAtStart(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        selectedDate = dateFormatter.string(from: Date())
    }
    
    func selectTime(){
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.tintColor = Constants.APP_COLOR
        timePicker.setValue(Constants.APP_COLOR, forKey: "textColor")
        let alertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertViewController.transitionStyle = .fade
        var startHour: Int = 0
        var endHour: Int = 0
        if storeData.Open_To != nil && storeData.Open_From != nil {
            
            let toconvertinto12 = Utility.convertssTimeIn12(value:storeData.Open_To!)
            let fromconvertinto12 = Utility.convertssTimeIn12(value:storeData.Open_From!)
            let openTo = toconvertinto12
            let openFrom = fromconvertinto12
            var temp  = openTo.characters.map{String($0)}
            let ftime = temp[0] + temp[1]
            startHour = Int(ftime)!
            var temp1  = openFrom.characters.map{String($0)}
            let ltime = temp1[0] + temp1[1]
            endHour = Int(ltime)!
        }
        else{
            startHour = 0
            endHour = 0
        }
        let date1 = Date()
        let gregorian: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components: DateComponents? = gregorian.components(NSCalendar.Unit(rawValue: UInt(NSIntegerMax)), from: date1)
        components?.hour = startHour
        components?.minute = 0
        components?.second = 0
        let startDate: Date? = gregorian.date(from: components!)
        components?.hour = endHour
        components?.minute = 0
        components?.second = 0
        let endDate: Date? = gregorian.date(from: components!)
        timePicker.datePickerMode = .time
        timePicker.minimumDate = startDate
        timePicker.maximumDate = endDate
        if let aDate = startDate {
            timePicker.setDate(aDate, animated: true)
        }
        timePicker.reloadInputViews()
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(_ action) in
            self.dismiss(animated: true, completion: { _ in })
        }))
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive, handler: {(_ action) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            var timeStr = ""
            timeStr = dateFormatter.string(from: timePicker.date)
            self.selectedTime = timeStr
            self.sort.showTimeText.text = timeStr
            self.setTimeToShow = timeStr
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
    
    func assignDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let saveDateFormatter = DateFormatter()
        saveDateFormatter.dateFormat = "dd MMMM yyyy"
        var dateStr = ""
        var saveDateStr = ""
        if self.calendar.selectedDate == nil {
            dateStr = dateFormatter.string(from: Date())
            selectedDate = dateStr
            
        } else {
            dateStr = dateFormatter.string(from: self.calendar.selectedDate!)
        }
        self.selectedDate = dateStr
        self.sort.showDateText.text = dateStr
        self.dismiss(animated: true, completion: { _ in })
        self.tableView.reloadData()
    }
    
    func selectDate(){
        let alertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertViewController.transitionStyle = .fade
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: {(_ action) in
            self.dismiss(animated: true, completion: { _ in })
        }))
        alertViewController.addAction(NYAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .destructive, handler: {(_ action) in
            self.assignDate()
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
        print(maxDate.description)
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
        return true
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maxDate[3]
    }
}



//MARK:- DeliverySchedule Delegate

extension DDProductViewController: deliveryTimePopUpDelegate{
    
    func asapButtonTapped(_ value: Int) {
        print(value)
        ifScheduleSelected = true
        for item in arrDeliverySchedule{
            if item.Type_Id ==  value {
                objDeliverySchedule.Id = item.Id
                objDeliverySchedule.Store_Id = item.Store_Id
                objDeliverySchedule.Type_Id = item.Type_Id
                objDeliverySchedule.Type_Name = item.Type_Name
                objDeliverySchedule.isShowPopUp = false
                objDeliverySchedule.Open_From = storeData.Open_From
                objDeliverySchedule.Open_To = storeData.Open_To
                objDeliverySchedule.Delivery_time = todayTime
                objDeliverySchedule.Delivery_Date = todayDay
            }
        }
    }
    
    func todayButonTapped(_ value: Int) {
        print(value)
        ifScheduleSelected = true
        for item in arrDeliverySchedule{
            if item.Type_Id ==  value {
                objDeliverySchedule.Id = item.Id
                objDeliverySchedule.Store_Id = item.Store_Id
                objDeliverySchedule.Type_Id = item.Type_Id
                objDeliverySchedule.Type_Name = item.Type_Name
                objDeliverySchedule.isShowPopUp = false
                objDeliverySchedule.Open_From = storeData.Open_From
                objDeliverySchedule.Open_To = storeData.Open_To
                objDeliverySchedule.Delivery_time = todayTime
                objDeliverySchedule.Delivery_Date = todayDay
            }
        }
    }
    
    func laterButtonTapped(_ value: Int) {
        print(value)
        ifScheduleSelected = true
        for item in arrDeliverySchedule{
            if item.Type_Id ==  value {
                objDeliverySchedule.Id = item.Id
                objDeliverySchedule.Store_Id = item.Store_Id
                objDeliverySchedule.Type_Id = item.Type_Id
                objDeliverySchedule.Type_Name = item.Type_Name
                objDeliverySchedule.Open_From = storeData.Open_From
                objDeliverySchedule.Open_To = storeData.Open_To
                objDeliverySchedule.Delivery_time = todayTime
                objDeliverySchedule.Delivery_Date = todayDay
            }
        }
    }
    
    func setDataInDeliverySchedule(_value: Int ){
    }
    
    func dateButtonTapped() {
        selectDate()
    }
    
    func timeButtonTapped() {
        selectTime()
    }
    
    func submitButtonTapped(){
      //  if ifScheduleSelected == true {
            if isViewDealnPromotion == true{     // Delivery Schedule don't show in Deal & Promotion
                let formater2 = DateFormatter()
                formater2.dateFormat = "yyyy-MM-dd"
                let result2 = formater2.string(from: Date())
                objDeliverySchedule.OrderDelivery_dateNtime  = "\(result2) \(todayTime)"
                objDeliverySchedule.Id = 12
                objDeliverySchedule.Store_Id = product.Store_id
                objDeliverySchedule.Type_Id = 0
                objDeliverySchedule.Type_Name = "ASAP"
                let addProduct = ProductItem(value: self.product)
                AppStateManager.sharedInstance.addCartItems(product: addProduct, scheduleDelivery: objDeliverySchedule)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
                vc.isdealnPromotionEnable = true
                self.navigationController?.isHeroEnabled = false
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            else{
                if objDeliverySchedule.deliveryTypesArray.count != 0{
                    objDeliverySchedule.deliveryTypesArray.removeAll()
                }
                let minTime = Float( storeData.MinDeliveryTime.value!)
                if objDeliverySchedule.Type_Id == 1 || objDeliverySchedule.Type_Id == 2{  //for today and later schedule deliveryTime not added
                    self.setTime(0.0)
                }
                else{
                    if minTime > 0{
                        self.setTime(minTime)
                    }else{
                        self.setTime(0.0)
                    }
                }
                let assignedDate = getSelectedTimeInterval()
                todayDay = setDate(dateValue: assignedDate)

                objDeliverySchedule.Delivery_time = todayTime
                objDeliverySchedule.Delivery_Date = setdatetoShow
                objDeliverySchedule.Store_Id = product.Store_id
                
                todayTime = Utility.convertTimeIn24(value: todayTime)
                objDeliverySchedule.OrderDelivery_dateNtime = "\(todayDay) \(todayTime)"
                
                for item in arrDeliverySchedule{
                    objDeliverySchedule.deliveryTypesArray.append(item)
                }
                let addProduct = ProductItem(value: self.product)
                AppStateManager.sharedInstance.addCartItems(product: addProduct, scheduleDelivery: objDeliverySchedule)
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
                self.navigationController?.isHeroEnabled = false
                vc.objDeliverySchedule = objDeliverySchedule
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
//        else{
//            self.showErrorWith(message: "Please select Delivery Schedule.")
//        }
}

