//
//  SideMenuViewController.swift
//  Template
//
//  Created by Ingic on 6/30/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire
import Kingfisher
import LGAlertView
import SwiftMessages

class SideMenuViewController: UIViewController {
    
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variable
    
    var menuItems = [String]()
    var menuIcons = [String]()
    
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMenuitems()
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setMenuitems(){
        self.menuItems.append("Your Account")
        self.menuItems.append("Contact us")
        self.menuItems.append("Deals and Promotions")
        self.menuItems.append("Logout")
        self.menuIcons.append("addressHomeSelected")
        self.menuIcons.append("contactUs_ion")
        self.menuIcons.append("deal_icon")
        self.menuIcons.append("logout_icon")
    }
    
    func showContactOptions() {
        let alertView = LGAlertView.init(title: nil, message: nil, style: .actionSheet, buttonTitles: ["Call","Email"], cancelButtonTitle: "Close",destructiveButtonTitle: nil)
        alertView.delegate = self
        alertView.buttonsFont = UIFont(name: "Montserrat-Regular", size: 16.0)!
        alertView.buttonsIconImages = [#imageLiteral(resourceName: "call_icon"), #imageLiteral(resourceName: "email_icon")]
        alertView.buttonsIconPosition = .left
        alertView.buttonsTextAlignment = .left
        alertView.tintColor = UIColor.white
        alertView.buttonsTitleColor = UIColor.black
        alertView.cancelButtonTitleColor = UIColor.black
        alertView.buttonsHeight = 45.0
        alertView.show(animated: true, completionHandler: nil)
    }
    
    func callAction(){
        makeCall()
    }
    
    func emailAction(){
        goToContactUsView()
    }
    
    func showErrorWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .TabView)
        error.configureTheme(.error)
        error.configureContent(title: "", body: message)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
    }
    
    func makeCall(){
        let contactNum = AppStateManager.sharedInstance.settingObj.ContactNo
        if  contactNum != nil {
            guard let number = URL(string: "tel://" + contactNum!) else { return }
            UIApplication.shared.open(number)
        }
        else{
            return
        }
    }
    
    func goToDealPromotionView(){
        let tbc = revealViewController().frontViewController as? UITabBarController
        let nc = tbc?.selectedViewController as? UINavigationController
        let vc = storyboard?.instantiateViewController(withIdentifier: "DDDealAndPromotionsViewController") as! DDDealAndPromotionsViewController
        nc?.pushViewController(vc, animated: false)
        revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        
    }
    
    func goToContactUsView(){
        let tbc = revealViewController().frontViewController as? UITabBarController
        let nc = tbc?.selectedViewController as? UINavigationController
        let vc = storyboard?.instantiateViewController(withIdentifier: "DDContactUsViewController") as! DDContactUsViewController
        nc?.pushViewController(vc, animated: false)
        revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
    }
    
    func goToAccountView(){
        let tbc = revealViewController().frontViewController as? UITabBarController
        let nc = tbc?.selectedViewController as? UINavigationController
        let vc = storyboard?.instantiateViewController(withIdentifier: "account") as! DDAccountViewController
        nc?.pushViewController(vc, animated: false)
        revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
    }
}


//MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 220
        }
        else{
            return 60
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            if indexPath.row == 0{
                goToAccountView()
            }
            else if indexPath.row == 1{
                showContactOptions()
            }
            else if indexPath.row == 2{
                goToDealPromotionView()
            }
            else{
                showLogoutAlert()
            }
        }
    }
    
    func showLogoutAlert(){
    UIAlertController.showAlert(in: self,
            withTitle: "Logout",
            message: "Are you sure you want to logout?",
            cancelButtonTitle: "No",
            destructiveButtonTitle: "Yes",
            otherButtonTitles: nil,
            tap: {(controller, action, buttonIndex) in
                
            if (buttonIndex == controller.cancelButtonIndex) {
            print("Cancel Tapped")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showHome"), object: nil)
            self.revealViewController().revealToggle("")
            } else if (buttonIndex == controller.destructiveButtonIndex) {
            print("Delete Tapped")
            AppStateManager.sharedInstance.markUserLogout()
            } else if (buttonIndex >= controller.firstOtherButtonIndex) {
            print("Other Button Index \(buttonIndex - controller.firstOtherButtonIndex)")
        }
        })
    }
}


//MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            return self.menuItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "first", for: indexPath) as! CustomTableViewCell
            if AppStateManager.sharedInstance.loggedInUser.FullName != nil{
                cell.fullName.text = AppStateManager.sharedInstance.loggedInUser.FullName
            }
            else{
                if (AppStateManager.sharedInstance.loggedInUser.FirstName != nil) && (AppStateManager.sharedInstance.loggedInUser.LastName != nil){
                    cell.fullName.text = AppStateManager.sharedInstance.loggedInUser.FirstName + " " + AppStateManager.sharedInstance.loggedInUser.LastName
                }
            }
            if AppStateManager.sharedInstance.loggedInUser.Email != nil{
                cell.email.text = AppStateManager.sharedInstance.loggedInUser.Email
            }
            if AppStateManager.sharedInstance.loggedInUser.Role == 5 || AppStateManager.sharedInstance.loggedInUser.Role == 6 {
                let stringUrl = AppStateManager.sharedInstance.loggedInUser.ProfilePictureUrl
                
                let url = URL(string: stringUrl!)!
                cell.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Image-1"))
            }
            else{
            let url = AppStateManager.sharedInstance.loggedInUser.ProfilePictureUrl?.getURL()
            cell.profileImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Image-1"))
            }
            cell.selectionStyle = .none
            return cell
        }
        else{
            let item = self.menuItems[indexPath.row]
            let icon = self.menuIcons[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "second", for: indexPath) as! CustomTableViewCell
            cell.menuItem.text = item
            cell.menuIcon.image = UIImage(named: icon)
            cell.selectionStyle = .none
            return cell
        }
    }
}


//MARK: - LGAlertViewDelegate

extension SideMenuViewController: LGAlertViewDelegate{
    @objc func alertView(_ alertView: LGAlertView, clickedButtonAt index: UInt, title: String?){
        if index == 0{
            self.callAction()
        }
        else{
            self.emailAction()
        }
    }
}
