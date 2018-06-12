//
//  DDOrderScreenViewController.swift
//  Template
//
//  Created by Ingic on 7/11/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DDOrderScreenViewController: BaseController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    
    var orderHistoryObj = [Order]()
    var settingObj: Setting!
    var tipPer = ""
    var tip: String!
    var tax: String!
    var deliveyfeee : String!
    var subStore: Double = 0
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.addbackButtonToHomeViewController()
        self.title = "Thank You"
        storeSubStore()
    }
    
    
    //MARK: - Helping Method
    
    func storeSubStore(){
        for item in orderHistoryObj{
            for storeItem in item.StoreOrders{
                 subStore = storeItem.Subtotal + subStore
            }
        }
    }
    
    func getCurrentDate(addMin: Int) -> String{
        let date = Date()
        let calendar = Calendar.current
        var finalMin = 0
        var addminss = 0
        var hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("hours = \(hour):\(minutes):\(seconds)")
        
        addminss = minutes + addMin
        if addminss <=  60 {
            finalMin = addMin
        }
        else{
            hour = hour + 1
            finalMin = addminss - 60
        }
        let sendTime = "\(hour):\(finalMin):\(seconds)"
        return sendTime
        
    }
    
    func setDateLabel(dateValue: String)-> String{
        let date2 = Date()
        let formater2 = DateFormatter()
        formater2.dateFormat = "dd MMMM yyyy"
        let result2 = formater2.string(from: date2)
        return result2
    }
    
    func setTimeLabel( value: String)-> String{
        let date2 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm a"
        formatter1.amSymbol = "AM"
        formatter1.pmSymbol = "PM"
        formatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let timeResult = formatter1.string(from: date2)
        return "\(timeResult)"
    }
    
    
    //MARK: - Actions
    
    @IBAction func orderHistoryTapped(_ sender: Any) {
        tabSelected()
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}



//MARK: - UITableViewDataSource, UITableViewDelegate

extension DDOrderScreenViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DDOrderScreenTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DDOrderScreenTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "subDetailCell", for: indexPath) as! DDOrderScreenTableViewCell
            let item = orderHistoryObj[indexPath.row]
            cell.orderId.text = (item.Id).description
            let order   = item.OrderDateTime
            let splitTimenDate = order?.components(separatedBy: " ")
            let date12 = splitTimenDate![0]
            let time   = splitTimenDate![1]
            let dn     = splitTimenDate![2]
            let date   = Utility.convertDateFormatter(date: order!, withFormat: "dd MMMM yyyy")
            cell.orderDate.text = date
            cell.deliveryTime.text = time + " " + dn
            cell.paymentType.text = "Credit Card"

            if item.DeliveryDetails_AddtionalNote !=  "Add Special Instructions"{
               cell.addtionalNote.text = item.DeliveryDetails_AddtionalNote
            }
            else{
                cell.addtionalNote.text = "N/A"
            }
        
            cell.addressLabel.text = item.DeliveryDetails_Address
            cell.subTotal.text = "$" + (subStore).description
            cell.deliveryFeeLabel.text = "$" + (deliveyfeee).description
            cell.taxLabel.text = "$\(tax!)"
            cell.tipPercentage.text = "Tip \(tipPer)%"
            cell.tipLabel.text = "$" + item.TipAmount.description
            cell.total.text = "$" + (item.Total).description
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 275
        }
        else if indexPath.section == 1{
            return 84
        }
        else{
            return  520 //479
        }
    }
}
