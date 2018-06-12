//
//  SocialLogin.swift
//  Template
//
//  Created by Muhammad Zaheer on 29/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import UIKit
import RealmSwift
import Alamofire
import CoreLocation
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class SocailLogin:NSObject, GIDSignInUIDelegate, GIDSignInDelegate{

    static let sharedInstance = SocailLogin()

    func googleSetUp(){
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK:- FaceBookSign-In Method
    
    func facebookLoginSetUp(controller: UIViewController) {
        
        let loginManager = LoginManager()
        do{
            loginManager.logIn(readPermissions: [ .publicProfile,.email], viewController: controller){
                loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let accessToken):
                    if((FBSDKAccessToken.current()) != nil){
                        
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                              let  dict = result as! [String : AnyObject]
                                print(result!)
                                print(dict)
                                print(accessToken.token)
                               
                            }})}}}}
        catch {
            print(error.localizedDescription)
        }
    }
    
    
    
    //MARK:-  GoogleSign-In Delegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        }
        else {
            
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            print("UserID:\(String(describing: userId)),\n Token:\(String(describing: idToken)),\n Fullname\(String(describing: fullName)),\n Name:\(String(describing: givenName)),\n Describing:\(String(describing: familyName)),\n Email:\(String(describing: email)),")
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(user)
        print(error)
    }
    
}

