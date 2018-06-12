//
//  DDloginViewController.swift
//  Template
//
//  Created by Ingic on 7/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Device
import SwiftValidator
import RealmSwift
import Alamofire
import CoreLocation
import FacebookCore
import FacebookLogin
import FBSDKLoginKit


class DDloginViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var resetPass: UIButton!
    @IBOutlet weak var newUserLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordField: DDTextView!
    @IBOutlet weak var emailField: DDTextView!
    
    //MARK:- Variable
    
    let validator = Validator()
    var dict : [String : AnyObject]!
    var  user: GIDGoogleUser!
    var locationManager: CLLocationManager!
    var gFirstName: String!
    var gLastName: String!
    var gFullName: String!
    var gEmail: String!
    var gSignIntype = 6
    var gImageUrl: String!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //getlocationPermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        self.setupTOSLabel()
        self.setUpFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Helping Method
    
    func setupTOSLabel(){
        let lightFont = [NSFontAttributeName:UIFont(name: "Montserrat-Regular", size: 15.0)]
        let nextDropString = NSMutableAttributedString(string: "New user? ", attributes: lightFont)
        nextDropString.addAttribute(NSForegroundColorAttributeName, value: UIColor.gray, range: NSRange(location:0,length:10))
        let nextString = NSMutableAttributedString(string: "Create Account", attributes: lightFont)
        nextString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location:0,length:14))
        let labelString = NSMutableAttributedString(attributedString: nextDropString)
        labelString.append(nextString)
        self.newUserButton.setAttributedTitle(labelString, for: .normal)
    }
    
    func setUpFields(){
        emailField.textField.keyboardType = .emailAddress
        emailField.textField.returnKeyType = .done
        emailField.textField.delegate = self
        passwordField.textField.returnKeyType = .done
        passwordField.textField.delegate = self
        validator.registerField(emailField.textField, errorLabel: emailField.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
        validator.registerField(passwordField.textField, errorLabel: passwordField.errorLabel, rules: [RequiredRule(),MinLengthRule(length:4)])
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getFontSizeForCurrentDevice() -> Float{
        
        var fontSize: Float = 11.5
        
        switch Device.size() {
        case .screen3_5Inch:
            fontSize = 7.0
        case .screen4Inch:
            fontSize = 7.0
        case .screen4_7Inch:
            fontSize = 11.5
        case .screen5_5Inch:
            fontSize = 13.0
        default:
            fontSize = 11.5
        }
        return fontSize
    }
    
    func resetErrorForUserSignup(){
        self.emailField.resetError()
        self.passwordField.resetError()
    }
    
    /*func getlocationPermission(){
        locationManager = CLLocationManager()
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }*/
    
    func faceBookSetUp() {
        
        let loginManager = LoginManager()
        
        do{
            loginManager.logOut()
            loginManager.logIn(readPermissions: [ .publicProfile,.email], viewController: self){
                loginResult in
                
                switch loginResult {
                case .failed(let error):
                    print(error)
                    self.showErrorWith(message: error as! String)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    if((FBSDKAccessToken.current()) != nil){
                        self.startLoading()
                        print(grantedPermissions)
                        print(declinedPermissions)
                        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                            if (error == nil){
                                self.dict = result as! [String : AnyObject]
                                print(result!)
                                print(self.dict)
                                print(accessToken.authenticationToken)
                                let id = self.dict["id"] as! String
                                self.startLoading()
                                self.processExternalLogin(userId: id,accessToken: accessToken.authenticationToken,socialLoginType: 5)
                                
                            }})}}}}
        catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        faceBookSetUp()
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "LoginModule", bundle: nil).instantiateViewController(withIdentifier: "DDForgotPasswordViewController") as! DDForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func createNewUserTapped(_ sender: Any) {
        let vc = UIStoryboard(name: "LoginModule", bundle: nil).instantiateViewController(withIdentifier: "DDSignUpViewController") as! DDSignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.resetErrorForUserSignup()
        validator.validate(self)
    }
}

//MARK: - UITextFieldDelegate

extension DDloginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}

// MARK: - WebService API

extension DDloginViewController{
    func processLoginRequest(){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "email":emailField.textField.text!,
            "password":passwordField.textField.text!,]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Request Successful")
                let responseResult = result["Result"] as! NSDictionary
                AppStateManager.sharedInstance.loggedInUser = nil
                AppStateManager.sharedInstance.loggedInUser =  User(value: responseResult )
                let realm = try! Realm()
                try! realm.write(){
                    realm.add(AppStateManager.sharedInstance.loggedInUser, update: true)
                }
                if AppStateManager.sharedInstance.loggedInUser.Id > 0{
                    print(AppStateManager.sharedInstance.loggedInUser)
                    AppStateManager.sharedInstance.isUserLoggedInApp = true
                    AppStateManager.sharedInstance.changeRootViewController()
                }
            }else if(response?.intValue == 403){
                
                self.showErrorWith(message: "Invalid Email or Password")
                
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        APIManager.sharedInstance.authenticateUserWith(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    //MARK: - Social Logins Api
    
    func processExternalLogin(userId: String ,accessToken: String ,socialLoginType: Int ){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "userId": userId,
            "accessToken": accessToken,
            "socialLoginType":socialLoginType.description
        ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! Int!
            if(response == 200){
                print("Request Successful")
                AppStateManager.sharedInstance.loggedInUser = nil
                AppStateManager.sharedInstance.loggedInUser = User(value: result["Result"] as! NSDictionary)
                let realm = try! Realm()
                try! realm.write(){
                    realm.add(AppStateManager.sharedInstance.loggedInUser, update: true)
                }
                if AppStateManager.sharedInstance.loggedInUser.Id > 0{
                    print(AppStateManager.sharedInstance.loggedInUser)
                    AppStateManager.sharedInstance.isUserLoggedInApp = true
                    AppStateManager.sharedInstance.changeRootViewController()
                }
            }
            else if(response == 403){
                self.showErrorWith(message: "Invalid email or password.")
                return
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        self.startLoading()
        APIManager.sharedInstance.getExternalLogin(parameters: parameters, success: successClosure){ (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    
    func externalLoginGmail(){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            "FirstName": self.gFirstName,
            "LastName": self.gLastName,
            "FullName": self.gFullName,
            "Email": self.gEmail,
            "SignIntype": self.gSignIntype,
            "ImageUrl": self.gImageUrl,
            ]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! Int!
            if(response == 200){
                print("Request Successful")
                AppStateManager.sharedInstance.loggedInUser = nil
                AppStateManager.sharedInstance.loggedInUser = User(value: result["Result"] as! NSDictionary)
                let realm = try! Realm()
                try! realm.write(){
                    realm.add(AppStateManager.sharedInstance.loggedInUser, update: true)
                }
                if AppStateManager.sharedInstance.loggedInUser.Id > 0{
                    print(AppStateManager.sharedInstance.loggedInUser)
                    AppStateManager.sharedInstance.isUserLoggedInApp = true
                    AppStateManager.sharedInstance.changeRootViewController()
                }
            }
            else if(response == 403){
                self.showErrorWith(message: "Invalid email or password.")
                return
            }
            else{
                self.showErrorWith(message: "An error occured. Please try again")
                return
            }
        }
        self.startLoading()
        APIManager.sharedInstance.gmailLogin(parameters: parameters, success: successClosure){ (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
}


//MARK: - CLLocationManagerDelegate

/*extension DDloginViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("location:: (location)")
            AppStateManager.sharedInstance.userAddress = locations.first?.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}*/


// MARK: - Validation Delegate
extension DDloginViewController: ValidationDelegate{
    
    func validationSuccessful() {
        self.view.endEditing(true)
        if(CEReachabilityManager.isReachable()){
            self.startLoading()
            self.processLoginRequest()
        }else{
            self.showErrorWith(message: "Please check your internet connection")
        }
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
}


//MARK:- GoogleSign-In Delegate

extension DDloginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        
        if let error = error {
            print("\(error.localizedDescription)")
        }
        else {
            
            self.startLoading()
            
            let userId = user.userID
            let idToken = user.authentication.idToken
            let fullName = user.profile.name
            self.gFirstName = user.profile.givenName
            self.gLastName = user.profile.familyName
            self.gEmail = user.profile.email
            self.gFullName =  user.profile.givenName + user.profile.familyName
            if user.profile.hasImage
            {
                self.gImageUrl = (user.profile.imageURL(withDimension: 100)).description
                print(self.gImageUrl!)
            }
            //            print("UserID:\(String(describing: userId)),\n Token:\(String(describing: idToken)),\n Fullname\(String(describing: fullName)),\n Name:\(String(describing: givenName)),\n Describing:\(String(describing: familyName)),\n Email:\(String(describing: email)),")
            externalLoginGmail()
            self.stopLoading()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(user)
        print(error)
    }
}
