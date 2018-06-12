//
//  DDLabel.swift
//  Template
//
//  Created by Ingic on 7/4/17.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Device
import CocoaLumberjack



class DDLabel: UILabel{
    
    
    var fontSizeForiPhone4: CGFloat!
    var fontSizeForIphone5: CGFloat!
    var fontSizeForIphone6: CGFloat!
    var fontSizeForIphone6p: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateFontForDevice()
    }
    
    required  init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateFontForDevice()
    }
}

extension DDLabel {
    
    
    @IBInspectable var fontScaleForiPhone4: CGFloat{
        
        get {
            return 1.0
        }
        
        set(fontScaleForiPhone4){
            
            if(fontScaleForiPhone4 > 0){
                self.fontSizeForiPhone4 = fontScaleForiPhone4
            }
        }
    }
    
    
    @IBInspectable var fontScaleForiPhone5: CGFloat{
        
        get {
            return 1.0
        }
        
        set(fontScaleForiPhone5){
            
            if(fontScaleForiPhone5 > 0){
                self.fontSizeForIphone5 = fontScaleForiPhone5
            }
        }
    }
    
    @IBInspectable var fontScaleForiPhone6: CGFloat{
        
        get {
            return 1.0
        }
        
        set(fontScaleForiPhone6){
            
            if(fontScaleForiPhone6 > 0){
                self.fontSizeForIphone6 = fontScaleForiPhone6
            }
        }
    }
    
    
    @IBInspectable var fontScaleForiPhone6p: CGFloat{
        
        get {
            return 1.0
        }
        
        set(fontScaleForiPhone6p){
            
            if(fontScaleForiPhone6p > 0){
                self.fontSizeForIphone6p = fontScaleForiPhone6p
            }
        }
    }
    
    
    func updateFontForDevice(){
        
        let titleFont = self.font
        
        switch Device.size() {
            
        case .screen3_5Inch:
            
            self.font = titleFont?.withSize(self.fontSizeForiPhone4)
        case .screen4Inch:
            self.font = titleFont?.withSize(self.fontSizeForIphone5)
        case .screen4_7Inch:
            self.font = titleFont?.withSize(self.fontSizeForIphone6)
        case .screen5_5Inch:
            self.font = titleFont?.withSize(self.fontSizeForIphone6p)
        default:
            print("Unknown size")
        }
    }
}

