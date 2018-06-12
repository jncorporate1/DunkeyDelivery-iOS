//
//  DeliveryManagerAPI.swift
//  Template
//
//  Created by Ingic on 8/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DeliveryManagerAPI: APIManagerBase {
    
    
    
    func startStreamWith(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.post.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func getStreamWithLimit(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = URLforRoute(route: Route.get.rawValue,params: parameters)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getHomeCategory(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        let catId = Route.homeCategory.rawValue.replacingOccurrences(of: "{Category_id}", with: parameters["catId"] as! String)
        let latParam = catId.replacingOccurrences(of: "{Lat}", with: parameters["lat"] as! String)
        let lngParam = latParam.replacingOccurrences(of: "{Lng}", with: parameters["lng"] as! String)
        let route: URL = GETURLfor(route: lngParam)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getCategoryDetail(parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        let catId = Route.categoryDetail.rawValue.replacingOccurrences(of: "{store_id}", with: parameters["store_id"] as! String)
        let latParam = catId.replacingOccurrences(of: "{page_no}", with: parameters["page_no"] as! String)
        let lngParam = latParam.replacingOccurrences(of: "{num_items}", with: parameters["num_items"] as! String)
        let route: URL = GETURLfor(route: lngParam)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func forgotPassword(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        let forPass = Route.forgotPasswordWithEmail.rawValue.replacingOccurrences(of: "{Email}", with: parameters["email"] as! String)
        let route: URL = GETURLfor(route: forPass)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func changePasswordMobile(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.changePasswordMobile.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func editProfile(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.editProfile.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func addCreditCard(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.addCreditCard.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func getUserCreditCards(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getUserCreditCards.rawValue.replacingOccurrences(of: "{User_id}", with: parameters["user_id"] as! String)
        let route: URL = GETURLfor(route: userId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    
    func editUserCreditCard(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.editUserCreditCard.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func addAddress(parameters: Parameters,
                    success:@escaping DefaultArrayResultAPISuccessClosure,
                    failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.addAddress.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func getUserAddress(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getUserAddress.rawValue.replacingOccurrences(of: "{User_id}", with: parameters["user_id"] as! String)
        let route: URL = GETURLfor(route: userId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    
    func editUserAddress(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.editUserAddress.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func rideRegister(parameters: Parameters,
                      success:@escaping DefaultArrayResultAPISuccessClosure,
                      failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.rideRegister.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func submitContactUs(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.emailUs.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func getCartMobile(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.getCartMobile.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func insertOrder(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.insertOrder.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    
    func getExternalLogin(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.externalLogin.rawValue.replacingOccurrences(of: "{userId}", with: parameters["userId"] as! String)
        let accessToken = userId.replacingOccurrences(of: "{accessToken}", with: parameters["accessToken"] as! String)
        let loginType = accessToken.replacingOccurrences(of: "{socialLoginType}", with: parameters["socialLoginType"] as! String)
        let urlString : NSString = loginType.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let route: URL = GETURLfor(route: urlString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func removeAddress(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        let address_id = Route.removeAddress.rawValue.replacingOccurrences(of: "{address_id}", with: parameters["address_id"] as! String)
        let user_Id = address_id.replacingOccurrences(of: "{User_Id}", with: parameters["User_Id"] as! String)
        let urlString : NSString = user_Id.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let route: URL = GETURLfor(route: urlString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func removeCreditCard(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        let card_Id = Route.removeCreditCard.rawValue.replacingOccurrences(of: "{Card_Id}", with: parameters["Card_Id"] as! String)
        let user_Id = card_Id.replacingOccurrences(of: "{User_Id}", with: parameters["User_Id"] as! String)
        let urlString : NSString = user_Id.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let route: URL = GETURLfor(route: urlString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getUpdateUserAddress(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.updateUserAddressById.rawValue.replacingOccurrences(of: "{User_id}", with: parameters["User_id"] as! String)
        let addressId = userId.replacingOccurrences(of: "{Address_Id}", with: parameters["Address_Id"] as! String)
        let urlString : NSString = addressId.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let route: URL = GETURLfor(route: urlString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getUpdateUserCreditCard(parameters: Parameters,
                                 success:@escaping DefaultArrayResultAPISuccessClosure,
                                 failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getUpdateUserCreditCard.rawValue.replacingOccurrences(of: "{User_id}", with: parameters["User_id"] as! String)
        let creditId = userId.replacingOccurrences(of: "{Creditcard_Id}", with: parameters["Creditcard_Id"] as! String)
        let mark = creditId.replacingOccurrences(of: "{Mark}", with:parameters["Mark"] as! String)
        let urlString : NSString = mark.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        let route: URL = GETURLfor(route: urlString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getCategoryProduct(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        let catId = Route.categoryProduct.rawValue.replacingOccurrences(of: "{Category_Id}", with: parameters["Category_Id"] as! String)
        let latParam = catId.replacingOccurrences(of: "{page_no}", with: parameters["page_no"] as! String)
        let lngParam = latParam.replacingOccurrences(of: "{num_items}", with: parameters["num_items"] as! String)
        let route: URL = GETURLfor(route: lngParam)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getStoreInfo(parameters: Parameters,
                      success:@escaping DefaultArrayResultAPISuccessClosure,
                      failure:@escaping DefaultAPIFailureClosure){
        let strId = Route.storeInfo.rawValue.replacingOccurrences(of: "{storeId}", with: parameters["storeId"] as! String)
        
        let route: URL = GETURLfor(route: strId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getMedicationValues(parameters: Parameters,
                             success:@escaping DefaultArrayResultAPISuccessClosure,
                             failure:@escaping DefaultAPIFailureClosure){
        let storeIdParam = Route.medicationValues.rawValue.replacingOccurrences(of: "{Store_id}", with: parameters["Store_id"] as! String)
        let searchValueParam = storeIdParam.replacingOccurrences(of: "{search_string}", with: parameters["search_string"] as! String)
        let cleanString = searchValueParam.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let route: URL = GETURLfor(route: cleanString!)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getRewardPrizes(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getRewardPrizes.rawValue.replacingOccurrences(of: "{UserID}", with: parameters["UserID"] as! String)
        let route: URL = GETURLfor(route: userId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func redeemPrize(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.redeemPrize.rawValue.replacingOccurrences(of: "{UserID}", with: parameters["UserID"] as! String)
        let rewardId = userId.replacingOccurrences(of: "{RewardID}", with: parameters["RewardID"] as! String)
        let route: URL = GETURLfor(route: rewardId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getOrdersHistory(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getOrdersHistory.rawValue.replacingOccurrences(of: "{UserID}", with: parameters["UserID"] as! String)
        let signInType = userId.replacingOccurrences(of: "{SignInType}", with: parameters["SignInType"] as! String)
        let currentOrder = signInType.replacingOccurrences(of: "{IsCurrentOrder}", with: parameters["IsCurrentOrder"] as! String)
        let pageSize = currentOrder.replacingOccurrences(of: "{PageSize}", with: parameters["PageSize"] as! String)
        let pageNo = pageSize.replacingOccurrences(of: "{PageNo}", with: parameters["PageNo"] as! String)
        let route: URL = GETURLfor(route: pageNo)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getAlcoholHomeScreen(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        let page = Route.alcoholHomeScreen.rawValue.replacingOccurrences(of: "{latitude}", with: parameters["latitude"] as! String)
        let item1 = page.replacingOccurrences(of: "{longitude}", with: parameters["longitude"] as! String)
        let item2 = item1.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let item3 = item2.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let item4 = item3.replacingOccurrences(of: "{Store_Ids}", with: parameters["Store_Ids"] as! String)
        let route: URL = GETURLfor(route: item4)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    
    func alcoholStoreCategoryDetail(parameters: Parameters,
                                    success:@escaping DefaultArrayResultAPISuccessClosure,
                                    failure:@escaping DefaultAPIFailureClosure){
        
        
        let page = Route.alcoholStoreCategoryDetail.rawValue.replacingOccurrences(of: "{Store_Id}", with: parameters["Store_Id"] as! String)
        var item1 = page.replacingOccurrences(of: "{Category_Id}", with: parameters["Category_Id"] as! String)
        
        if (parameters["Category_ParentId"] as! String) != ""
        {
            item1 += "&Category_ParentId=" +  (parameters["Category_ParentId"] as! String)
        }
        
        if (parameters["CategoryName"] as! String) != ""
        {
            item1 += "&CategoryName=" +  (parameters["CategoryName"] as! String)
        }
        
        if (parameters["Page"] as! String) != ""
        {
            item1 += "&Page=" +  (parameters["Page"] as! String)
        }
        
        if (parameters["Items"] as! String) != ""
        {
            item1 += "&Items=" +  (parameters["Items"] as! String)
        }
        
        let route: URL = GETURLfor(route: item1)!
        
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    
    
    func alcoholFilterStore(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        let page = Route.alcoholFilterStore.rawValue.replacingOccurrences(of: "{latitude}", with: parameters["latitude"] as! String)
        let item1 = page.replacingOccurrences(of: "{longitude}", with: parameters["longitude"] as! String)
        let item2 = item1.replacingOccurrences(of: "{SortBy}", with: parameters["SortBy"] as! String)
        let item3 = item2.replacingOccurrences(of: "{Country}", with: parameters["Country"] as! String)
        let item4 = item3.replacingOccurrences(of: "{Price}", with: parameters["Price"] as! String)
        let item5 = item4.replacingOccurrences(of: "{ProductNetWeight}", with: parameters["ProductNetWeight"] as! String)
        let cleanString = item5.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let route: URL = GETURLfor(route: cleanString!)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getChangeAlcoholStore(parameters: Parameters,
                               success:@escaping DefaultArrayResultAPISuccessClosure,
                               failure:@escaping DefaultAPIFailureClosure){
        
        let page = Route.changeAlcoholStore.rawValue.replacingOccurrences(of: "{latitude}", with: parameters["latitude"] as! String)
        let item1 = page.replacingOccurrences(of: "{longitude}", with: parameters["longitude"] as! String)
        let item2 = item1.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let item3 = item2.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let item4 = item3.replacingOccurrences(of: "{Type}", with: parameters["Type"] as! String)
        let route: URL = GETURLfor(route: item4)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getProductByName(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        let page = Route.getProductByName.rawValue.replacingOccurrences(of: "{search_string}", with: parameters["search_string"] as! String)
        let item3 = page.replacingOccurrences(of: "{Store_id}", with: parameters["Store_id"] as! String)
        let item4 = item3.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let item5 = item4.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let route: URL = GETURLfor(route: item5)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getGernalProductByName(parameters: Parameters,
                                success:@escaping DefaultArrayResultAPISuccessClosure,
                                failure:@escaping DefaultAPIFailureClosure){
        
        let page = Route.getGernalProductByName.rawValue.replacingOccurrences(of: "{search_string}", with: parameters["search_string"] as! String)
        let item1 = page.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let item2 = item1.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let route: URL = GETURLfor(route: item2)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    func submitPharmacyRequest(parameters: Parameters,
                               success:@escaping DefaultArrayResultAPISuccessClosure,
                               failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.submitPharmacyRequest.rawValue)!
        
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
        
    }
    func getLaundryParentCategory(parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        let store_id = Route.laundryParentCategory.rawValue.replacingOccurrences(of: "{Store_id}", with: parameters["Store_id"] as! String)
        let page = store_id.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let item = page.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let route: URL = GETURLfor(route: item)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    
    
    func getCategoryItems(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        let store_id = Route.getCategoryItems.rawValue.replacingOccurrences(of: "{Store_id}", with: parameters["Store_id"] as! String)
        let parentCategory_id = store_id.replacingOccurrences(of: "{ParentCategory_id}", with: parameters["ParentCategory_id"] as! String)
        let page = parentCategory_id.replacingOccurrences(of: "{Page}", with: parameters["Page"] as! String)
        let item = page.replacingOccurrences(of: "{Items}", with: parameters["Items"] as! String)
        let route: URL = GETURLfor(route: item)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    
    func getSettings(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        let routeString = Route.setting.rawValue
        let route: URL = GETURLfor(route: routeString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    func requestGetClothes(parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL = POSTURLforRoute(route: Route.requestGetColthes.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func getCuisine(parameters: Parameters,
                    success:@escaping DefaultArrayResultAPISuccessClosure,
                    failure:@escaping DefaultAPIFailureClosure){
        let routeString = Route.cusinie.rawValue
        let route: URL = GETURLfor(route: routeString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    
    
    func getStoreFilters(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        let CategoryName = Route.filterStore.rawValue.replacingOccurrences(of: "{CategoryName}", with: parameters["CategoryName"] as! String)
        let storeBy = CategoryName.replacingOccurrences(of: "{SortBy}", with: parameters["SortBy"] as! String)
        let rating = storeBy.replacingOccurrences(of: "{Rating}", with: parameters["Rating"] as! String)
        let minDeliveryTime = rating.replacingOccurrences(of: "{MinDeliveryTime}", with: parameters["MinDeliveryTime"] as! String)
        let priceRanges = minDeliveryTime.replacingOccurrences(of: "{PriceRanges}", with: parameters["PriceRanges"] as! String)
        let minDeliveryCharges = priceRanges.replacingOccurrences(of: "{MinDeliveryCharges}", with: parameters["MinDeliveryCharges"] as! String)
        let isSpecial = minDeliveryCharges.replacingOccurrences(of: "{IsSpecial}", with: parameters["IsSpecial"] as! String)
        let isFreeDelivery = isSpecial.replacingOccurrences(of: "{IsFreeDelivery}", with: parameters["IsFreeDelivery"] as! String)
        let isNewRestaurants = isFreeDelivery.replacingOccurrences(of: "{IsNewRestaurants}", with: parameters["IsNewRestaurants"] as! String)
        let cuisines = isNewRestaurants.replacingOccurrences(of: "{Cuisines}", with: parameters["Cuisines"] as! String)
        let latitude = cuisines.replacingOccurrences(of: "{latitude}", with: parameters["latitude"] as! String)
        let longitude = latitude.replacingOccurrences(of: "{longitude}", with: parameters["longitude"] as! String)
        let route: URL = GETURLfor(route: longitude)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
        
    }
    func getOfferPackage(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        let routeString = Route.getOfferPackage.rawValue
        let route: URL = GETURLfor(route: routeString as String)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    
    func googlePlacesAPI(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        let apiRoute = "geocode/json?address={search_string}&key={api_key}"
        
        let storeIdParam = apiRoute.replacingOccurrences(of: "{search_string}", with: parameters["search_string"] as! String)
        let searchValueParam = storeIdParam.replacingOccurrences(of: "{api_key}", with: parameters["api_key"] as! String)
        let route: URL = GETURLforGoogleAPI(route: searchValueParam)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
  //  http://maps.googleapis.com/maps/api/geocode/json?latlng=33.5208204,73.1580938&sensor=false
    func googlePlacesAPIReverse(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        let apiRoute = "geocode/json?latlng={latlng}&sensor={sensor}"
        
        let storeIdParam = apiRoute.replacingOccurrences(of: "{latlng}", with: parameters["latlng"] as! String)
        let searchValueParam = storeIdParam.replacingOccurrences(of: "{sensor}", with: parameters["sensor"] as! String)
        let route: URL = GETURLforGoogleAPI(route: searchValueParam)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func gmailLogin(parameters: Parameters,
                    success:@escaping DefaultArrayResultAPISuccessClosure,
                    failure:@escaping DefaultAPIFailureClosure){
        let route: URL = POSTURLforRoute(route: Route.gmailLogin.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func registerPushNotification(parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        
        let route: URL =  POSTURLforRoute(route: Route.registerPushNotification.rawValue)!
        self.postRequestWith(route: route, parameters: parameters, success: success, failure: failure)
    }
    
    func getAlcoholSubFilters(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        let sortBy = Route.alcoholSubFilters.rawValue.replacingOccurrences(of: "{SortBy}", with: parameters["SortBy"] as! String)
        let country = sortBy.replacingOccurrences(of: "{Country}", with: parameters["Country"] as! String)
        let price = country.replacingOccurrences(of: "{Price}", with: parameters["Price"] as! String)
        let size = price.replacingOccurrences(of: "{Size}", with: parameters["Size"] as! String)
        let typeId = size.replacingOccurrences(of: "{Type_Id}", with: parameters["Type_Id"] as! String)
        let parentName = typeId.replacingOccurrences(of: "{ParentName}", with: parameters["ParentName"] as! String)
        let proNetWeight = parentName.replacingOccurrences(of: "{ProductNetWeight}", with: parameters["ProductNetWeight"] as! String)
        let cleanString = proNetWeight.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let route: URL = GETURLfor(route: cleanString!)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    func getOrderNotification(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        let userId = Route.getOrderNotification.rawValue.replacingOccurrences(of: "{UserId}", with: parameters["UserId"] as! String)
        let orderId = userId.replacingOccurrences(of: "{OrderId}", with: parameters["OrderId"] as! String)
        let storeOrderId = orderId.replacingOccurrences(of: "{StoreOrder_Id}", with: parameters["StoreOrder_Id"] as! String)
        let signType = storeOrderId.replacingOccurrences(of: "{SignInType}", with: parameters["SignInType"] as! String)
        let isCurrentOrder = signType.replacingOccurrences(of: "{IsCurrentOrder}", with: parameters["IsCurrentOrder"] as! String)
        let pageSize = isCurrentOrder.replacingOccurrences(of: "{PageSize}", with: parameters["PageSize"] as! String)
        let pageNo = pageSize.replacingOccurrences(of: "{PageNo}", with: parameters["PageNo"] as! String)
        let route: URL = GETURLfor(route: pageNo )!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
    
    
    func getStoreSchedule(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        let storeId = Route.getSchedule.rawValue.replacingOccurrences(of: "{Store_Id}", with: parameters["Store_Id"] as! String)
        let route: URL = GETURLfor(route: storeId)!
        self.getRequestWith(route: route, parameters: [:], success: success, failure: failure)
    }
}
