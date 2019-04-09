//
//  CoinData.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/21/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import Foundation


struct CoinListData {
    
    let idNumber: Int
    let name: String
    let symbol: String
    
    init(dic: [String: Any]) {
        
        let idNumber = dic["id"] as? Int ?? 0
        let name = dic["name"] as? String ?? ""
        let symbol = dic["symbol"] as? String ?? ""
    
        self.idNumber = idNumber
        self.name = name
        self.symbol = symbol
    }
}



//struct CoinData {
class CoinData: NSObject {
    
    var name: String
    var symbol: String
    var idNumber: Int
    var priceUSD: Double
    var percentChange24H: Double
    var amount: String // amount is String to control the digits exactly
    var value: Double
  //  var valueDouble: Double
    var rank: Int
    
    /*
    private var _name: String!
    private var _symbol: String!
    private var _id: String!
    private var _priceUSD: String!
    private var _percentChange24H: String!
    private var _amount: String!
    private var _value: String!
    private var _valueDouble: Double!
    private var _rank: Int!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
   
    var symbol: String {
        if _symbol == nil {
            _symbol = ""
        }
        return _symbol
    }
    
    var id: String {
        if _id == nil {
            _id = ""
        }
        return _id
    }
    
    var priceUSD: String {
        if _priceUSD == nil {
            _priceUSD = ""
        }
        return _priceUSD
    }
    
    var percentChange24H: String {
        if _percentChange24H == nil {
            _percentChange24H = ""
        }
        return _percentChange24H
    }
    
    var amount: String {
        if _amount == nil {
            _amount = ""
        }
        return _amount
    }
    
    var value: String {
        if _value == nil {
            _value = ""
        }
        return _value
    }
    
    var valueDouble: Double {
        if _valueDouble == nil {
            _valueDouble = 0.0
        }
        return _valueDouble
    }
    
    var rank: Int {
        if _rank == nil {
            _rank = 0
        }
        return _rank
    }
    */
    
    init(dic: [String: Any]) {
  //  init(name: String, symbol: String, idNumber: Int, priceUSD: String, percentChange24H: String, amount: String, value: String, valueDouble: Double, rank: Int) {
        
        let name = dic["name"] as? String ?? ""
        let symbol = dic["symbol"] as? String ?? ""
        let idNumber = dic["id"] as? Int ?? 0
        
        var price = 0.0
        var change = 0.0
        if let quotes = dic["quotes"] as? [String: Any] {
            if let usd = quotes["USD"] as? [String: Any] {
                price = usd["price"] as? Double ?? 0.0
                change = usd["percent_change_24h"] as? Double ?? 0.0
            }
        }
        
        let rank = dic["rank"] as? Int ?? 0
        
        
        
        self.name = name
        self.symbol = symbol
        self.idNumber = idNumber
        self.priceUSD = price
        self.percentChange24H = change
        self.amount = "0.0"
        self.value = 0.0
     //   self.valueDouble = valueDouble
        self.rank = rank
    }
    
}
