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
// https://s2.coinmarketcap.com/static/img/coins/32x32/2099.png
let SMALL_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/32x32/"
let MEDIUM_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/64x64/"
let LARGE_IMG_BASE_URL = "https://s2.coinmarketcap.com/static/img/coins/128x128/"

let API_KEY = PRIVATE_API_KEY
// PRIVATE_API_KEY is not included in the remote git repository
// Sign up at
// https://pro-api.coinmarketcap.com
// and replace PRIVATE_API_KEY with your API Key to run the app

// latest returns top 100 coins by default
let LATEST_URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
let appStoreURL = "itms-apps://itunes.apple.com/app/id1386653157?action=write-review"

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


