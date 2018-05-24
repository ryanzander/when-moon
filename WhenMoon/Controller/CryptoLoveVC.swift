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

        // add logo to nav bar
        // need to put this in every view controller
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 112, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WhenMoonLogo.png")
        let logoView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: imageView.frame.size.width, height: imageView.frame.size.height))
        logoView.addSubview(imageView)
        navigationItem.titleView = logoView
        
        self.view.backgroundColor = darkSky
        
        
        btcLbl.text = BTC_ADDRESS
        ltcLbl.text = LTC_ADDRESS
        ethLbl.text = ETH_ADDRESS
        
        messageLbl.text = "When Moon??? app is given away free and with no ads.\n\nIf you've enjoyed using it, how about showing a little crypto ♥︎ for the developer?"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // add link to app store in future version
        UIApplication.shared.openURL(URL(string: appStoreURL)!)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
