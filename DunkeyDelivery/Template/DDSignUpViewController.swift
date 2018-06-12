//
//  DDSignUpViewController.swift
//  Template
//
//  Created by Ingic on 7/3/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import SwiftValidator
import RealmSwift
import Alamofire
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class DDSignUpViewController: BaseController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lastName: DDTextView!
    @IBOutlet weak var firstName: DDTextView!
    @IBOutlet weak var conPassword: DDTextView!
    @IBOutlet weak var password: DDTextView!
    @IBOutlet weak var email: DDTextView!
    
    //MARK: - Variable
    
    var isProfileImage: Bool = false
    let imagePicker = UIImagePickerController()
    let validator = Validator()
    var dict : [String : AnyObject]!
    var gFirstName: String!
    var gLastName: String!
    var gFullName: String!
    var gEmail: String!
    var gSignIntype = 6
    var gImageUrl: String!
    
    
    //MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.setLoginNavigationBar()
        
        self.title = "Sign Up"
        self.addBackButtonToNavigationBar()
        self.setUpFields()
        setUpTextFieldDelegate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: - Helping Method
    
    func setUpTextFieldDelegate(){
        lastName.textField.returnKeyType = .done
        lastName.textField.delegate = self
        firstName.textField.returnKeyType = .done
        firstName.textField.delegate = self
        conPassword.textField.returnKeyType = .done
        conPassword.textField.delegate = self
        password.textField.returnKeyType = .done
        password.textField.delegate = self
        email.textField.returnKeyType = .done
        email.textField.delegate = self
    }
    
    func showImageOptions() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.tintColor = UIColor.black
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        let addRemoveAction = UIAlertAction(title: "Take Photo", style: .default){ (action) in
            self.loadFromCamera()
        }
        alertController.addAction(addRemoveAction)
        let editScheduleAction = UIAlertAction(title: "Choose Photo", style: .default){ (action) in
            self.loadFromGallery()
        }
        alertController.addAction(editScheduleAction)
        self.present(alertController, animated: true)
    }
    
    func loadFromGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func loadFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func setUpFields(){
        self.email.textField.keyboardType = .emailAddress
        validator.registerField(firstName.textField, errorLabel: firstName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 3, message: "Please enter a valid name"), MaxLengthRule(length: 25, message: "Name length should be less than or equal to 25")])
        validator.registerField(lastName.textField, errorLabel: lastName.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 3, message: "Please enter a valid name"), MaxLengthRule(length: 25, message: "Name length should be less than or equal to 25")])
        validator.registerField(email.textField, errorLabel: email.errorLabel, rules: [RequiredRule(),EmailRule(message:"Please enter a valid email address")])
        validator.registerField(password.textField, errorLabel: password.errorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        validator.registerField(conPassword.textField, errorLabel: conPassword.errorLabel, rules: [RequiredRule(),MinLengthRule(length:6)])
        validator.registerField(conPassword.textField, errorLabel: conPassword.errorLabel, rules: [RequiredRule(),ConfirmationRule(confirmField:password.textField)])
    }
    
    func resetErrorForUserSignup(){
        lastName.resetError()
        firstName.resetError()
        email.resetError()
        password.resetError()
        conPassword.resetError()
    }
    
    func processEmailAlreadyExists(message: String){
        self.email.errorLabel.text = message
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
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
    
    
    //MARK:- Action
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    @IBAction func facebookButtonTapped(_ sender: Any) {
        faceBookSetUp()
    }
    
    @IBAction func imagePickerButton(_ sender: Any) {
        self.showImageOptions()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        self.resetErrorForUserSignup()
        validator.validate(self)
    }
}


//MARK: - UITextFieldDelegate

extension DDSignUpViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true;
    }
}

//MARK: - ValidationDelegate

extension DDSignUpViewController: ValidationDelegate{
    
    func validationSuccessful() {
        if(CEReachabilityManager.isReachable()){
            self.startLoading()
            self.sigunUpUserWithDetails()
        }else{
            self.showErrorWith(message: "Please check your internet connection")
        }
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        for (field, error) in errors {
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.isHidden = false
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension DDSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profileImage.image = image
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImage.image = image
            self.isProfileImage = true
        }else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profileImage.image = image
            self.isProfileImage = true
        } else {
            self.profileImage.image = nil
        }
    }
}

//MARK: - Web Service

extension DDSignUpViewController{
    
    func sigunUpUserWithDetails(){
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        var parameters : Parameters = [
            "FirstName":firstName.textField.text!.removingWhitespaces(),
            "LastName":lastName.textField.text!.removingWhitespaces(),
            "Email":email.textField.text!.removingWhitespaces(),
            "Password":password.textField.text!,
            "ConfirmPassword":conPassword.textField.text!,
            "Phone":"03333363333",
            "Role":"0"]
        
        if isProfileImage {
            let image = self.resizeImage(image: self.profileImage.image!, newWidth: 200)
            let data: Data = UIImagePNGRepresentation(image!)!
            parameters["file"] = data
        }
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! NSNumber!
            
            if(response?.intValue == 200){
                print("Request Successful")
                let responseResult = result["Result"] as! NSDictionary
                AppStateManager.sharedInstance.loggedInUser = nil
                AppStateManager.sharedInstance.loggedInUser =  User(value: responseResult as! NSDictionary)
                let realm = try! Realm()
                try! realm.write(){
                    realm.add(AppStateManager.sharedInstance.loggedInUser, update: true)
                }
                if AppStateManager.sharedInstance.loggedInUser.Id > 0{
                    print(AppStateManager.sharedInstance.loggedInUser)
                    AppStateManager.sharedInstance.isUserLoggedInApp = true
                    AppStateManager.sharedInstance.changeRootViewController()
                }
                
            }else if(response?.intValue == 409){
                
                let errors = result["Result"] as! NSDictionary
                let errorDetails = errors["ErrorMessage"] as! String
                print(errorDetails)
                self.processEmailAlreadyExists(message: errorDetails)
                return
            }else{
                self.showErrorWith(message: "An error occured. Please try again")
                self.stopLoading()
                return
            }
        }
        APIManager.sharedInstance.registerUserWith(parameters: parameters,success: successClosure) { (error) in
            print (error)
            self.showErrorWith(message: error.localizedDescription)
            self.stopLoading()
        }
    }
    
    
    func processExternalLogin(userId: String ,accessToken: String ,socialLoginType: Int ){
        
        if(!CEReachabilityManager.isReachable()){
            self.showErrorWith(message: "No Network Connection")
            return
        }
        
        let parameters: Parameters = [
            
            "userId": userId,
            "accessToken": accessToken,
            "socialLoginType":socialLoginType.description]
        
        let successClosure: DefaultArrayResultAPISuccessClosure = {
            (result) in
            
            self.stopLoading()
            print(result)
            let response = result["StatusCode"] as! Int!
            if(response == 200){
                print("Request Successful")
                AppStateManager.sharedInstance.registerUser = nil
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


//MARK: - GIDSignInUIDelegate, GIDSignInDelegate

extension DDSignUpViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
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
            //  print("UserID:\(String(describing: userId)),\n Token:\(String(describing: idToken)),\n Fullname\(String(describing: fullName)),\n Name:\(String(describing: givenName)),\n Describing:\(String(describing: familyName)),\n Email:\(String(describing: email)),")
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
