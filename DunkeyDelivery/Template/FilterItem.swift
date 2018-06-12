//
//  FilterItem.swift
//  Template
//
//  Created by Ingic on 03/02/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import Realm

class FilterItem: Object {

    dynamic var sortBy: Int = -1
    dynamic var rating: Int = -1
    dynamic var minDeliveryTime: Int = 0
    dynamic var priceRange: String? = ""
    dynamic var minDelvieryCharger: Double = 0
    dynamic var isSpecial: Bool = false
    dynamic var isFreeDelivery: Bool = false
    dynamic var isNewRestaurants: Bool = false
    dynamic var cuisines: String? = ""
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var sortByString = ""
    dynamic var radioButtonGroup1: Int = -1
    dynamic var radioButtonGroup2: Int = -1
    dynamic var name: String? = ""
}
