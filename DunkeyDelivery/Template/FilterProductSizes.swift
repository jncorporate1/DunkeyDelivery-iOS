//
//  FilterProductSizes.swift
//  Template
//
//  Created by Ingic on 02/04/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class FilterProductSize: Object{
   dynamic var Unit:String? = ""
   dynamic var Size:String? = ""
   dynamic var NetWeight: String? = ""
   dynamic var TypeID: Int = -1
}
