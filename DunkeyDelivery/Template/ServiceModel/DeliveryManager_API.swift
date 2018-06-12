//
//  DeliveryManager_API.swift
//  Template
//
//  Created by Ingic on 8/28/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Alamofire
extension APIManager{
    
    
    func startStreamWith(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.startStreamWith(parameters: parameters, success: success, failure: failure)
        
    }
    
    func getStreamWithLimit(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getStreamWithLimit(parameters: parameters, success: success, failure: failure)
        
    }
    func getHomeCategory(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getHomeCategory(parameters: parameters, success: success, failure: failure)
        
    }
    func getCategoryDetail(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getCategoryDetail(parameters: parameters, success: success, failure: failure)
        
    }
    func forgotPassword(parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.forgotPassword(parameters: parameters, success: success, failure: failure)
        
    }
    func changePasswordMobile(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.changePasswordMobile(parameters: parameters, success: success, failure: failure)
        
    }
    func editProfile(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.editProfile(parameters: parameters, success: success, failure: failure)
        
    }
    func addCreditCard(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.addCreditCard(parameters: parameters, success: success, failure: failure)
        
    }
    func getCreditCards(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getUserCreditCards(parameters: parameters, success: success, failure: failure)
        
    }
    func getCategoryProduct(parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getCategoryProduct(parameters: parameters, success: success, failure: failure)
        
    }
    func getStoreInfo(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getStoreInfo(parameters: parameters, success: success, failure: failure)
        
    }
    func addAddress(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.addAddress(parameters: parameters, success: success, failure: failure)
        
    }
    func getUserAddress(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getUserAddress(parameters: parameters, success: success, failure: failure)
    }
    func getExternalLogin(parameters: Parameters,
                        success:@escaping DefaultArrayResultAPISuccessClosure,
                        failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getExternalLogin(parameters: parameters, success: success, failure: failure)
    }
    func removeAddress(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.removeAddress(parameters: parameters, success: success, failure: failure)
    }
    func removeCreditCard(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.removeCreditCard(parameters: parameters, success: success, failure: failure)
    }
    func editUserCreditCard(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.editUserCreditCard(parameters: parameters, success: success, failure: failure)
    }
    func editUserAddress(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.editUserAddress(parameters: parameters, success: success, failure: failure)
    }
    func rideRegister(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.rideRegister(parameters: parameters, success: success, failure: failure)
    }
    func submitContactUs(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.submitContactUs(parameters: parameters, success: success, failure: failure)
    }
    
    func getCartMobile(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getCartMobile(parameters: parameters, success: success, failure: failure)
    }
    func insertOrder(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.insertOrder(parameters: parameters, success: success, failure: failure)
    }
    func getUpdateUserAddress(parameters: Parameters,
                       success:@escaping DefaultArrayResultAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getUpdateUserAddress(parameters: parameters, success: success, failure: failure)
    }
    
    
    func getUpdateUserCreditCard(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getUpdateUserCreditCard(parameters: parameters, success: success, failure: failure)
    }
    func getMedicationValues(parameters: Parameters,
                            success:@escaping DefaultArrayResultAPISuccessClosure,
                            failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getMedicationValues(parameters: parameters, success: success, failure: failure)
        
    }
    
    func getRewardPrizes(parameters: Parameters,
                             success:@escaping DefaultArrayResultAPISuccessClosure,
                             failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getRewardPrizes(parameters: parameters, success: success, failure: failure)
    }
    func redeemPrize(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.redeemPrize(parameters: parameters, success: success, failure: failure)
    }
    func getOrdersHistory(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getOrdersHistory(parameters: parameters, success: success, failure: failure)
    }
    
    func getAlcoholHomeScreen(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getAlcoholHomeScreen(parameters: parameters, success: success, failure: failure)
    }
    
    
    func alcoholStoreCategoryDetail(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.alcoholStoreCategoryDetail(parameters: parameters, success: success, failure: failure)
    }
    
    func alcoholFilterStore(parameters: Parameters,
                                    success:@escaping DefaultArrayResultAPISuccessClosure,
                                    failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.alcoholFilterStore(parameters: parameters, success: success, failure: failure)
    }
    
    func getChangeAlcoholStore(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getChangeAlcoholStore(parameters: parameters, success: success, failure: failure)
    }
    
    func submitPharmacyRequest(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.submitPharmacyRequest(parameters: parameters, success: success, failure: failure)
    }
    
    func getProductByName(parameters: Parameters,
                               success:@escaping DefaultArrayResultAPISuccessClosure,
                               failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getProductByName(parameters: parameters, success: success, failure: failure)
    }
    
    func getGernalProductByName(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getGernalProductByName(parameters: parameters, success: success, failure: failure)
    }
    func getLaundryParentCategory(parameters: Parameters,
                                success:@escaping DefaultArrayResultAPISuccessClosure,
                                failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getLaundryParentCategory(parameters: parameters, success: success, failure: failure)
    }
    
    func getCategoryItems(parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getCategoryItems(parameters: parameters, success: success, failure: failure)
    }
    
    func requestGetClothes(parameters: Parameters,
                          success:@escaping DefaultArrayResultAPISuccessClosure,
                          failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.requestGetClothes(parameters: parameters, success: success, failure: failure)
    }
    
    func getSettings(parameters: Parameters,
                           success:@escaping DefaultArrayResultAPISuccessClosure,
                           failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getSettings(parameters: parameters, success: success, failure: failure)
    }
    
    func getCuisine(parameters: Parameters,
                     success:@escaping DefaultArrayResultAPISuccessClosure,
                     failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getCuisine(parameters: parameters, success: success, failure: failure)
    }
    
    func getStoreFilters(parameters: Parameters,
                    success:@escaping DefaultArrayResultAPISuccessClosure,
                    failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getStoreFilters(parameters: parameters, success: success, failure: failure)
    }
    
    func getOfferPackage(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getOfferPackage(parameters: parameters, success: success, failure: failure)
    }


    func googlePlacesAPI(parameters: Parameters,
                             success:@escaping DefaultArrayResultAPISuccessClosure,
                             failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.googlePlacesAPI(parameters: parameters, success: success, failure: failure)
        
    }
    
    func googlePlacesAPIReverse(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.googlePlacesAPIReverse(parameters: parameters, success: success, failure: failure)
        
    }
    
    func gmailLogin(parameters: Parameters,
                         success:@escaping DefaultArrayResultAPISuccessClosure,
                         failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.gmailLogin(parameters: parameters, success: success, failure: failure)
        
    }
    
    func registerPushNotification(parameters: Parameters,
                    success:@escaping DefaultArrayResultAPISuccessClosure,
                    failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.registerPushNotification(parameters: parameters, success: success, failure: failure)
    }
    
    
    func getAlcoholSubFilters(parameters: Parameters,
                                  success:@escaping DefaultArrayResultAPISuccessClosure,
                                  failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getAlcoholSubFilters(parameters: parameters, success: success, failure: failure)
    }
    
    
    func getOrderNotification(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getOrderNotification(parameters: parameters, success: success, failure: failure)
    }
    
    func getStoreSchedule(parameters: Parameters,
                              success:@escaping DefaultArrayResultAPISuccessClosure,
                              failure:@escaping DefaultAPIFailureClosure){
        
        deliveryManagerAPI.getStoreSchedule(parameters: parameters, success: success, failure: failure)
    }
    
}
