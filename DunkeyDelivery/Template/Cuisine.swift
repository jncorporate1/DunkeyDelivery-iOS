//
//  Cuisine.swift
//  Template
//
//  Created by Ingic on 03/02/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import Realm

class Cuisine: Object {
    
    dynamic var Id: Int = -1
    dynamic var Tag: String? = ""
    dynamic var TotalCount = -1
}
