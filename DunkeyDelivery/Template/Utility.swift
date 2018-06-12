//
//  Utility.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftMessages

class Utility {
    
    
    static func resizeImage(image: UIImage,  targetSize: CGFloat) -> UIImage {
        
        guard (image.size.width > 1024 || image.size.height > 1024) else {
            return image;
        }
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newRect: CGRect = CGRect.zero;
        
        if(image.size.width > image.size.height) {
            newRect.size = CGSize(width: targetSize, height: targetSize * (image.size.height / image.size.width))
        } else {
            newRect.size = CGSize(width: targetSize * (image.size.width / image.size.height), height: targetSize)
        }
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    static func thumbnailForVideoAtURL(url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform=true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    
    static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    class func emptyCollectionViewMessage(message:String, viewController: UITableViewCell, collectionView: UICollectionView) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.bounds.size.width, height: viewController.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        collectionView.backgroundView = messageLabel
        
    }
    
    static func registerPushNotification(device_apn: String){
        
        let parameters: Parameters = [
            "DeviceName": "iPhone",
            "UDID": UIDevice.current.identifierForVendor!.uuidString,
            "IsAndroidPlatform": "false",
            "IsPlayStore": "false",
            "SignInType": AppStateManager.sharedInstance.loggedInUser.Role.description,
            "IsProduction": false,
            "User_Id": AppStateManager.sharedInstance.loggedInUser.Id.description,
            "AuthToken": device_apn,
            ]
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            if self.getResponse(result) == "Success"{
                
                print("-> Push notification registered SUCCESSFULLY")
                print(result)
              
            }
        }
        let failureClosure: DefaultAPIFailureClosure = {
            (error) in
            print(error)
            print("-> Push notification registered FAILED")
            
            if(error.code == -1009){
                print("No Internet")
            }
        }
        
        APIManager.sharedInstance.registerPushNotification(parameters: parameters, success:successClosure , failure: failureClosure)
}
    
    
     static func getResponse(_ result: Dictionary<String,AnyObject>) -> String { return result["Message"] as! String }

 
    
    static func showInformationWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .TabView)
        error.configureTheme(.info)
        // error.iconImageView?.image = #imageLiteral(resourceName: "appLogo")
        error.configureIcon(withSize: CGSize(width: 40, height: 40), contentMode: UIViewContentMode.scaleAspectFit )
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
    }
    
    static func convertDateFormatter(date: String, withFormat: String) -> String
    {
        //2018-03-28 06:45:00
       // 2018-03-24 05:36:00
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" //this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        dateFormatter.dateFormat = withFormat ///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        return timeStamp
    }
    
    static func convertTimeIn24(value: String) -> String{
        let dateAsString = value
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        let Date24 = dateFormatter.string(from: date!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    
    static func convertTimeIn12 (value: String) -> String{
        let dateAsString = value
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    static func convertssTimeIn12 (value: String) -> String{
        let dateAsString = value
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "hh:mm a"
        let Date12 = dateFormatter.string(from: date!)
        print("12 hour formatted Date:",Date12)
        return Date12
        /*let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.str
        return time*/
    }
  
    static  func getCurretnDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    static   func getCurrentTime() -> String{
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
