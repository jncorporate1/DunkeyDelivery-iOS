//
//  ReverseGeodic.swift
//  Template
//
//  Created by Ingic on 25/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            return result
        }
        return nil
    }
}
