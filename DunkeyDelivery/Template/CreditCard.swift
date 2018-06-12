//
//  CreditCard.swift
//  Template
//
//  Created by Muhammad Zaheer on 28/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class CreditCard : Object{
    
    dynamic var BillingCode: String? = ""
    dynamic var CCNo: String? = ""
    dynamic var CCV: String? = ""
    dynamic var ExpiryDate: String? = ""
    dynamic var Id: Int = -1
    dynamic var Is_Primary: Int = -1
    dynamic var Label: String? = ""
    dynamic var User_ID: Int = -1
    dynamic var User: User!
}
