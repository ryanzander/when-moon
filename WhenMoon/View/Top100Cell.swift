//
//  Top100Cell.swift
//  WhenMoon
//
//  Created by Ryan Zander on 5/13/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class Top100Cell: UITableViewCell {
    
    @IBOutlet private weak var coinLogo: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var symbolLbl: UILabel!
    @IBOutlet private weak var rankLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var changeLbl: UILabel!

    var coinData: CoinData? {
        didSet {
            guard let coinData = coinData else { return }
            
            // update UI on main thread
            DispatchQueue.main.async {
                
                // name
                self.nameLbl.text = coinData.name
                
                // symbol
                self.symbolLbl.text = coinData.symbol
                
                // rank
                self.rankLbl.text = "\(coinData.rank)"
                
                // Price
                // use the dollarString if the price is over $10
                if coinData.priceUSD > 10.0 {
                    if let dollarString = coinData.priceUSD.dollarString() {
                        self.priceLbl.text = dollarString
                    }
                } else {
                    if let priceString = coinData.priceUSD.priceString() {
                        self.priceLbl.text = priceString
                    }
                }
                
                // set text and color of %change label
                var changeString = ""
                let change = coinData.percentChange24H
                if (change < 0.0) {
                    self.changeLbl.textColor = darkRed
                    changeString = "\(coinData.percentChange24H)%"
                } else {
                    self.changeLbl.textColor = darkGreen
                    changeString = "+\(coinData.percentChange24H)%"
                }
                self.changeLbl.text = changeString
                
                // The image to dowload
                if let url = URL(string:"\(MEDIUM_IMG_BASE_URL)\(coinData.idNumber).png") {
                    
                    URLSession.shared.dataTask(with: url) { (data, response, error) in
                        
                        if let error = error {
                            print("URL error: ", error.localizedDescription)
                            return
                        }
                        
                        guard let data = data else { return }
                        guard let img = UIImage(data: data) else { return }
                        
                        // update UI on main thread
                        DispatchQueue.main.async {
                            self.coinLogo.image = img
                        }
                    }.resume()
                }
            }
        }
    }
    
}
