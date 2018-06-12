//
//  DeliverySchedule.swift
//  Template
//
//  Created by Ingic on 16/03/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DeliverySchedule: Object {

    dynamic var Id: Int = -1
    dynamic var Type_Id: Int = -1
    dynamic var Type_Name: String? = ""
    dynamic var Store_Id: Int = -1
    dynamic var OrderDelivery_dateNtime : String? = ""
    dynamic var Delivery_time: String? = ""
    dynamic var Delivery_Date: String? = ""
    dynamic var isShowPopUp: Bool =  true
    dynamic var Open_From: String? = ""
    dynamic var Open_To: String? = ""
    let deliveryTypesArray = RealmSwift.List<DeliverySchedule>()
}
