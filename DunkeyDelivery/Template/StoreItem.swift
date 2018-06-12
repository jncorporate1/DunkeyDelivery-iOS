//
//  Store.swift
//  Template
//
//  Created by Ingic on 8/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import RealmSwift

class  StoreItem: Object {
    
    dynamic var Id = -1
    dynamic var BusinessType:String!
    dynamic var Description:String!
    dynamic var BusinessName:String!
    dynamic var Latitude: NSNumber = 0.0
    dynamic var Longitude: NSNumber = 0.0
    dynamic var Open_From: String?
    dynamic var Open_To: String?
    dynamic var AverageRating : NSNumber = 0.0
    dynamic var ImageUrl:String!
    dynamic var Address: String!
    dynamic var Distance: NSNumber = 0.0
    dynamic var ContactNumber: String!
    dynamic var StoreDeliveryHours : deliveryHours?
    dynamic var IsDeleted: Bool = false
    dynamic var Location: Locations!
    dynamic var RatingType: Ratting!
    dynamic var ImageDeletedOnEdit: Bool = false
    dynamic var BusinessTypeTax : Double = 0.0
            var Categories = List<Category>()
            var storeTags = List<StoreTags>()
            var MinOrderPrice = RealmOptional<Double> ()
            var MinDeliveryTime = RealmOptional<Int> ()
            var MinDeliveryCharges = RealmOptional<Double> ()
            var StoreDeliveryTypes = List<DeliverySchedule> ()
    override static func primaryKey() -> String? {
        return "Id"
    }
}

class StoreRating: Object {
    dynamic var DateOfRating: String!
    dynamic var Feedback:String!
    dynamic var Id = -1
    dynamic var Store_Id = -1
    dynamic var Rating = -1
    dynamic var User:User!
}

class Locations: Object {
    dynamic var Geography : GeographyCoordinate!
}

class GeographyCoordinate: Object {
        dynamic var CoordinateSystemId: Int = -1
        dynamic var WellKnownText: String? = ""
}


class Ratting: Object {
       dynamic var FiveStar: Int = -1
       dynamic var FourStar: Int = -1
       dynamic var ThreeStar:Int = -1
       dynamic var TwoStar: Int = -1
       dynamic var OneStar: Int = -1
       dynamic var TotalRatings: Int = -1
}


class Category: Object {
  dynamic var  Id: Int = -1
  dynamic var  Name: String? = ""
  dynamic var  Description: String? = ""
  dynamic var  Status:  Int = -1
  dynamic var  Store_Id:  Int = -1
  dynamic var  ParentCategoryId:  Int = -1
  dynamic var  IsDeleted: Bool = false
  dynamic var  ImageUrl: String? = ""
          var  Products = List <ProductItem> ()
  dynamic var  ImageDeletedOnEdit: Bool = false
}

class Categories : Object{
    var Wine = List<Category> ()
    var Liquor = List<Category> ()
    var Beer = List<Category> ()
}

class ProductsArray: Object {
    var Categories : Categories!
    var Products = List <ProductItem> ()
    dynamic var IsLast : Bool = false
}

