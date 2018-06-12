//
//  Cart.swift
//  Template
//
//  Created by zaidtayyab on 01/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  Cart: Object {
    
    dynamic var storeId = -1
    dynamic var storeName: String!
    dynamic var businessType: String!
    dynamic var StoreTax: Double = 0
    dynamic var StoreSubTotal: Double = 0
    dynamic var StoreTotal: Double = 0
    dynamic var minDeliveryTime = 0
    dynamic var minOrderPrice: Double = 0
    dynamic var minDeliveryCharges: Double = 0
    dynamic var totalPrice: Double = 0
            var products = List<ProductItem>()
    dynamic var scheduleTime : DeliverySchedule!
    override static func primaryKey() -> String? {
        return "storeId"
    }
}

