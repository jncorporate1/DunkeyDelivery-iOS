////  AppDelegate.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import Stripe
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var HomeVC : UITabBarController! = nil
    var isOrderScreen = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(
            schemaVersion: 1,  // Must be greater than previous version
            migrationBlock: { migration, oldSchemaVersion in
                print("Realm migration did run")  // Log to know migration was executed
        })
        Realm.Configuration.defaultConfiguration = config
        AppStateManager.sharedInstance.isUserLoggedInApp = false
        UITabBar.appearance().tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
        changeRootViewController()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        _ = DDAccountViewController(nibName: nil, bundle: nil)
        let userDefaults = UserDefaults.standard
        userDefaults.set("home", forKey: "sideMenu")
        userDefaults.synchronize()
        registerForPushNotifications()
        GIDSignIn.sharedInstance().clientID = "281033186251-ivjjdpj5ojkevlueja9ef6flrrnivn2l.apps.googleusercontent.com"
        STPPaymentConfiguration.shared().publishableKey = "pk_live_MsAqhQ7Y6vi9tnQbJJBfNVEe"//"pk_test_u58ujQ6huY9lQA5GzNhWiVQR" 
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        if url.scheme != nil && url.scheme!.hasPrefix("com.googleusercontent.apps.281033186251-ivjjdpj5ojkevlueja9ef6flrrnivn2l"){
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?,
                                                     annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
            
        else if url.scheme != nil && url.scheme!.hasPrefix("fb1931662216845980"){
            return  FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String? , annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        return false
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: (settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })
        }
    }
    
    
    //MARK: - Notification Method
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        UserDefaults.standard.set(deviceTokenString, forKey: "apns_token")
    }
    
    // Called when APNs failed to register the device for push notifications
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    // Push notification received
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        
        var aps = data["aps"] as! Dictionary<String, Any>
        
        if let alert = aps["alert"] as? Dictionary<String, String>{
            Utility.showInformationWith(message: alert["body"]!)
            var id = data["notification"] as! Dictionary<String, Any>
            let orderID = id["EntityId"] as! String
            let array = orderID.components(separatedBy: ",")
            UserDefaults.standard.set(array[0], forKey: "orderID")
            UserDefaults.standard.set(array[1], forKey: "orderStoreID")
            self.isOrderScreen = true
            self.goToOrderDetailScreen()
        }
        else{
            Utility.showInformationWith(message: aps["alert"] as! String)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var aps = userInfo["aps"] as! Dictionary<String, Any>
        
        if let alert = aps["alert"] as? Dictionary<String, String>{
            //  Utility.showInformationWith(message: alert["body"]!)
            var id = userInfo["notification"] as! Dictionary<String, Any>
            let orderID = id["EntityId"] as! String
            let array = orderID.components(separatedBy: ",")
            UserDefaults.standard.set(array[0], forKey: "orderID")
            UserDefaults.standard.set(array[1], forKey: "orderStoreID")
            self.isOrderScreen = true
            self.goToOrderDetailScreen()
        }
        else{
            // Utility.showInformationWith(message: aps["alert"] as! String)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    
    func getHomeInstance() -> UITabBarController {
        let homeStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if self.HomeVC == nil{
            self.HomeVC = homeStoryboard.instantiateViewController(withIdentifier: "home") as! UITabBarController
        }
        return self.HomeVC
    }
    
    func changeRootViewController() {
    
        if AppStateManager.sharedInstance.isUserLoggedIn() {
            let homeNavigation = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SWRevealViewController")
            self.window?.rootViewController = nil;
            self.window?.rootViewController = homeNavigation
        }
        else {
            let signInController = UIStoryboard(name: "LoginModule", bundle: nil).instantiateViewController(withIdentifier: "DDloginViewController")
            self.window?.rootViewController = nil;
            self.window?.rootViewController = signInController
        }
    }
    
    func goToOrderDetailScreen(){
        let navigationController = UINavigationController()
        let orderDetail = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DDOrderDetailViewController") as! DDOrderDetailViewController
        navigationController.viewControllers = [orderDetail]
        window?.rootViewController = navigationController
    }
}
