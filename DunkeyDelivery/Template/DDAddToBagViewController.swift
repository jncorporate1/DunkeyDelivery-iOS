//
//  DDAddToBagViewController.swift
//  Template
//
//  Created by Ingic on 7/10/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FSCalendar
import NYAlertViewController



class DDAddToBagViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    
    
    //MARK: - Variable
    
    var cartItems = [Cart]()
    var footer = BagFooterView()
    var header = BagHeaderView()
    var settingObj: Setting!
    var orderPriceCheck: Bool = false
    var orderPriceless: Bool = false
    //deliverySchedule
    var calendar: FSCalendar!
    var selectedDate : String!
    var selectedTime : String!
    var sort = SetDeliveryTimePopUp()
    var scheduleDate = Date()
    var maxDate = [Date] ()
    var objDeliverySchedule = DeliverySchedule()
    var arrDeliverySchedule = [DeliverySchedule]()
    var todayDay:String = ""
    var todayTime:String = ""
    var openTo: String = ""
    var openFrom: String = ""
    var minmumDeliveryTime: Int = 0
    var secondTimeButtonPress:Bool = false
    var setTimeToShow = ""
    var setDateToShow = ""
    // deal and promtions
    var isdealnPromotionEnable: Bool = false
  
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Your Bag"
        settingObj = AppStateManager.sharedInstance.settingObj
        addbackButtonToHomeViewController()
        setUpTableView()
        setUpDelegates()
        calculatTotalPrize()
        setUpCalander()
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bagNavigationBar()
        hideTabBarAnimated(hide: true)
        
    }


    //MARK: - Helping Method
    
    
    func setUpCalander(){
        let schCalendar = Calendar.Component.day.self
        maxDate = self.generateDates(startDate: scheduleDate, addbyUnit: schCalendar, value: 4)
        arrDeliverySchedule = AppStateManager.sharedInstance.deliveryTypes
        print (tableView.contentOffset.y)
        let width = UIScreen.main.bounds.width
        header.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        footer.frame = CGRect(x: 0, y: 0, width: width, height: 250) //300
        sort.layer.cornerRadius = 10
    }
    
    
    func setUpTableView(){
        self.tableView.alwaysBounceVertical = false
        footer.delegate = self
        cartItems = AppStateManager.sharedInstance.getCartItems()
        self.calculatePrice(items: cartItems)
        if cartItems.count != 0{
            self.tableView.tableFooterView = footer
            self.tableView.tableHeaderView = UIView()
        }
        else{
            self.tableView.tableFooterView = UIView()
            self.tableView.tableHeaderView = UIView()
        }
    }
    
    func setUpDelegates(){
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }
    
    func addmoreItemButtonTapped(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DDHomeViewController") as! DDHomeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func checkOutButtonTapped(){

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDCheckOutViewController") as! DDCheckOutViewController
        if settingObj != nil {
            vc.settingPoints = settingObj
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calculatTotalPrize (){
        var total: Double = 0
        for item in self.cartItems {
            let tprice = item.totalPrice
            total = tprice + total
        }
        if settingObj != nil {
            self.footer.gainedPoints.text = (total * Double (self.settingObj.Point)).description + " points"
        }
    }
    
    
    func addDeliveryScheduleSubView(_ storeID: Int){
        let storeItem = cartItems[storeID]
        let storeSchedule = AppStateManager.sharedInstance.getStoreSchedule(storeId: storeItem.storeId)
        if storeSchedule.deliveryTypesArray.count > 0 {
        sort = SetDeliveryTimePopUp()
        sort.buttonView.layoutIfNeeded()
        sort.delegate = self
        sort.frame = self.view.frame
        self.view.addSubview(sort)
        todayDay = setDateToDisplay(dateValue: scheduleDate)
        self.setTimePicker(0.0)
        } 
    }
    
    
    func getStoreFromCart(_ id: Int){
        let storeItem = cartItems[id]
        let storeSchedule = AppStateManager.sharedInstance.getStoreSchedule(storeId: storeItem.storeId)
        let selectedDeliverytype = storeSchedule.Type_Id//storeItem.scheduleTime.Type_Id
        openFrom = storeSchedule.Open_From!//storeItem.scheduleTime.Open_From!
        openTo = storeSchedule.Open_To!//storeItem.scheduleTime.Open_To!
        minmumDeliveryTime = storeItem.minDeliveryTime
        selectedDate = storeSchedule.Delivery_Date
        selectedTime = storeSchedule.Delivery_time
        sort.showDateText.text = storeItem.scheduleTime.Delivery_Date
        sort.showTimeText.text = storeItem.scheduleTime.Delivery_time
        selectedDate = storeItem.scheduleTime.Delivery_Date
        selectedTime = storeItem.scheduleTime.Delivery_time
        showSelectedDeliveryType(storeItem)
        
    }
    
    func showSelectedDeliveryType(_ storeCart: Cart){
        
        for item in storeCart.scheduleTime.deliveryTypesArray{
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
        if storeCart.scheduleTime.Type_Id == 0{
            sort.setAsapView()
            sort.changeButton(index: 0)
        }
        if storeCart.scheduleTime.Type_Id == 1{
            sort.setTodayView()
            sort.changeButton(index: 1)
        }
        if storeCart.scheduleTime.Type_Id == 2{
            sort.setLaterView()
            sort.changeButton(index: 2)
        }
    }
    
        //MARK: - Action
    
    @IBAction func deliveryScheduleAction(_ sender: UIButton) {
        print("\(sender.tag) Clicked")
        
        if  isdealnPromotionEnable == false {
        addDeliveryScheduleSubView(sender.tag)
        getStoreFromCart(sender.tag)
        sort.buttonView.layoutIfNeeded()
        sort.delegate = self
        sort.isHidden = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        addmoreItemButtonTapped()
    }
    
    @IBAction func goToCheckoutAction(_ sender: Any) {
        self.checkOutTapped()
    }
    

}

 //MARK: - UITableViewDataSource, UITableViewDelegate

extension DDAddToBagViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems[section].products.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let storeItem = cartItems[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! DDAddToBagTableViewCell
            cell.minOrderImage.image = cell.minOrderImage.image!.withRenderingMode(.alwaysTemplate)
            cell.minOrderImage.tintColor = UIColor.white
            cell.selectionStyle = .none
            cell.storeName.text = storeItem.storeName
            if objDeliverySchedule.Type_Id == 0{
                cell.deliveryTime.text = "Delivery in "+"\(storeItem.minDeliveryTime)"+" min"
            }
            else{
                let minDatenTim = "\(storeItem.scheduleTime.Delivery_Date!) \(String(describing: storeItem.scheduleTime.Delivery_time!))"
                cell.deliveryTime.text = "Delivery in "+"\(String(describing: minDatenTim))"//+" min"
            }
            cell.minimunOrderPrice.text = "Minimun Order Price $"+"\(storeItem.minOrderPrice)"
            cell.storePrice.text = "$\(storeItem.totalPrice)"
            cell.deliveryScheduleButton.tag = indexPath.section
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! DDAddToBagTableViewCell
            let item = cartItems[indexPath.section].products[indexPath.row - 1]
            let url = item.Image?.getURL()
            cell.productImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "logo_icon"))
            cell.index = indexPath
            cell.dataSource = self
            cell.delegate = self
            cell.productName.text = item.Name
            cell.productDes.text = item.Description
            cell.productPrice.text = "Price $"+(item.Price.value!).description
            cell.productQuantity.text = "  "+"\(item.quantity)"+"  "
            cell.productQuantity.backgroundColor = Constants.APP_COLOR//.withAlphaComponent(0.6)
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 68
        }
        else{
            return 105
        }
    }
}



//MARK: - SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate

extension DDAddToBagViewController: SWRevealTableViewCellDataSource, SWRevealTableViewCellDelegate{

    func rightButtonItems(in revealTableViewCell: SWRevealTableViewCell!) -> [Any]! {
        
        let plus : SWCellButtonItem = SWCellButtonItem(title:"", handler:{(item:SWCellButtonItem!, cell:SWRevealTableViewCell!)->(Bool) in
            let index = cell!.index!
            self.quantityAdd(index: index)
            return false
        } )
        plus.image = #imageLiteral(resourceName: "plus_white")
        plus.backgroundColor = UIColor(red:0.86, green:0.65, blue:0.00, alpha:1.0)
        plus.tintColor = UIColor.white
        plus.width = 50
        
        let delete : SWCellButtonItem = SWCellButtonItem(title:"", handler:{(item:SWCellButtonItem!, cell:SWRevealTableViewCell!)->(Bool) in
            let index = cell!.index!
            self.deleteTapped(index: index)
            return false
        } )
        delete.tintColor = UIColor.white
        delete.width = 50
        delete.image = #imageLiteral(resourceName: "delete_white_icon")
        delete.backgroundColor = UIColor(red:0.84, green:0.27, blue:0.36, alpha:1.0)
        let minus : SWCellButtonItem = SWCellButtonItem(title:"", handler:{(item:SWCellButtonItem!, cell:SWRevealTableViewCell!)->(Bool) in
            let index = cell!.index!
            self.quantityMinus(index: index)
            return false
        } )
        minus.image = #imageLiteral(resourceName: "desh_white_icon")
        minus.backgroundColor = UIColor(red:0.91, green:0.42, blue:0.19, alpha:1.0)
        minus.tintColor = UIColor.white
        minus.width = 50
       
        return [plus,minus,delete];
    }
    func quantityAdd(index: IndexPath){
        let item = self.cartItems[index.section].products[index.row - 1]
        let cartItem = self.cartItems[index.section]
        let quantity = item.quantity + 1
        let totalAmount = Double (cartItem.totalPrice) +  Double(item.Price.value!)
        
        let realm = AppStateManager.sharedInstance.realm
        try! realm!.write() {
            AppStateManager.sharedInstance.realm!.objects(ProductItem.self).filter({$0.Id == item.Id}).first?.quantity = quantity
            AppStateManager.sharedInstance.realm!.objects(Cart.self).filter({$0.storeId == cartItem.storeId}).first?.totalPrice = totalAmount
        }
        self.cartItems = AppStateManager.sharedInstance.getCartItems()
         self.calculatePrice(items: cartItems)
        if self.cartItems.count == 0{
            self.tableView.tableFooterView = nil
        }
        orderPriceless = false
         self.calculatTotalPrize()
        self.tableView.reloadData()
    }
    func quantityMinus(index: IndexPath){
        let item = self.cartItems[index.section].products[index.row - 1]
        let cartItem = self.cartItems[index.section]
        let totalPrice = Double (cartItem.totalPrice) - Double(item.Price.value!)
        
        if item.quantity > 1{
            let quantity = item.quantity - 1
            let realm = AppStateManager.sharedInstance.realm
            try! realm!.write() {
                AppStateManager.sharedInstance.realm!.objects(ProductItem.self).filter({$0.Id == item.Id}).first?.quantity = quantity
                AppStateManager.sharedInstance.realm!.objects(Cart.self).filter({$0.storeId == cartItem.storeId}).first?.totalPrice = totalPrice
            }
            self.cartItems = AppStateManager.sharedInstance.getCartItems()
            self.calculatePrice(items: cartItems)
            if self.cartItems.count == 0{
                self.tableView.tableFooterView = nil
            }
             self.calculatTotalPrize()
            self.tableView.reloadData()
            orderPriceless = true
            return
        }
        self.showErrorWith(message: "Quantity of product(s) added must be greater than 1.")
        
    }
    func deleteTapped(index: IndexPath){
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "Are you sure  you want to delete this order?", preferredStyle: .alert)
        
        let cancelActionButton = UIAlertAction(title: "No", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        
        
        let deleteActionButton = UIAlertAction(title: "Yes", style: .default)
        { _ in
            self.deleteProduct(index: index)
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    func deleteProduct(index: IndexPath){
        let item = self.cartItems[index.section].products[index.row - 1]
        let realm = AppStateManager.sharedInstance.realm
        
        try!  realm!.write(){
            if self.cartItems[index.section].products.count > 1{
                AppStateManager.sharedInstance.realm.delete(item)
                realm?.refresh()
            }
            else{
                let toBeDeleted = AppStateManager.sharedInstance.realm.objects(Cart.self).first(where: {$0.storeId == self.cartItems[index.section].storeId})
                AppStateManager.sharedInstance.realm.delete(toBeDeleted!)
                realm?.refresh()
            }
        }
        self.cartItems = AppStateManager.sharedInstance.getCartItems()
        self.calculatePrice(items: cartItems)
        self.calculatTotalPrize()
        if self.cartItems.count == 0{
            self.tableView.tableFooterView = UIView()
        }
        self.tableView.reloadData()
    }
}


//MARK: - BagFooterViewDelegate

extension DDAddToBagViewController: BagFooterViewDelegate{
    func addMoreItemTapped() {
        self.addmoreItemButtonTapped()
    }
    
    func checkOutTapped() {
        for store in self.cartItems{
            if store.totalPrice >= store.minOrderPrice{
                orderPriceCheck = true
                orderPriceless = false
            }
            else {
                orderPriceCheck = false
                orderPriceless = true
            }
        }
        
        if orderPriceCheck == true && orderPriceless == false {
            self.checkOutButtonTapped()
        }
        else{
             self.showErrorWith(message: "Some Store Price is less than Store's Minimum Order Price")
        }
    }
}


//MARK: -  DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

extension DDAddToBagViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyCart_icon")
    }
    
    func title(forEmptyDataSet scrollView:
        UIScrollView!) -> NSAttributedString! {
        let text = "Cart is empty."
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 21),
            NSForegroundColorAttributeName: Constants.CART_COLOR
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Looks like you have no items in your cart."
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: Constants.CART_COLOR,
            NSParagraphStyleAttributeName: para
        ]
        
        self.checkOutButtonOutlet.isHidden = true
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let text = "Add items in cart"
        let attribs = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16),
            NSForegroundColorAttributeName: Constants.APP_COLOR
            ] as [String : Any]
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        self.addmoreItemButtonTapped()
    }
}


//MARK: - Set Time & Date

extension DDAddToBagViewController{
    
    
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
        dateFormatter.dateFormat = "dd MMMM yyyy, hh:mm a " //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        return dateFormatter.date(from: timeIntervalStr)!
    }
    
    func setDate(dateValue: Date)-> String{
        let formater2 = DateFormatter()
        formater2.dateFormat = "yyyy-MM-dd"
        let result2 = formater2.string(from: dateValue)
        return result2
    }
    
    func setDateToDisplay(dateValue: Date)-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd LLLL yyyy"
        let result = formatter.string(from: dateValue)
        self.sort.showDateText.text = result
        selectedDate = result
        return result
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

extension DDAddToBagViewController: FSCalendarDelegate, FSCalendarDataSource {
    func selectTime(){
       let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.tintColor = Constants.APP_COLOR
        timePicker.setValue(Constants.APP_COLOR, forKey: "textColor")
        let alertViewController = NYAlertViewController(nibName: nil, bundle: nil)
        alertViewController.transitionStyle = .fade
        var startHour: Int = 0
        var endHour: Int = 0
        var temp  = openTo.characters.map{String($0)}
        let ftime = temp[0] + temp[1]
        startHour = Int(ftime)!
        var temp1  = openFrom.characters.map{String($0)}
        let ltime = temp1[0] + temp1[1]
        endHour = Int(ltime)!
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
            self.sort.showDateText.text = dateStr
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

extension DDAddToBagViewController: deliveryTimePopUpDelegate{

    
    func asapButtonTapped(_ value: Int ) {
        print(value)
        try! AppStateManager.sharedInstance.realm.write() {
            for item in arrDeliverySchedule{
                if item.Type_Id ==  value {
                    objDeliverySchedule.Id = item.Id
                    objDeliverySchedule.Store_Id = item.Store_Id
                    objDeliverySchedule.Type_Id = item.Type_Id
                    objDeliverySchedule.Type_Name = item.Type_Name
                    objDeliverySchedule.Open_From = openFrom
                    objDeliverySchedule.Open_To = openTo
                    objDeliverySchedule.Delivery_time = todayTime
                    objDeliverySchedule.Delivery_Date = todayDay
                }
            }
        }
    }
    
    func todayButonTapped(_ value: Int ) {
        print(value)
        
       try! AppStateManager.sharedInstance.realm.write() {
            for item in arrDeliverySchedule{
                if item.Type_Id ==  value {
                    objDeliverySchedule.Id = item.Id
                    objDeliverySchedule.Store_Id = item.Store_Id
                    objDeliverySchedule.Type_Id = item.Type_Id
                    objDeliverySchedule.Type_Name = item.Type_Name
                    objDeliverySchedule.Open_From = openFrom
                    objDeliverySchedule.Open_To = openTo
                    objDeliverySchedule.Delivery_time = todayTime
                    objDeliverySchedule.Delivery_Date = todayDay
                }
            }
        }
    }
    
    func laterButtonTapped(_ value: Int ) {
      print(value)
        try! AppStateManager.sharedInstance.realm.write() {
            for item in arrDeliverySchedule{
                if item.Type_Id ==  value {
                    objDeliverySchedule.Id = item.Id
                    objDeliverySchedule.Store_Id = item.Store_Id
                    objDeliverySchedule.Type_Id = item.Type_Id
                    objDeliverySchedule.Type_Name = item.Type_Name
                    objDeliverySchedule.Open_From = openFrom
                    objDeliverySchedule.Open_To = openTo
                    objDeliverySchedule.Delivery_time = todayTime
                    objDeliverySchedule.Delivery_Date = todayDay
                }
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
    
    
    //MARK: - Submited Button
    
    func submitButtonTapped(){
            
        let realm = AppStateManager.sharedInstance.realm
        try! realm!.write() {
            
            if objDeliverySchedule.deliveryTypesArray.count != 0{
                objDeliverySchedule.deliveryTypesArray.removeAll()
            }
            
            let minTime = Float(minmumDeliveryTime)
            if objDeliverySchedule.Type_Id == 1 || objDeliverySchedule.Type_Id == 2{
                self.setTime(0.0)
            }
            else{
            if minTime > 0{
                self.setTime(minTime)
            }
            else{
                self.setTime(0.0)
                }
            }
            let assignedDate = getSelectedTimeInterval()
            todayDay = setDate(dateValue: assignedDate)
            todayTime = Utility.convertTimeIn24(value: todayTime)
            objDeliverySchedule.OrderDelivery_dateNtime = "\(todayDay) \(todayTime)"
            objDeliverySchedule.Delivery_time = selectedTime
            objDeliverySchedule.Delivery_Date = selectedDate
            for item in arrDeliverySchedule{
                objDeliverySchedule.deliveryTypesArray.append(item)
            }
            AppStateManager.sharedInstance.realm!.objects(Cart.self).filter({$0.storeId == self.objDeliverySchedule.Store_Id}).first?.scheduleTime = self.objDeliverySchedule
        }
        self.cartItems = AppStateManager.sharedInstance.getCartItems()
        self.sort.isHidden = true
        self.sort.removeFromSuperview()
        self.tableView.reloadData()
    }
}
