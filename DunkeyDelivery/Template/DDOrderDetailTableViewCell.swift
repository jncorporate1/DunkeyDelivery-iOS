//
//  DDOrderDetailTableViewCell.swift
//  Template
//
//  Created by Ingic on 8/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class DDOrderDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryAddLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var deliveryfee: UILabel!
    @IBOutlet weak var orderTax: UILabel!
    @IBOutlet weak var orderTipPercentage: UILabel!
    @IBOutlet weak var orderTipAmount: UILabel!
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func getDate(str: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"yyyy-dd-MM HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: str)
        print(date ?? "")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d, yyyy"
        let newDate = dateFormatter2.string(from: date!)
        return newDate
    }
    
    func getTimeFromDate(str: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//"yyyy-dd-MM HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: str)
        print(date ?? "")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "h:mm a"//"MMM d, h:mm a"
        let newDate = dateFormatter2.string(from: date!)
        return newDate
    }
    
    func setDate(date: String){
        let mainStr = NSMutableAttributedString()
        let dateStr = NSMutableAttributedString()
        mainStr.normal("Order Date ", size: 15)
        dateStr.normal(getDate(str: date), size: 15)
        let mainStrRange = NSMakeRange(0, mainStr.length)
        let dateStrRange = NSMakeRange(0, dateStr.length)
        mainStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: mainStrRange)
        dateStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: dateStrRange)
        mainStr.append(dateStr)
        self.orderDateLabel.attributedText = mainStr
        
    }
    
    func setTime(from: String, to: String){
        let mainStr = NSMutableAttributedString()
        let timeStr = NSMutableAttributedString()
        mainStr.normal("Delivery Time ", size: 15)
        timeStr.normal(getTime(from: from, to: to), size: 15)
        let mainStrRange = NSMakeRange(0, mainStr.length)
        let timeStrRange = NSMakeRange(0, timeStr.length)
        mainStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: mainStrRange)
        timeStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: timeStrRange)
        mainStr.append(timeStr)
        self.orderTimeLabel.attributedText = mainStr
    }
    
    func getTime(from: String, to: String)-> String{
        if !(from.isEmpty) && !(to.isEmpty){
            let fromTime = getTimeFromDate(str: from)
            let toTime = getTimeFromDate(str: to)
            return fromTime + " to " + toTime
        }
        else{
            return "Closed"
        }
    }
    
    func setDatesssss12(dateValue: String)-> String{
        let date2 = Date()
        let formater2 = DateFormatter()
        formater2.dateFormat = "dd MMMM yyyy"
        let result2 = formater2.string(from: date2)
         return result2
    }
    
    func setTimess12( value: String)-> String{
        let date2 = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "hh:mm"
        formatter1.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let timeResult = formatter1.string(from: date2)
        return "\(timeResult)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
