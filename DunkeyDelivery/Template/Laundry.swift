//
//  Laundry.swift
//  Template
//
//  Created by Ingic on 26/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Laundry: Object {
    
   dynamic var Id: Int = -1
   dynamic var Name: String? = " "
   dynamic var Description: String? = ""
   dynamic var Status: Int = -1
   dynamic var Store_Id: Int = -1
   dynamic var ParentCategoryId: Int = -1
   dynamic var IsDeleted: Bool = false
   dynamic var ImageUrl: String? = ""
           var Products = List<ProductItem>()
           var Store = RealmOptional<Int>()
           var ImageDeletedOnEdit: Bool = false
    
}


