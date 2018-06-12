//
//  UserStoreOrders.swift
//  Template
//
//  Created by Muhammad Zaheer on 15/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class UserStoreOrders: Object {
    
    dynamic var Id: Int = -1
    dynamic var OrderNo:String? = ""
    dynamic var Status: Int = -1
    dynamic var Store_Id: Int = -1
    dynamic var Subtotal: Double = 0
    dynamic var Total:Double = 0
    dynamic var IsDeleted: Bool = false
    dynamic var Order_Id: Int = -1
    dynamic var StoreName:String? = ""
    dynamic var ImageUrl:String? = ""
    dynamic var ServiceFee: Double = 0
    dynamic var DeliveryFee: Double = 0
    dynamic var OrderDeliveryTime: String? = ""
            var OrderItems = List<UserOrderItem>()
}

