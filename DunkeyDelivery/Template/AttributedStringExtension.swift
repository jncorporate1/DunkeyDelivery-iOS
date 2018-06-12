//
//  AttributedStringExtension.swift
//  Template
//
//  Created by zaidtayyab on 16/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String, size: Int) -> NSMutableAttributedString {
        let attrs = [NSFontAttributeName : UIFont(name: "Montserrat-Bold", size: CGFloat(size))!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String, size: Int)->NSMutableAttributedString {
        let attrs = [NSFontAttributeName : UIFont(name: "Montserrat-Regular", size: CGFloat(size))!]
        let normalString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(normalString)
        return self
    }
}

