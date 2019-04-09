//
//  CryptoLoveVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 5/13/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class CryptoLoveVC: BaseVC {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var btcLbl: UILabel!
    @IBOutlet weak var ltcLbl: UILabel!
    @IBOutlet weak var ethLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = darkSky
                
        btcLbl.text = BTC_ADDRESS
        ltcLbl.text = LTC_ADDRESS
        ethLbl.text = ETH_ADDRESS
        
        messageLbl.text = "When Moon??? app is given away free and with no ads.\n\nIf you've enjoyed using it, how about showing a little crypto ♥︎ for the developer?"
        
    }

    
    @IBAction func copyBTC(_ sender: Any) {
        
        UIPasteboard.general.string = BTC_ADDRESS
        showAlertWith(title: "Copied", message: "BTC address \"\(BTC_ADDRESS)\" copied to clipboard")
    }
    
    
    @IBAction func copyLTC(_ sender: Any) {
        
        UIPasteboard.general.string = LTC_ADDRESS
        showAlertWith(title: "Copied", message: "LTC address \"\(LTC_ADDRESS)\" copied to clipboard")
    }
    
    @IBAction func copyETH(_ sender: Any) {
        
        UIPasteboard.general.string = ETH_ADDRESS
        showAlertWith(title: "Copied", message: "ETH address \"\(ETH_ADDRESS)\" copied to clipboard")
    }
    
    
    
    @IBAction func rateApp(_ sender: Any) {
       
        guard let url = URL(string: appStoreURL) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    

}
