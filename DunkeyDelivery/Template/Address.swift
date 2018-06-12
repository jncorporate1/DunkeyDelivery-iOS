//
//  AddAddress.swift
//  Template
//
//  Created by Muhammad Zaheer on 28/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class Address : Object{
    
   dynamic var Id: Int = -1
   dynamic var User_ID: Int = -1
   dynamic var City: String? = ""
   dynamic var State: String? = ""
   dynamic var Telephone: String? = ""
   dynamic var FullAddress: String? = ""
   dynamic var Address2: String? = ""
   dynamic var PostalCode: String? = ""
   dynamic var Frequency: String? = ""
   dynamic var IsDeleted:Bool = false
   dynamic var IsPrimary :Bool = false
}
