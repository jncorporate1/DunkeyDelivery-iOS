//
//  Ride.swift
//  Template
//
//  Created by Muhammad Zaheer on 03/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class Ride: Object {
    
    dynamic var Id: Int = -1
    dynamic var FullName: String? = ""
    dynamic var BusinessName: String? = ""
    dynamic var BusinessType: String? = ""
    dynamic var Email: String? = ""
    dynamic var ZipCode: String? = ""
    dynamic var Phone: String? = ""
    dynamic var Status: Int = -1
    dynamic var SignInType: Int = -1
}
