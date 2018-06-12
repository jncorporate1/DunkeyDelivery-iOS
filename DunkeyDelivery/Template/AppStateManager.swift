//  AppStateManager.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//


import UIKit
import RealmSwift
import AVFoundation
import Photos
import SwiftyJSON

class AppStateManager: NSObject {
    
    
    static let sharedInstance = AppStateManager()
    var loggedInUser: User!
    var selectedAdd : PlaceInfo!
    var userAddress: CLLocationCoordinate2D!
    var cartItems = [ProductItem]()
    var cart = [Cart]()
    var realm: Realm!
    var isUserLoggedInApp : Bool!
    var filterObj : FilterItem!
    var registerUser:User!
    var latitude: Double = 0
    var longitude: Double = 0
    var cuisineObj = [Cuisine] ()
    var settingObj = Setting ()
    var forSelectedItems = [String]()
    
    //Filter param for Alcohol
    var sortBy: String? = ""
    var Country: String? = ""
    var Price: String? = ""
    var Size: String? = ""
    var category = [Category]()
    var parentName: String? = ""
    
    var countryState = [String] ()
    var sizeState  = [String] ()
    var priceState: String = ""
    var sortByState: String = "  Best selling"
    
    //Save Selected Store ID
    var selectedIndex: Int! // class WStoreChangeVC
    var saveSelectedStoreName: String = ""
    
    
    //Delivery Schedule model save
    var deliveryTypes = [DeliverySchedule] ()
    var cartObj: Cart!
    var showPopUp: Bool = true
    var filterSizeArray = [FilterProductSize]()
    
    //Selected type for Winw/Liquor = 0 and for beer = 1
    var filterTypeID = -1
    
    
    override init() {
        
        super.init()
        
        if(!(realm != nil)){
            realm = try! Realm()
        }
        
        loggedInUser = realm.objects(User.self).first
        for object in realm.objects(Cart.self){
            cart.append(object)
        }
    }
    
    func clearFilterData(){
        self.filterObj = nil
    }
    
    
    //Check delivery Schelude is already insert or not
    func showDeliveryPopUp(storeID: Int) -> Bool {
        self.cart =  self.getCartItems()
        if cart.count > 0{
        for items in cart{
            if items.scheduleTime.Store_Id == storeID {
                    showPopUp  = false
                }
                else{
                    showPopUp = true
                }
            }
            return showPopUp
        }
         showPopUp = true
         return showPopUp
    }
    
    func addCartItems(product: ProductItem, scheduleDelivery: DeliverySchedule){
       self.cart =  self.getCartItems()
        for item in cart{
            if item.storeId == product.Store_id{
                for obj in item.products{
                    if obj.Id == product.Id{
                        try! realm.write() {
                            obj.quantity += product.quantity
                            realm.add(cart, update: true)
                        }
                        return
                    }
                }
                try! realm.write() {
                    item.products.append(product)
                    realm.add(cart, update: true)
                }
                return
            }
            
        }
        let item = Cart()
        item.storeId = product.Store_id
        item.storeName = product.BusinessName
        item.minOrderPrice = product.MinOrderPrice.value!
        item.minDeliveryTime = Int(product.MinDeliveryTime.value!)
        item.minDeliveryCharges = product.MinOrderPrice.value!
        item.businessType = product.BusinessType
        item.scheduleTime = scheduleDelivery
        item.totalPrice = product.MinOrderPrice.value!
        item.products.append(product)
        try! realm.write() {
            cart.append(item)
            realm.add(cart, update: true)
        }
    }
    
    func getStoreSchedule(storeId: Int)-> DeliverySchedule{
        self.cart =  self.getCartItems()
        for item in cart{
            if item.storeId == storeId{
                if item.scheduleTime != nil {
                return item.scheduleTime
                }else{
                    return DeliverySchedule()
                }
            }
        }
        return DeliverySchedule()
    }
    
    
   func addCartItems(product: ProductItem){
        self.cart =  self.getCartItems()
        for item in cart{
            if item.storeId == product.Store_id{
                for obj in item.products{
                    if obj.Id == product.Id{
                        try! realm.write() {
                            obj.quantity += product.quantity
                            realm.add(cart, update: true)
                        }
                        return
                    }
                }
                try! realm.write() {
                    item.products.append(product)
                    realm.add(cart, update: true)
                }
                return
            }
        }
        let item = Cart()
        item.storeId = product.Store_id
        item.storeName = product.BusinessName
        item.minOrderPrice = product.MinOrderPrice.value!
        item.minDeliveryTime = Int(product.MinDeliveryTime.value!)
        item.minDeliveryCharges = product.MinOrderPrice.value!
        item.businessType = product.BusinessType
        item.products.append(product)
        try! realm.write() {
            cart.append(item)
            realm.add(cart, update: true)
        }
    }
    

    func isStoreExsists(storeId: Int)->Bool{
        self.cart =  self.getCartItems()
        for item in cart{
            if item.storeId == storeId{
             return false
            }
        }
        return true
    }
    
    
    func addMultipleItemsToCart(products: [ProductItem]){
        for product in products{
            self.addCartItems(product: product)
        }
    }
    
    ///NEW FOR DeliverySchedule
    func addMultipleItemsToCart(products: [ProductItem], scheduleDelivery: DeliverySchedule){
        for product in products{
            self.addCartItems(product: product, scheduleDelivery: scheduleDelivery)
        }
    }
    
    
    func getCartItems()-> [Cart]{
        var cartItems = [Cart]()
        for object in realm.objects(Cart.self){
            
            if !(object.isInvalidated){
                let obj = Cart(value:object)
                cartItems.append(obj)
            }
        }
        return cartItems
    }
    
    func getCartDic()-> [NSDictionary]{
        var cartItems = [NSDictionary]()
        var products = [NSDictionary]()
        for object in realm.objects(Cart.self){
            if !(object.isInvalidated){
                let item = object.toDictionary()
                for product in object.products{
                    let item = product.toDictionary()
                    //cartItems["products"]
                }
                cartItems.append(item)
            }
        }
        return cartItems
    }
    
    func setUserAddress(){
        if self.selectedAdd != nil{
        }
    }
    
    func changeRootViewController(){
        let appDelagate = UIApplication.shared.delegate as! AppDelegate
        appDelagate.changeRootViewController()
    }
    
    func markUserLogout(){
        try!  self.realm.write(){
            self.realm.delete(self.loggedInUser)
            self.realm.deleteAll()
            self.loggedInUser = nil
            self.cart.removeAll()
            self.isUserLoggedInApp = false
            //self.cartItems.removeAll()
            self.changeRootViewController()
        }
    }
    
    func isUserLoggedIn() -> Bool{
        
        if (self.loggedInUser) != nil {
            if self.loggedInUser.isInvalidated {
                return false
            }
            return true
        }
        else if (isUserLoggedInApp == true) {
            return true
        }
        else{
            return false
        }
    }
    
    func askCameraPermission(){
        let mediaType = AVMediaTypeVideo
        AVCaptureDevice.requestAccess(forMediaType: mediaType) {
            (granted) in
            if granted == true {
                print("Granted access to \(mediaType)" )
            } else {
                print("Not granted access to \(mediaType)")
                self.showPermissionView()
            }
        }
    }
    
    func askMediaPermission(){
        PHPhotoLibrary.requestAuthorization({
            granted in
            if granted == PHAuthorizationStatus.denied{
                print("Not granted access ")
            }
            else{
                print("Granted access ")
                self.showPermissionView()
            }
        })
    }
    
    func showPermissionView(){
        let rootViewcontroller = UIApplication.shared.keyWindow?.rootViewController
        let splash = UIStoryboard(name: "LoginModule", bundle: nil).instantiateViewController(withIdentifier: "SXsplashPermission")
        rootViewcontroller?.present(splash, animated: false, completion: nil)
    }
    
    func clearCartData(){
        try!  self.realm.write(){
            for item in self.cart{
            let toBeDeleted = AppStateManager.sharedInstance.realm.objects(Cart.self).first(where: {$0.storeId == item.storeId})
            self.realm.delete(toBeDeleted!)
            realm?.refresh()
                self.cart.removeAll()
            }
        }
    }
}
