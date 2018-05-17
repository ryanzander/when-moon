//
//  ConverseColor.swift
//
//  Created by Ryan Zander on 1/24/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.


import Foundation
import UIKit

class ConverseColor {
    
    func hexStringToUIColor(_ hex:String) -> UIColor {
        
        var cString = hex.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            let newString = String(cString[index...])
            cString = newString
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

// example for use:
// let myColor = ConverseColor().hexStringToUIColor("#339933")
