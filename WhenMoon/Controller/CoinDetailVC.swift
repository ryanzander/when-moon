//
//  CoinDetailVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/24/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire

class CoinDetailVC: BaseVC {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var symbolLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var changeLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var editLbl: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var minusBtn: RoundButton!
    @IBOutlet weak var plusBtn: RoundButton!
    @IBOutlet weak var deleteBtn: RoundButton!
    @IBOutlet weak var saveBtn: RoundButton!
    
    var minusOn = false
    var plusOn = false
    var deleteOn = false
    var saveOn = false
    var txAmount = ""
    
    var coinData: CoinData!

    override func viewDidLoad() {
        super.viewDidLoad()


    
        // set up the UI
        nameLbl.text = coinData.name
        symbolLbl.text = coinData.symbol
        
        // Amount
        // get NSNumber from the string
        let amountDouble = Double(coinData.amount)
        let amountNumber = NSNumber(value: amountDouble!)
        
        // format to display as 0.145
        let amountFormatter = NumberFormatter()
        amountFormatter.maximumFractionDigits = 8
        amountFormatter.numberStyle = .decimal
        amountFormatter.usesGroupingSeparator = true
        
        let amountString = amountFormatter.string(from: amountNumber)
       
        amountLbl.text = "\(amountString!) \(coinData.symbol)"
        
        // Price
        priceLbl.text = "$\(coinData.priceUSD)"
        
        // Change
        // set color of %change label
        let changeDouble = Double(coinData.percentChange24H)
        var changeString = ""
        if (changeDouble! < 0.0) {
            changeLbl.textColor = darkRed
            changeString = "\(coinData.percentChange24H)%"
        } else {
            changeLbl.textColor = darkGreen
            changeString = "+\(coinData.percentChange24H)%"
        }
        
        changeLbl.text = changeString
        
        // Value
        // get NSNumber from the string
        let valueDouble = Double(coinData.value)
        let valueNumber = NSNumber(value: valueDouble!)
        
        // format to display as "$1,000.00"
        let dollarFormatter = NumberFormatter()
        dollarFormatter.usesGroupingSeparator = true
        dollarFormatter.numberStyle = .currency
        dollarFormatter.locale = Locale(identifier: "en_US")
        let valueString = dollarFormatter.string(from: valueNumber)
        
        valueLbl.text = valueString
        
        // Edit Amount area
        editLbl.isHidden = false
        textField.isHidden = true
        
        minusBtn.isEnabled = true
        plusBtn.isEnabled = true
        deleteBtn.isEnabled = true
        saveBtn.isEnabled = false // nothing to save yet
        
        minusBtn.backgroundColor = nebulaGray
        plusBtn.backgroundColor = nebulaGray
        deleteBtn.backgroundColor = nebulaGray
        saveBtn.backgroundColor = nebulaGray
        
        
        // Coin logo image
        // The image to dowload
        let imgURL = URL(string:"\(LARGE_IMG_BASE_URL)\(coinData.id).png")!
        
        // Use Alamofire to download the image
        Alamofire.request(imgURL).responseData { (response) in
            
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    self.imgView.image = UIImage(data: data)
                }
            }
        }
    }

    
    @IBAction func minusTouched(_ sender: Any) {
        
        if (minusOn == false) {
            UIView.animate(withDuration: 1, animations: {
           
                // show the textfield and highlight the button
                self.editLbl.isHidden = true
                self.textField.isHidden = false
                self.minusBtn.backgroundColor = banana
                self.minusOn = true
                
                // make sure plus is off
                self.plusBtn.backgroundColor = nebulaGray
                self.plusOn = false
                
                // enable save
                self.saveBtn.isEnabled = true
            
            }, completion: nil)
        } else {
            // if already ON, tapping again has no effect
        }
    }
    
    
    @IBAction func plusTouched(_ sender: Any) {
        
        if (plusOn == false) {
            UIView.animate(withDuration: 1, animations: {
                
                // show the textfield and highlight the button
                self.editLbl.isHidden = true
                self.textField.isHidden = false
                self.plusBtn.backgroundColor = banana
                self.plusOn = true
                
                // make sure minus is off
                self.minusBtn.backgroundColor = nebulaGray
                self.minusOn = false
                
                // enable save
                self.saveBtn.isEnabled = true
                
            }, completion: nil)
        } else {
            // if already ON, tapping again has no effect
        }
    }
    

    
    @IBAction func deleteTouched(_ sender: Any) {
        
        // disable save
        self.saveBtn.isEnabled = false
        
        // we need to close the keyboard first
        self.hideKeyboard(self)
        
        if (deleteOn == false) {
            
            UIView.animate(withDuration: 1, animations: {
                
                // hide the textfield and highlight the button
                self.deleteBtn.backgroundColor = banana
                self.deleteOn = true
                
                // make sure minus and plus are OFF
                self.minusBtn.backgroundColor = nebulaGray
                self.minusOn = false
                self.plusBtn.backgroundColor = nebulaGray
                self.plusOn = false
                
            }) { _ in
                
                let alert = UIAlertController(title: "Delete \(self.coinData.symbol) ?", message: "Deleting will erase any saved data for \(self.coinData.name) and remove it from your portfolio list", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    
                    // turn delete button OFF
                    self.deleteBtn.backgroundColor = nebulaGray
                    self.deleteOn = false
                })
                
                let deleteAction = UIAlertAction(title: "Delete", style: .default, handler: { action in
                    
                    // delete the coin
                    self.deleteCoin()
                })
                
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                self.present(alert, animated: true, completion: nil)
            }
          
        } else {
            // if already ON, tapping again has no effect
        }
    }
    
    
    @IBAction func saveTouched(_ sender: Any) {
        
        // disable save while handling this action
        self.saveBtn.isEnabled = false
        
        // we need to close the keyboard first
        self.hideKeyboard(self)
        
        if (saveOn == false) {
            UIView.animate(withDuration: 1, animations: {
                
                // hide the textfield and highlight the button
                self.saveBtn.backgroundColor = banana
                self.saveOn = true
                
                // un-highlight plus or minus button
                self.minusBtn.backgroundColor = nebulaGray
                self.plusBtn.backgroundColor = nebulaGray
                
            }) { _ in
                
                // make sure the textfield has a number
                self.txAmount = self.textField.text!
                
                if (self.txAmount != ""){
                    
                    // different text for plus or minus
                    var saveText = ""
                    if (self.minusOn) {
                        saveText = "Subtract \(self.txAmount) \(self.coinData.symbol) from total?"
                    } else if (self.plusOn){
                        saveText = "Add \(self.txAmount) \(self.coinData.symbol) to total?"
                    }
                    
                    let alert = UIAlertController(title: "Save", message: saveText, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                        
                        // turn save button OFF
                        self.saveBtn.backgroundColor = nebulaGray
                        self.saveOn = false
                        self.minusOn = false
                        self.plusOn = false
                        
                        // clear the textField
                        self.textField.text = nil
                        self.textField.resignFirstResponder()
                    })
                    
                    let saveAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        // save the coin
                        self.saveCoin()
                    })
                    
                    alert.addAction(cancelAction)
                    alert.addAction(saveAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    // show alert and turn save off
                    self.minusOn = false
                    self.plusOn = false
                    self.saveOn = false
                    self.saveBtn.backgroundColor = nebulaGray
                    
                    let alert = UIAlertController(title: "No Amount Entered", message: "Please enter the transaction amount", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            // if already ON, tapping again has no effect
        }
    }
    
    
    func deleteCoin(){
        
        print("Deleting \(self.coinData.symbol)")
        
        // delete from myCoins and myCoinsTotals
        var tempArray = [String]()
        var tempTotalsArray = [Dictionary<String, String>]()
       
        // see if we have myCoins already
        if let myCoins = defaults.array(forKey: "myCoins") as? [String] {
            
            for coin in myCoins {
                
                if (coin == self.coinData.id){
                    // don't add the coin we want to delete
                } else {
                    // add all other coins to the tempArray
                    tempArray.append(coin)
                }
            }
            
            if let myCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
                
                for coinTotal in myCoinsTotals {
                    
                    if let id = coinTotal["id"] {
                        
                        if (id == self.coinData.id){
                            // don't add the coin we want to delete
                        } else {
                            // add all other coins
                            tempTotalsArray.append(coinTotal)
                        }
                    }
                }
            }
            
        } else {
            // no myCoins array
            // so nothing to delete
        }
        
        // save the new arrays to defaults
        defaults.set(tempArray, forKey:"myCoins")
        defaults.set(tempTotalsArray, forKey:"myCoinsTotals")
        
        // navigate back to home screen and refresh data
        performSegue(withIdentifier: "unwindFromCoinDetailVC", sender: self)
    }
    
    
    func saveCoin() {
        
        // first do the math
        var amountString = ""
        
        if (minusOn) {
            
            let startAmount = Double(self.coinData.amount)
            let minusAmount = Double(self.txAmount)
            let newTotal = startAmount! - minusAmount!
            amountString = "\(newTotal)"
            
            // check that the new amount is not less than zero
            if (newTotal < 0.0) {
                showAlertWith(title: "Invalid Total: \(amountString)", message: "You cannot hodl a negative balance")
                
                // turn save button OFF
                self.saveBtn.backgroundColor = nebulaGray
                self.saveOn = false
                self.minusOn = false
                self.plusOn = false
                
                // clear the textField
                self.textField.text = nil
                self.textField.resignFirstResponder()
                
                return
            }
            
        } else if (plusOn){
            
            let startAmount = Double(self.coinData.amount)
            let plusAmount = Double(self.txAmount)
            let newTotal = startAmount! + plusAmount!
            amountString = "\(newTotal)"
        }
        
        // save to myCoins and myCoinsTotals
        var tempArray = [String]()
        var tempTotalsArray = [Dictionary<String, String>]()
        let coinDic = ["id": "\(self.coinData.id)", "amount": amountString]
        
        // see if we have myCoins already
        if let myCoins = defaults.array(forKey: "myCoins") as? [String] {
            
            for coin in myCoins {
                tempArray.append(coin)
            }
            
            if let myCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
                
                for coinTotal in myCoinsTotals {
                    
                    if let id = coinTotal["id"] {
                        
                        if (id == self.coinData.id){
                            // don't add our current coin here
                        } else {
                             tempTotalsArray.append(coinTotal)
                        }
                    }
                }
            }
        
            if (tempArray.contains(self.coinData.id)) {
                // already has this coin
                // so we just add coinDic so the amount is updated
                tempTotalsArray.append(coinDic)
     
            } else {
                tempArray.append(self.coinData.id)
                tempTotalsArray.append(coinDic)
            }
            
        } else {
            // no myCoins array
            tempArray.append(self.coinData.id)
            tempTotalsArray.append(coinDic)
        }
        
        // save the new arrays to defaults
        defaults.set(tempArray, forKey:"myCoins")
        defaults.set(tempTotalsArray, forKey:"myCoinsTotals")
        
        // navigate back to home screen and refresh data
        performSegue(withIdentifier: "unwindFromCoinDetailVC", sender: self)
        
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
