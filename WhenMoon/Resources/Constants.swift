//
//  Constants.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/20/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import Foundation
import UIKit

let BTC_ADDRESS = "1FnphV7YcNdhuxC3jUHawWdtejcM54YQmu"
let LTC_ADDRESS = "LZv3PjJKjqQxzgSLXnnWcqpnHfJ3LC89cW"
let ETH_ADDRESS = "0x25d91257E198596B4aD9a8691F94c97e1aec0D37"

// example image url
// https://files.coinmarketcap.com/static/img/coins/128x128/kucoin-shares.png // old
// https://s2.coinmarketcap.com/static/img/coins/32x32/2099.png

// let SMALL_IMG_BASE_URL = "https://files.coinmarketcap.com/static/img/coins/32x32/"
// let MEDIUM_IMG_BASE_URL = "https://files.coinmarketcap.com/static/img/coins/64x64/"
// let LARGE_IMG_BASE_URL = "https://files.coinmarketcap.com/static/img/coins/128x128/"

let SMALL_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/32x32/"
let MEDIUM_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/64x64/"
let LARGE_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/128x128/"

// let ALL_COINS_URL = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
// let TOP_100_COINS_URL = "https://api.coinmarketcap.com/v1/ticker/"

let COIN_LIST_URL = "https://api.coinmarketcap.com/v2/listings/"
let TICKER_URL = "https://api.coinmarketcap.com/v2/ticker/"
// by default, TICKER_URL gets info on top 100 coins
// append id to TICKER_URL for individual coin data, ex:
// https://api.coinmarketcap.com/v2/ticker/1/

// colors
let darkSky = ConverseColor().hexStringToUIColor("#230056")
let banana = ConverseColor().hexStringToUIColor("#FFFD72")
let darkGreen = ConverseColor().hexStringToUIColor("#009900")
let darkRed = ConverseColor().hexStringToUIColor("#FF0000")
let brightGreen = ConverseColor().hexStringToUIColor("#00CC00")
let brightRed = ConverseColor().hexStringToUIColor("#FF0000")
let nearBlack = ConverseColor().hexStringToUIColor("#030233")
let nebulaPurple = ConverseColor().hexStringToUIColor("#6B4D8D")
let nebulaGray = ConverseColor().hexStringToUIColor("#4B466F")

let defaults = UserDefaults.standard

typealias DownloadComplete = () -> ()

