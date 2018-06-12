//
//  OfferProduct.swift
//  Template
//
//  Created by Ingic on 19/02/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class OfferPackage: Object {

    dynamic var Id:Int = -1
    dynamic var Offer_Id:Int = -1
    dynamic var Product_Id:Int = -1
    dynamic var OfferProductId:Int = -1
    dynamic var Description:String? = ""
    dynamic var DiscountPercentage: Int = -1
    dynamic var ImageUrl: String? = ""
    dynamic var IsDeleted: Bool = false
            var Price = RealmOptional <Double> ()
            var Offer: OfferItem? = OfferItem()
            var Package : PackageItem? = PackageItem()
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}


class OfferItem : Object {
    
    dynamic var Id: Int = -1
    dynamic var ValidFrom: String? = ""
    dynamic var ValidUpto: String? = ""
    dynamic var Name: String? = ""
    dynamic var Title: String? = ""
    dynamic var Description: String? = ""
    dynamic var Status :String? = ""
    dynamic var ImageUrl :String? = ""
    dynamic var Store_Id: Int = -1
    dynamic var IsDeleted: Bool = false
    dynamic var ImageDeletedOnEdit: Bool = false
            var Store : StoreItem? = StoreItem()
    
    override static func primaryKey() -> String? {
        return "Id"
    }
}
