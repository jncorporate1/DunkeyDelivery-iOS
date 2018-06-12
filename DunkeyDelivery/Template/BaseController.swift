//
//  BaseController.swift
//  Template
//
//  Created by Ingic on 02/01/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftMessages
import UIAlertController_Blocks
import Toast_Swift

class BaseController: UIViewController, NVActivityIndicatorViewable {
//    var revealController = SWRevealViewController()
//     var tapGesture : UITapGestureRecognizer!
    var leftSearchBarButtonItem : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeNavigationBar()
        setUpNotifications()
        
    }
    
    
    func setUpNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(showHome), name: NSNotification.Name(rawValue: "showHome"), object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func homeNavigationBar(){
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        if let font = UIFont(name: "Montserrat-Regular", size: 19){
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.white]
            self.navigationController?.navigationBar.barStyle = .black
        }
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor =  UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    func setLoginNavigationBar(){
        if let font = UIFont(name: "Montserrat-Regular", size: 18){
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.black]
            self.navigationController?.navigationBar.barStyle = .default
        }
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
              self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    func bagNavigationBar(){
        
        if let font = UIFont(name: "Montserrat-Regular", size: 18){
            self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font,NSForegroundColorAttributeName:UIColor.white]
            //self.navigationController?.navigationBar.barStyle = .default
        }
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "food_bg"), for: UIBarMetrics.default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    func setAlcoholBackButton(){
        self.leftSearchBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: nil)
        
    }
    
    func addMenuItemButtonToNavigationBar(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "menuItem"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
        if revealViewController() != nil {
            self.leftSearchBarButtonItem?.target = self.revealViewController()
            self.leftSearchBarButtonItem?.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> () -> Void) 
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    func openMenu(menuButton: UIBarButtonItem){
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> () -> Void) // Swift 3 fix
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    func hideTabBarAnimated(hide:Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            if hide {
                self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
                self.tabBarController?.tabBar.isHidden = true
            } else {
                self.tabBarController?.tabBar.transform = CGAffineTransform.identity
                self.tabBarController?.tabBar.isHidden = false
            }
        })
    }
    func addBackButtonToNavigationBar(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
//        self.navigationController?.navigationBar.b
    }
    
    func addbackButtonToHomeViewController(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(goHome))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
    }
    
    
    func notificationBackButton(){
        self.leftSearchBarButtonItem =  UIBarButtonItem(image: UIImage.init(named: "back_button_icon"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(fromNotificationToHome))
        self.navigationItem.leftBarButtonItem = self.leftSearchBarButtonItem;
        //        self.navigationController?.navigationBar.b
    }
    
    
    
    func fromNotificationToHome(){

      AppStateManager.sharedInstance.changeRootViewController()
    }
    
    func goHome(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goBack(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func startLoading(){
        let size = CGSize(width: 80, height:80)
        
        startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballTrianglePath.rawValue)!)
        
    }
    
    func stopLoading(){
        stopAnimating()
    }
    
    
    
    func showToast(text: String){
        self.view.makeToast(text, duration: 3.0, position: .center)
        
    }
    func showErrorWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .TabView)
        error.configureTheme(.error)
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
        
    }
    func showSuccessWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .TabView)
        error.configureTheme(.success)
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
        
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return ""
    }

    func showAlertWith(message: String, title: String){
        
        UIAlertController.showAlert(in: self,
                                    withTitle: title == "" ? "Dunkey Delivery" : title,
                                    message: message,
                                    cancelButtonTitle: "OK",
                                    destructiveButtonTitle: nil,
                                    otherButtonTitles: nil,
                                    tap: {(controller, action, buttonIndex) in
                                        
                                        if (buttonIndex == controller.cancelButtonIndex) {
                                            print("Cancel Tapped")
                                        } else if (buttonIndex == controller.destructiveButtonIndex) {
                                            print("Delete Tapped")
                                        } else if (buttonIndex >= controller.firstOtherButtonIndex) {
                                            print("Other Button Index \(buttonIndex - controller.firstOtherButtonIndex)")
                                        }
        })
        
    }


    func tabSelected() {
        tabBarController?.selectedIndex = 1
        goHome()
    }
    
    func showHome(){
        self.tabBarController?.selectedIndex = 0
    }
    func showOrder()  {
        self.tabBarController?.selectedIndex = 1
    }
    
    func calculatePrice(items: [Cart]){
        for item in items{
            var price: Double = 0
            var proPrice: Double = 0
            for proItem in item.products{
                if item.storeId == proItem.Store_id{
                    if proItem.Category_Id == -1{
                        proPrice = proItem.Price.value!
                        price = proPrice + price
                    }
                    else{
                        proPrice = proItem.Price.value! * Double(proItem.quantity)
                        price = proPrice + price
                    }
                    item.totalPrice = price
                }
            }
            
            
        }
        
    }
    func getDate(str: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//"yyyy-dd-MM HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let date = dateFormatter.date(from: str)
        print(date ?? "")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d, yyyy"
        let newDate = dateFormatter2.string(from: date!)
        return newDate
    }
    
}
