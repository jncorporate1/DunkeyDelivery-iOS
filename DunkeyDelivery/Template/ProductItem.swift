//
//  Product.swift
//  Template
//
//  Created by Ingic on 9/18/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  ProductItem: Object {

    dynamic var Id = -1
    dynamic var Category_Id: Int = -1
    dynamic var Description: String? = ""
    dynamic var Image: String? = ""
    dynamic var Name: String? = ""
    dynamic var Store_id = -1
    dynamic var BusinessName: String? = ""
    dynamic var quantity = -1
    dynamic var Image_Selected: String? = ""
    dynamic var Status: Int = -1
    dynamic var IsDeleted: Bool = false
    dynamic var BusinessType: String? = ""
    dynamic var ImageDeletedOnEdit: Bool = false
    dynamic var SizeName: String? = ""
    dynamic var ItemId: Int = 0
            var MinDeliveryCharges = RealmOptional<Double>()
            var MinDeliveryTime = RealmOptional<Double>()
            var MinOrderPrice = RealmOptional<Double>()
            //var Store : StoreItem? = StoreItem()
            var Price = RealmOptional<Double>()
            var ProductSizes = List<AlcoholProductSize>()
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}

/*"Id": 20,
"Unit": "L",
"Weight": 0,
"Size": "2.5",
"NetWeight": "2.5L",
"TypeID": 0,
"Price": 150,
"IsDeleted": false,
"Product_Id": 5140,
"Product": null,
"SizesUnit_Id": 5,
"SizesUnits": null*/

class AlcoholProductSize : Object{
    
    dynamic var  Id:Int = -1
    dynamic var  Unit: String? = ""
    dynamic var  Weight: Double = 0
    dynamic var  Size: String? = ""
    dynamic var  IsDeleted: Bool = false
    dynamic var  Product_Id: Int = -1
    dynamic var  Price: Double = 0
    dynamic var  NetWeight: String? = ""
    dynamic var  TypeID: Int = -1
}



