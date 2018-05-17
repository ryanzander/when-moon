//
//  CoinData.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/21/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import Foundation

class CoinData: NSObject {
    
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
    
    
    init(name: String, symbol: String, id: String, priceUSD: String, percentChange24H: String, amount: String, value: String, valueDouble: Double, rank: Int) {
        
        _name = name
        _symbol = symbol
        _id = id
        _priceUSD = priceUSD
        _percentChange24H = percentChange24H
        _amount = amount
        _value = value
        _valueDouble = valueDouble
        _rank = rank
    }
    
}
