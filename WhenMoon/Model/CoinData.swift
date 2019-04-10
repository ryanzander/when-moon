//
//  CoinData.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/21/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import Foundation

class CoinData: NSObject {
    
    var name: String
    var symbol: String
    var idNumber: Int
    var priceUSD: Double
    var percentChange24H: Double
    var amount: String // amount is String to control the digits exactly
    var value: Double
    var rank: Int
    
    init(dic: [String: Any]) {
  
        let name = dic["name"] as? String ?? ""
        let symbol = dic["symbol"] as? String ?? ""
        let idNumber = dic["id"] as? Int ?? 0
        
        var price = 0.0
        var change = 0.0
        if let quote = dic["quote"] as? [String: Any] {
            if let usd = quote["USD"] as? [String: Any] {
                price = usd["price"] as? Double ?? 0.0
                change = usd["percent_change_24h"] as? Double ?? 0.0
            }
        }
        
        let rank = dic["cmc_rank"] as? Int ?? 0
        
        self.name = name
        self.symbol = symbol
        self.idNumber = idNumber
        self.priceUSD = price
        self.percentChange24H = change
        self.amount = "0.0"
        self.value = 0.0
        self.rank = rank
    }
    
}
