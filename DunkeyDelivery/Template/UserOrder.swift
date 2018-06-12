//
//  UserOrder.swift
//  Template
//
//  Created by Muhammad Zaheer on 15/01/2018.
//  Copyright © 2018 Zaid Tayyab. All rights reserved.
//

import UIKit
import RealmSwift

class UserOrder: Object {
    
    dynamic var OrderNo: String? = ""
    dynamic var Status:  Int = -1
    dynamic var OrderDateTime: String? = ""
    dynamic var DeliveryTime_From:String? = ""
    dynamic var DeliveryTime_To:String? = ""
    dynamic var PaymentMethod: Int = -1
    dynamic var Subtotal: Int = -1
    dynamic var ServiceFee: Int = -1
    dynamic var DeliveryFee: Int = -1
    dynamic var Total:Int = -1
    dynamic var TipAmount:Int = -1
    dynamic var User_ID: Int = -1
    dynamic var IsDeleted:Bool = false
    dynamic var OrderPayment_Id:Int = -1
    dynamic var DeliveryMan_Id: Int = -1
    dynamic var UserFullName: String = ""
    dynamic var TotalTaxDeducted:Int = -1
    dynamic var DeliveryDetails_FirstName: String = ""
    dynamic var DeliveryDetails_LastName: String = ""
    dynamic var DeliveryDetails_Phone: String = ""
    dynamic var DeliveryDetails_ZipCode:Int = -1
    dynamic var DeliveryDetails_Email: String = ""
    dynamic var DeliveryDetails_City:String = ""
    dynamic var DeliveryDetails_Address: String = ""
    dynamic var DeliveryDetails_AddtionalNote: String = ""
    
}
