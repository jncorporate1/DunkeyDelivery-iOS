//
//  UserOrder.swift
//  Template
//
//  Created by Muhammad Zaheer on 15/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class Order: Object {
    
    dynamic var Id: Int = -1
    dynamic var OrderNo: String? = ""
    dynamic var Status:  Int = -1
    dynamic var OrderDateTime: String? = ""
    dynamic var DeliveryTime_From:String? = ""
    dynamic var DeliveryTime_To:String? = ""
    dynamic var PaymentMethod: Int = -1
    dynamic var Subtotal: Double = 0
    dynamic var ServiceFee: Double = 0
    dynamic var DeliveryFee:  Double = 0
    dynamic var Total:Double = 0
    dynamic var TipAmount:Double = 0
    dynamic var User_ID: Int = -1
    dynamic var IsDeleted:Bool = false
    dynamic var UserFullName: String? = ""
    dynamic var TotalTaxDeducted:Double = 0
    dynamic var DeliveryDetails_FirstName: String? = ""
    dynamic var DeliveryDetails_LastName: String? = ""
    dynamic var DeliveryDetails_Phone: String? = ""
    dynamic var DeliveryDetails_ZipCode:String? = ""
    dynamic var DeliveryDetails_Email: String? = ""
    dynamic var DeliveryDetails_City:String? = ""
    dynamic var DeliveryDetails_Address: String? = ""
    dynamic var DeliveryDetails_AddtionalNote: String? = ""
    dynamic var MaxDeliveryTime: Int  = -1
            var StoreOrders = List<UserStoreOrders>()
            var OrderPayment_Id = RealmOptional<Int>()
            var DeliveryMan_Id = RealmOptional<Int>()
}
