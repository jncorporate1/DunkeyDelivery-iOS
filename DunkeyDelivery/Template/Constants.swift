//
//  Constants.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

struct Constants{
    
    static let AppName = "Template"
    
    static let kUserLoggedIn = "userLoggedIn"
    
    static let kUserSessionKey = "userSessionKey"
//    static let BaseURL = "http://10.100.28.59:801/api/" //"10.100.28.36:801/api/"//QA Link
//    static let ImageBaseURl = "http://10.100.28.59:801/"
    
    static let BaseURL = "http://api.dunkeydelivery.com/api/"  //LIVE link
    static let ImageBaseURl = "http://api.dunkeydelivery.com/"
    
    //static let BaseURL = "http://10.100.28.38/api/"
    static let BaseGoogleURL = "https://maps.googleapis.com/maps/api/"
    
    static let VALIDATION_USERNAME_MIN                 = "Username must not be more than 15 characters and must not contain any space character."
    static let VALIDATION_VALID_NAME                   = "Please provide a valid name."
    static let VALIDATION_VALID_EMAIL                  = "Please provide a valid Email Address."
    static let VALIDATION_VALID_AGE                    = "Kindly provide a valid age."
    static let VALIDATION_NUMERIC_PHONE                = "Phone number must be numeric with at least 11 digits."
    static let VALIDATION_NUMERIC_CELL                 = "Cell number must be numeric with at least 11 digits."
    
    static let VALIDATION_PASSWORD_MIN                 = "Password should contain atlest 4 characters."
    static let VALIDATION_PASSWORD_MATCH               = "New password and confirm password does not match."
    static let FORGET_PASSWORD                         = "A password has been sent to your email Address!"
    static let PASSWORD_UPDATED                        = "Your Password has been updated"
    
    static let VALIDATION_MAX_FIELD_LENGTH             = "Field must not be more than 15 characters."
    static let VALIDATION_MAX_DESCRIPTION_LENGTH       = "Description must not be more than 300 characters."
    static let VALIDATION_ALL_FIELDS                   = "Kindly fill all the fields."
    static let VALIDATION_VALID_URL                    = "Please provide a valid URL."
    static let VALIDATION_VALID_FILE_NAME              = "Please provide a file name."
    
    static let VALIDATION_IMAGE                        = "Please provide an image."
    static let VALIDATION_TERMS                        = "Kindly select the terms and Conditions."
    
    static let PROFILE_UPDATED                         = "Your Profile has been updated."
    
    static let MESSAGE_LOGOUT                          = "Are you sure you want to logout?"
    static let GOOGLE_API_KEY                          = "AIzaSyDbU4SB3Y_cAD_YXTDhs1sqMF6O7kdEIt4"
    
    static let APP_COLOR : UIColor = UIColor(red:0.39, green:0.72, blue:0.24, alpha:1.0)
    static let CART_COLOR : UIColor = UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.0)
    static let APP_GRAY_COLOR = UIColor(red:0.55, green:0.55, blue:0.55, alpha:1.0)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let USER_DEFAULTS = UserDefaults.standard
    
}

