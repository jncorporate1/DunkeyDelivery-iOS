//
//  Validation.swift
//  Template
//
//  Created by Ingic on 6/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import Foundation
import UIKit
class Validation {
    
    
    
    static func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func validateStringLength(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    static func checkIfStringIsValid(testStr:String) -> Bool{
        
        if(testStr.characters.count > 0){
            return true;
        }
        return false;
    }
}
