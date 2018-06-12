//
//  SingleWineViewController.swift
//  Template
//
//  Created by Jamil Khan on 8/1/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import FSCalendar
import NYAlertViewController



class SingleWineViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var productData = ProductItem()
    var totalPrice = 0.0
    var stepperCount:Double = 0
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
    var setdatetoShow: String = ""
    var setTimeToShow: String = ""
    var ifScheduleSelected: Bool = false
    var rowSelectedAgain: Bool = false
    var productSizeArray = [AlcoholProductSize] ()
    var countArray : Bool = false
    var isSeeMoreEnable : Bool = false
    var selectedSizePrice = 0.0
    var stateSaveForSelectedIndex : IndexPath = []
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = productData.Name
        let schCalendar = Calendar.Component.day.self
        maxDate = self.generateDates(startDate: scheduleDate, addbyUnit: schCalendar, value: 4)
        if productData.Store_id != -1 {
            self.getStoreSchedule(storeId: "\(productData.Store_id)")
        }
        else{
            self.getStoreSchedule(storeId: "\(2081)")
        }
        setUpProductSizeArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.addBackButtonToNavigationBar()
        setNavigationRightItems()
        hideTabBarAnimated(hide: true)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    //MARK: - Hepling Method
    
    //If Alcohol product Sizes more the 4
    func setUpProductSizeArray(){
        productSizeArray = [AlcoholProductSize] ()
        let proSizes = productData.ProductSizes
        if proSizes.count > 4 {
            let items = proSizes[0..<4]
            if productSizeArray.count != 0{
                proSizes.removeAll()
            }
            for item in items{
                productSizeArray.append(item)
            }
            countArray = true
        } else{
            if self.productSizeArray.count != 0{
                self.productSizeArray.removeAll()
            }
            for item in self.productSizeArray{
                self.productSizeArray.append(item)
            }
            self.countArray = false
        }
    }
    
    
    func didTapOnSeeMore(){
        let proSizes = productData.ProductSizes
        if isSeeMoreEnable == false {
            if productSizeArray.count != 0{
                productSizeArray.removeAll()
            }
            for item in proSizes{
                productSizeArray.append(item)
            }
            isSeeMoreEnable = true
            self.tableView.reloadData()
        }
        else{
            setUpProductSizeArray()
            isSeeMoreEnable = false
            self.tableView.reloadData()
        }
    }
    
    
    func setNavigationRightItems(){
        let cartItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cart_icon"), style: .plain, target: self, action: #selector(showCart))
        self.navigationItem.rightBarButtonItems = [cartItem]
        
    }
    func showCart(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
        controller.objDeliverySchedule = objDeliverySchedule
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //StepperLeftButton for ProductSize
    func stepperLeftButtonTapped(_ sender: UIButton) {
        stepperCount += 1
        totalPrice = stepperCount * selectedSizePrice
        let indexPath = IndexPath(row: 0, section: 5)
        if let cell = tableView.cellForRow(at: indexPath) as? WineSingleTableViewCellNotImp {
            cell.setTotalPrice("$ \(totalPrice)")
        }
    }
    
    //StepperRightButton for ProductSize
    func stepperRightButtonTapped(_ sender: UIButton) {
        stepperCount -= 1
        if stepperCount > 0{
            totalPrice = stepperCount * selectedSizePrice
            let indexPath = IndexPath(row: 0, section: 5)
            if let cell = tableView.cellForRow(at: indexPath) as? WineSingleTableViewCellNotImp {
                cell.setTotalPrice("$ \(totalPrice)")
            }
        }else{
            totalPrice = 0 * selectedSizePrice
            let indexPath = IndexPath(row: 0, section: 5)
            if let cell = tableView.cellForRow(at: indexPath) as? WineSingleTableViewCellNotImp {
                cell.setTotalPrice("$ \(totalPrice)")
            }
            let index = IndexPath(row: 0, section: 4)
            if let cell1 = tableView.cellForRow(at: index) as? WineSingleTableViewCellNotImp{
                cell1.setStepperInitialState()
            }
        }
    }
    
    func stepperLeftButtonTap() {
        stepperCount += 1
        totalPrice = stepperCount * productData.Price.value!
        tableView.reloadData()
    }
    
    func stepperRightButtonTap() {
        stepperCount -= 1
        if stepperCount > 0{
            totalPrice = stepperCount * productData.Price.value!
            tableView.reloadData()
        }else{
            totalPrice = 0 * productData.Price.value!
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Action
    
    @IBAction func addToBagTapped(_ sender: Any) {
        if totalPrice == 0.0 {
            self.showErrorWith(message: "Please set quantity")
        }
        else{
            if (AppStateManager.sharedInstance.isStoreExsists(storeId: productData.Store_id)){// if store is already exist delivery schedule popUP can't show
                if arrDeliverySchedule.count > 0 {// if there is no delivery schecdule in store by default ASAP will be send to the service
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
                }
                else{
                    objDeliverySchedule.Store_Id = productData.Store_id
                    objDeliverySchedule.Type_Id = 0
                    objDeliverySchedule.Type_Name = "ASAP"
                    todayTime = Utility.getCurrentTime()
                    todayDay = Utility.getCurretnDate()
                    self.submitButtonTapped()
                }
            }//if store is already exist delivery schedule
            else{
                submitButtonTapped()
            }
        }
    }
}


//MARK: -  UITableViewDelegate, UITableViewDataSource

extension SingleWineViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productData.ProductSizes.count > 0 {
            if (section == 2){
                if productData.ProductSizes.count > 4 {
                    return productSizeArray.count
                }
                else{
                    return productData.ProductSizes.count
                }
            }
            return 1
        }
        else{
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if productData.ProductSizes.count > 0 {
            return 8
        }
        else{
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : WineSingleTableViewCellNotImp!
        
        if productData.ProductSizes.count > 0 {
            
            if(indexPath.section == 0){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WineSingleTableViewCellNotImp
                let url = productData.Image?.getURL()
                cell.productImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                cell.productDescriptionLabel.text = productData.Description
                cell.productNameLabel.text = productData.Name
            }
            
            if(indexPath.section == 1){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell7") as! WineSingleTableViewCellNotImp
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
            }
            
            if(indexPath.section == 2){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! WineSingleTableViewCellNotImp
                let productSize = productData.ProductSizes[indexPath.row]
                cell.productSizePrice.text = "$ \(productSize.Price)"
                let totalArrayCount = productData.ProductSizes.count
                if indexPath.row == 0 && rowSelectedAgain == false{
                    cell.setButtonSelected()
                    selectedSizePrice = productData.ProductSizes[indexPath.row].Price
                }
                else {
                    cell.setButtonUnSelected()
                }
                
                if stateSaveForSelectedIndex == indexPath {
                      cell.setButtonSelected()
                }
                
                //cell.productSizeName.text = "\(String(describing: productSize.Size!)) \(String(describing: productSize.Unit!)) bottle"
                cell.productSizeName.text = productSize.NetWeight!
                
                if indexPath.row == totalArrayCount - 1 {
                    if  isSeeMoreEnable == false {
                        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 1))
                    }
                    else{
                        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                    }
                }
                else{
                    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, UIScreen.main.bounds.width)
                }
            }
            
            if indexPath.section == 3{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell8", for: indexPath) as! WineSingleTableViewCellNotImp
                cell.selectionStyle = .none
                if  isSeeMoreEnable == true {
                    cell.seeMoreButton.addTarget(self, action: #selector(didTapOnSeeMore), for: .touchUpInside)
                    cell.seeMoreButton.setTitle(" See Less", for: .normal)
                    cell.separatorInset = .zero
                }
                else{
                    cell.seeMoreButton.addTarget(self, action: #selector(didTapOnSeeMore), for: .touchUpInside)
                    cell.seeMoreButton.setTitle(" See More", for: .normal)
                }
                return cell
            }
            
            if(indexPath.section == 4){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! WineSingleTableViewCellNotImp
                cell.setStepperFont()
                self.stepperCount = cell.stepper.value
                cell.stepper.leftButton.addTarget(self, action: #selector(stepperLeftButtonTapped(_:)), for: .touchUpInside)
                cell.stepper.rightButton.tag = indexPath.row
                cell.stepper.rightButton.addTarget(self, action: #selector(stepperRightButtonTapped(_:)), for: .touchUpInside)
            }
            
            if(indexPath.section == 5){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! WineSingleTableViewCellNotImp
                cell.totalPriceLabel.text = "$ \(totalPrice)"
            }
            
            if(indexPath.section == 6){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! WineSingleTableViewCellNotImp
            }
            
            if(indexPath.section == 7){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell6") as! WineSingleTableViewCellNotImp
            }
            return cell
        } // if productSize array count > 0
            
        else{
            
            if(indexPath.section == 0){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WineSingleTableViewCellNotImp
                let url = productData.Image?.getURL()
                cell.productImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
                cell.productDescriptionLabel.text = productData.Description
                cell.productNameLabel.text = productData.Name
            }
                
            else if(indexPath.section == 1){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! WineSingleTableViewCellNotImp
                cell.productSizePrice.text = "$ \(productData.Price.value!)"
                cell.productSizeName.text = "Price"
                // cell.productSizeName.font = UIFont(name: "Price", size: 12)
                cell.radioButtonWidth.constant = 0
                cell.productSizeNameLeading.constant = 0
                cell.productSizeName.textColor = UIColor.black
            }
                
            else if(indexPath.section == 2){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell4") as! WineSingleTableViewCellNotImp
                cell.setStepperFont()
                self.stepperCount = cell.stepper.value
                cell.stepper.leftButton.addTarget(self, action: #selector(stepperLeftButtonTap), for: .touchUpInside)
                cell.stepper.rightButton.addTarget(self, action: #selector(stepperRightButtonTap), for: .touchUpInside)
            }
                
            else if(indexPath.section == 3){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell5") as! WineSingleTableViewCellNotImp
                cell.totalPriceLabel.text = "$ \(totalPrice)"
            }
                
            else if(indexPath.section == 4){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell3") as! WineSingleTableViewCellNotImp
            }
                
            else if(indexPath.section == 5){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell6") as! WineSingleTableViewCellNotImp
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if productData.ProductSizes.count > 0 {
            if  indexPath.section == 2{
                print("-> Index\(indexPath.row)")
                stepperCount = 0.0
                stateSaveForSelectedIndex = indexPath
                let button = UIButton()
                self.stepperRightButtonTapped(button)
                let proSizePrice = productData.ProductSizes[indexPath.row].Price
                selectedSizePrice = proSizePrice
                rowSelectedAgain = true
                self.tableView.reloadData()
                let cell = tableView.cellForRow(at: indexPath) as! WineSingleTableViewCellNotImp
                cell.setButtonSelected()
                //var sizeName = productData.ProductSizes[indexPath.row].Size! + productData.ProductSizes[indexPath.row].Unit!
                var sizeName = productData.ProductSizes[indexPath.row].NetWeight
                sizeName = sizeName?.replacingOccurrences(of: " ", with: "")
                productData.SizeName = sizeName
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if productData.ProductSizes.count > 0 {
            if(indexPath.section == 0){
                return 280
            }
            else if(indexPath.section == 1){
                return 50
            }
            else if(indexPath.section == 2){
                return 45
            }
                
            else if indexPath.section == 3{
                if countArray == true{
                    return 60
                }
                else{
                    if productSizeArray.count > 4 {
                        return 60
                    }
                    else{
                        return 0
                    }
                }
            }
            else if(indexPath.section == 4){
                return 73
            }
            else if(indexPath.section == 5){
                return 73
            }
            else if(indexPath.section == 6){
                return 100
            }
            else if(indexPath.section == 7){
                return 85
            }
        }
            
        else{
            if(indexPath.section == 0){
                return 280
            }
            else if(indexPath.section == 1){
                return 58
            }
            else if(indexPath.section == 2){
                return 73
            }
            else if(indexPath.section == 3){
                return 73
            }
            else if(indexPath.section == 4){
                return 100
            }
            else if(indexPath.section == 5){
                return 85
            }
        }
        return 0
    }
}

//MARK: - Set Date&Time

extension SingleWineViewController{
    
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
}


// MARK: - FSCalendarDelegate, FSCalendarDataSource

extension SingleWineViewController: FSCalendarDelegate, FSCalendarDataSource {
    
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
        // let anchorComponents = schCalendar.dateComponents([.day, .month, .year], from: scheduleDate)
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


//MARK: - DeliverySchedule Delegate

extension SingleWineViewController: deliveryTimePopUpDelegate{
    
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
        
        if ifScheduleSelected == true {
       
            if self.arrDeliverySchedule.count > 0 {
                sort.isHidden = true
                objDeliverySchedule.Type_Id = 0
            }

         
            productData.quantity = Int(stepperCount)
            if objDeliverySchedule.deliveryTypesArray.count != 0{
                objDeliverySchedule.deliveryTypesArray.removeAll()
            }
            let minTime = Float( storeData.MinDeliveryTime.value!)
            if objDeliverySchedule.Type_Id == 1 || objDeliverySchedule.Type_Id == 2{
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
            todayTime = Utility.convertTimeIn24(value: todayTime)
            objDeliverySchedule.OrderDelivery_dateNtime = "\(todayDay) \(todayTime)"
            objDeliverySchedule.Delivery_Date = setdatetoShow
            objDeliverySchedule.Store_Id = productData.Store_id
            for item in arrDeliverySchedule{
                objDeliverySchedule.deliveryTypesArray.append(item)
            }
            AppStateManager.sharedInstance.addCartItems(product: productData, scheduleDelivery: objDeliverySchedule)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DDAddToBagViewController") as! DDAddToBagViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else{
            self.showErrorWith(message: "Please select Delivery Schedule.")
        }
    }
}


//MARK: - WebService

extension SingleWineViewController{
    
    func getStoreSchedule(storeId: String){
        
        self.startLoading()
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
                    self.storeData = storeObj
                }
                let deliverytypeArray = storeitemss["StoreDeliveryTypes"] as! NSArray
                let appManger = AppStateManager.sharedInstance
                
                if appManger.deliveryTypes.count != 0 {
                    appManger.deliveryTypes.removeAll()
                }
                
                for ditem in deliverytypeArray{
                    let items = DeliverySchedule(value: ditem as! NSDictionary)
                    appManger.deliveryTypes.append(items)
                }
                self.arrDeliverySchedule = AppStateManager.sharedInstance.deliveryTypes
                self.asapButtonTapped(0)
                self.assignTimeAtStart()
                self.assignDateFirstTime()
                self.tableView.reloadData()
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
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
