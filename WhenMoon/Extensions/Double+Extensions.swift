//
//  Double+Extensions.swift
//  WhenMoon
//
//  Created by Ryan Zander on 4/8/19.
//  Copyright © 2019 Ryan Zander. All rights reserved.
//

import Foundation

extension Double {
    
    func dollarString() -> String? {
        
        // get NSNumber from the double
        let nsNum = NSNumber(value: self)
        
        // format to display as "$1,000.00"
        let dollarFormatter = NumberFormatter()
        dollarFormatter.usesGroupingSeparator = true
        dollarFormatter.numberStyle = .currency
        dollarFormatter.locale = Locale(identifier: "en_US")
        
        // make string
        let dollarString = dollarFormatter.string(from: nsNum)
        return dollarString
        
    }
    
    func decimalString(maxFractionDigits: Int) -> String? {
        
        // get NSNumber from the double
        let nsNum = NSNumber(value: self)
        
        // format to display as 0.145
        let amountFormatter = NumberFormatter()
        amountFormatter.maximumFractionDigits = maxFractionDigits
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.numberStyle = .decimal
        
        // make string
        let amountString = amountFormatter.string(from: nsNum)
        return amountString
    }
    
    func priceString() -> String? {
        
        // get NSNumber from the double
        let nsNum = NSNumber(value: self)
        
        // format to display as 0.145
        let amountFormatter = NumberFormatter()
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.numberStyle = .decimal
        
        // make string
        if let amountString = amountFormatter.string(from: nsNum) {
            let price = "$\(amountString)"
            return price
        }
        return nil
    }
    
}
