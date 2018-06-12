//
//  PackageItem.swift
//  Template
//
//  Created by Ingic on 06/03/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class PackageItem: Object {
   
  dynamic var  Id: Int = -1
  dynamic var  Name: String? = ""
  dynamic var  Status: Int = -1
  dynamic var  Price: Double = 0
  dynamic var  Description: String? = ""
  dynamic var  IsDeleted: Bool = false
  dynamic var  Store_Id: Int = -1
  dynamic var  ImageUrl: String? = ""
  dynamic var  ImageDeletedOnEdit: Bool = false
          var  Package_Products = List<PackageProduct>()
}

class PackageProduct: Object{
    
    dynamic var  Id: Int = -1
    dynamic var  Qty: String? = ""
    dynamic var  Product_Id: Int = -1
    dynamic var  Package_Id: Int = -1
    dynamic var  PackageProductId: Int = -1
            var  Product : ProductItem? = ProductItem()
}
