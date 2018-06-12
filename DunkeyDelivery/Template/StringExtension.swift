//
//  StringExtension.swift
//  Template
//
//  Created by Ingic on 8/9/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import Foundation

extension String
{
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func getURL()-> URL{
        var stringImage = self

        stringImage =  stringImage.trimmingCharacters(in: .whitespaces)
        
        if !(stringImage.contains("http") || stringImage.contains("https")) {
            stringImage = Constants.ImageBaseURl + stringImage
        }
        
        
        let urlStr : NSString = stringImage.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        
        let searchURL : NSURL = NSURL(string: urlStr as String)!
        return searchURL as URL
    }
}
