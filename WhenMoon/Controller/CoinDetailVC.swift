//
//  CoinDetailVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/24/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

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
    var txAmount = "" //amount of the transaction
    
    var coinData: CoinData!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    func setupUI() {
        
        // update UI on main thread
        DispatchQueue.main.async {
            
            guard let coinData = self.coinData else { return }
        
            // name and symbol
            self.nameLbl.text = coinData.name
            self.symbolLbl.text = coinData.symbol
        
            // Amount
            let symbol = self.coinData.symbol
            if let amountDouble = Double(coinData.amount) {
                if let amount = amountDouble.decimalString(maxFractionDigits: 8) {
                    self.amountLbl.text = "\(amount) \(symbol)"
                }
            }
        
            // Price
            if coinData.priceUSD > 1000.0 {
                if let dollarString = coinData.priceUSD.dollarString() {
                    self.priceLbl.text = dollarString
                }
            } else if coinData.priceUSD > 10.0 {
            
                if let price = coinData.priceUSD.decimalString(maxFractionDigits: 4) {
                    self.priceLbl.text = "$\(price)"
                }
                
            } else {
                if let price = coinData.priceUSD.decimalString(maxFractionDigits: 6) {
                    self.priceLbl.text = "$\(price)"
                }
            }
        
            // set text and color of %change label
            var changeString = ""
            let change = coinData.percentChange24H
            let percentString = String(format: "%.2f", coinData.percentChange24H)
            if (change < 0.0) {
                self.changeLbl.textColor = darkRed
                changeString = "\(percentString)%"
            } else {
                self.changeLbl.textColor = darkGreen
                changeString = "+\(percentString)%"
            }
            self.changeLbl.text = changeString
        
            // value
            let value = coinData.value
            self.valueLbl.text = value.dollarString()
        
            // Edit Amount area
            self.editLbl.isHidden = false
            self.textField.isHidden = true
        
            self.minusBtn.isEnabled = true
            self.plusBtn.isEnabled = true
            self.deleteBtn.isEnabled = true
            self.saveBtn.isEnabled = false // nothing to save yet
        
            self.minusBtn.backgroundColor = nebulaGray
            self.plusBtn.backgroundColor = nebulaGray
            self.deleteBtn.backgroundColor = nebulaGray
            self.saveBtn.backgroundColor = nebulaGray
        
        
            // Coin logo image
            // The image to dowload
            if let url = URL(string:"\(LARGE_IMG_BASE_URL)\(coinData.idNumber).png") {
            
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                    if let error = error {
                        print("URL error: ", error.localizedDescription)
                        return
                    }
                
                    guard let data = data else { return }
                    guard let img = UIImage(data: data) else { return }
                
                    // update UI on main thread
                    DispatchQueue.main.async {
                        self.imgView.image = img
                    }
                }.resume()
            }
        }
    }

    @IBAction func cmcBtnTap(_ sender: Any) {
        
        if let url = URL(string: "https://www.coinmarketcap.com") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        // delete from myCoins and myCoinsTotals if they exist
        let idString = "\(self.coinData.idNumber)"
       
        if let myCoins = defaults.array(forKey: "myCoins") as? [String] {
            let myNewCoins = myCoins.filter { $0 != idString }
            defaults.set(myNewCoins, forKey:"myCoins")
        }
            
        if let myCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
            let myNewCoinsTotals = myCoinsTotals.filter { $0["id"] != idString }
            defaults.set(myNewCoinsTotals, forKey:"myCoinsTotals")
        }
        
        // navigate back to home screen and refresh data
        performSegue(withIdentifier: "unwindFromCoinDetailVC", sender: self)
    }
    
    
    func saveCoin() {
        
        // first do the math
        var amountString = ""
        
        if (minusOn) {
            
            guard let startAmount = Double(self.coinData.amount) else { return }
            guard let minusAmount = Double(self.txAmount) else { return }
            let newTotal = startAmount - minusAmount
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
            
            guard let startAmount = Double(self.coinData.amount) else { return }
            guard let plusAmount = Double(self.txAmount) else { return }
            let newTotal = startAmount + plusAmount
            amountString = "\(newTotal)"
        }
        
        // save to myCoins and myCoinsTotals
        var newCoins = [String]()
        var newTotals = [Dictionary<String, String>]()
        let idString = "\(self.coinData.idNumber)"
        let coinDic = ["id": idString, "amount": amountString]
       
        // see if we have myCoins already
        if let myCoins = defaults.array(forKey: "myCoins") as? [String] {
            if let myCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
                
                // see if this coin is already in myCoins
                if (myCoins.contains(idString)) {
                
                    // already have this coin so update its total
                    newTotals = myCoinsTotals.filter { $0["id"] != "\(self.coinData.idNumber)" }
                    newTotals.append(coinDic)
                    defaults.set(newTotals, forKey:"myCoinsTotals")
                    
                } else {
                    // just add the new coin
                    newCoins = myCoins
                    newCoins.append(idString)
                    defaults.set(newCoins, forKey:"myCoins")
                    newTotals = myCoinsTotals
                    newTotals.append(coinDic)
                    defaults.set(newTotals, forKey:"myCoinsTotals")
                }
            }
            
        } else {
            // myCoins doesn't exist yet, so we'll create it
            newCoins.append(idString)
            defaults.set(newCoins, forKey:"myCoins")
            newTotals.append(coinDic)
            defaults.set(newTotals, forKey:"myCoinsTotals")
        }
        
        // navigate back to home screen and refresh data
        performSegue(withIdentifier: "unwindFromCoinDetailVC", sender: self)
    }

}
