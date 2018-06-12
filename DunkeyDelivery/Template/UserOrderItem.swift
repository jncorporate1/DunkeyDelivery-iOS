//
//  UserOrderItem.swift
//  Template
//
//  Created by Muhammad Zaheer on 15/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class UserOrderItem: Object {
    
    dynamic var Id: Int = -1
    dynamic var ItemId: Int = -1
    dynamic var Qty: Int = -1
    dynamic var StoreOrder_Id: Int = -1
    dynamic var Name: String? = ""
    dynamic var Price: Double = 0
    dynamic var Description : String? = ""
    dynamic var ImageUrl:String? = ""
}
