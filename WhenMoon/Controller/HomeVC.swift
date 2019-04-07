//
//  HomeVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/20/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire

class HomeVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalChangeLbl: UILabel!
    
    var myCoins = [String]() // with v2, this needs to be array of coin IDs
    var myCoinsTotals = [Dictionary<String, String>]()
    var myCoinsData = [CoinData]()
    var allCoinsList = [CoinData]()
    var top100Data = [CoinData]()
    var selectedCoin: CoinData!
    var totalValue = 0.0
    var totalValueYesterday = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateCoinData()
    }
    
    func setupNavBar() {
        // navigation bar, set once and is used in rest of app
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.barTintColor = darkSky
        nav?.tintColor = banana
    }
    
    func setupTableView() {
        //  remove annoying space in tableview seperators
        tableView.separatorInset = .zero
        
        // Configure Refresh Control
        tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshCoinData(sender:)), for: .valueChanged)
    }
    
    
    func updateCoinData() {
        
        // we should refresh the local myCoins and myCoinsTotals from UserDefaults here
        // re-init both arrays to clear them out
       // self.myCoins = [String]()
       // self.myCoinsTotals = [Dictionary<String, String>]()
        
        if let mySavedCoins = defaults.array(forKey: "myCoins") as? [String] {
            myCoins = mySavedCoins
        } else {
            myCoins = [String]()
        }
        
       /* if let tempArray = defaults.array(forKey: "myCoins") as? [String] {
            for coin in tempArray {
                self.myCoins.append(coin)
            }
            
            
            
        } else {
            // no existing myCoins
        }*/
        
        if let mySavedCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
            myCoinsTotals = mySavedCoinsTotals
            
        } else {
            myCoinsTotals = [Dictionary<String, String>]()
        }
        
//        if let tempTotalsArray = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
//
//            for coinTotal in tempTotalsArray {
//                self.myCoinsTotals.append(coinTotal)
//            }
//        } else {
//            // no existing myCoinsTotals
//        }
        
        // get the coin data if we have an internet connection
    //    if (self.reachable()){
            
            // first get the list of all coins
            self.getAllCoins {
                
                print("we got all coins")
                
                // we need the price data for each coin in myCoins
                self.getPriceData()
            }
            
//        }  else {
//            // not online
//            // show alert
//            showAlertWith(title: "No Connection", message: "Please connect your device to WiFi to use When Moon??? app")
//        }
    }
    
    
    func getPriceData() {
        
        // clear out myCoinsData first before re-adding to it
        self.myCoinsData = [CoinData]()
        
        // we need to get the price data for each coin
        for coinID in self.myCoins {
            
            let coinURL = "\(TICKER_URL)\(coinID)/"
            
            Alamofire.request(coinURL).responseJSON { response in
                
                let result = response.result
                
                if let responseDic = result.value as? Dictionary<String, AnyObject> {
                    
                    if let coinDic = responseDic["data"] as? Dictionary<String, AnyObject> {
                        
                        print(coinDic)
                        
                        let name = coinDic["name"] as! String
                        let idInt = coinDic["id"] as! Int
                        let id = "\(idInt)"
                        var priceUSD = ""
                        var percentChange24H = ""
                        var amount = ""
                        var value = ""
                        let symbol = coinDic["symbol"] as! String
                        
                        let quotes = coinDic["quotes"] as! Dictionary<String, AnyObject>
                        let USD = quotes["USD"] as! Dictionary<String, AnyObject>
                        
                        let price = USD["price"] as! Double
                        priceUSD = "\(price)"
                        
                        var change = 0.0
                        if let changeDouble = USD["percent_change_24h"] as? Double {
                            change = changeDouble
                        }
                        percentChange24H = "\(change)"
                        
                        // get the amount from myCoinsTotals
                        for coin in self.myCoinsTotals {
                            
                            // find coin we want by the id
                            let coinID = coin["id"]
                            
                            if (id == coinID) {
                                
                                amount = coin["amount"] as String? ?? "0.0"
                            }
                        }
                        
                        // calculate the value by amount * priceUSD
                        // if one is missing, the value will be zero
                        let amountDouble = Double(amount)!
                        let priceDouble = Double(priceUSD)!
                        let valueDouble = amountDouble * priceDouble
                        
                        // put it back in the form of a string
                        value = "\(valueDouble)"
                        
                        let coinData = CoinData(name: name, symbol: symbol, id: id, priceUSD: priceUSD, percentChange24H: percentChange24H, amount: amount, value: value, valueDouble: valueDouble, rank: 0)
                        
                        self.myCoinsData.append(coinData)
                        
                        // check if we have data for all my coins yet
                        if (self.myCoinsData.count == self.myCoins.count){
                            
                            self.updateCoinValues()
                        }
                    }
                }
            }
        }
    }
    
    
    func updateCoinValues() {

        // after success getting the data
        print("We got the data for myCoins")
        print(self.myCoinsData)
        
        // Sort myCoinsData by highest value
        self.myCoinsData.sort { $0.valueDouble > $1.valueDouble }
        
        // display the total value and total percent change
        self.totalValue = 0.0
        self.totalValueYesterday = 0.0
        
        for coinData in self.myCoinsData{
            
            if let valueDouble = Double(coinData.value) {
                
                // first add to the totalValue
                self.totalValue = self.totalValue + valueDouble
                
                if let changeDouble = Double(coinData.percentChange24H) {
                    
                    // get the amount of the change
                    let changeAmount = valueDouble * (changeDouble/100)
                    
                    // subtract from today's value to get yesterday's value
                    let yesterdayAmount = valueDouble - changeAmount
                    
                    // add this coin's yesterday value to the total
                    self.totalValueYesterday = self.totalValueYesterday + yesterdayAmount
                }
            }
        }
        
        // Total Value
        // get NSNumber from the double
        let valueNumber = NSNumber(value: self.totalValue)
        
        // format to display as "$1,000.00"
        let dollarFormatter = NumberFormatter()
        dollarFormatter.usesGroupingSeparator = true
        dollarFormatter.numberStyle = .currency
        dollarFormatter.locale = Locale(identifier: "en_US")
        let valueString = dollarFormatter.string(from: valueNumber)
        
        self.totalValueLbl.text = valueString
        
        // Total Change
        let totalValueChange = self.totalValue - self.totalValueYesterday
        
        // find the percent totalValueChange is of totalValueYesterday
        let percentChange = (totalValueChange/self.totalValueYesterday) * 100
        
        // set color of %change label
        var percentString = ""
        if (percentChange < 0.0) {
            self.totalChangeLbl.textColor = brightRed
            percentString = String(format: "%.2f", percentChange)
            self.totalChangeLbl.text = "\(percentString)%"
        } else if (percentChange >= 0.0){
            self.totalChangeLbl.textColor = brightGreen
            percentString = String(format: "%.2f", percentChange)
            self.totalChangeLbl.text = "+\(percentString)%"
        } else {
            // if percentChange is not a number
            self.totalChangeLbl.textColor = brightGreen
            self.totalChangeLbl.text = "%"
        }
        
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    
    func getAllCoins(completed: @escaping DownloadComplete) {
        
        // clear allCoinsList before adding to it
        self.allCoinsList = [CoinData]()
        
        Alamofire.request(COIN_LIST_URL).responseJSON { response in
            
            let result = response.result
            
            if let responseDic = result.value as? Dictionary<String, AnyObject> {
                
                if let coinArray = responseDic["data"] as? [Dictionary<String, AnyObject>] {
                    
                    let coinCount = coinArray.count
                    print("We have \(coinCount) coins")
                    
                    for coinDic in coinArray {
                        
                        var id = ""
                        var name = ""
                        var symbol = ""
                        
                        if let _id = coinDic["id"] as? Int {
                            id = "\(_id)"
                        }
                        
                        if let _name = coinDic["name"] as? String {
                            name = _name
                        }
                        
                        if let _symbol = coinDic["symbol"] as? String {
                            symbol = _symbol
                        }
                        
                        let coinData = CoinData(name: name, symbol: symbol, id: id, priceUSD: "", percentChange24H: "", amount: "", value: "", valueDouble: 0.0, rank: 0)
                        
                        self.allCoinsList.append(coinData)
                    }
                }
            }
            completed()
        }
    }
   
    
    func getTop100(completed: @escaping DownloadComplete) {
        
        // clear top100Data before adding to it
        self.top100Data = [CoinData]()
        
        Alamofire.request(TICKER_URL).responseJSON { response in
            
            let result = response.result
            
            if let responseDic = result.value as? Dictionary<String, AnyObject> {
                
                if let coinsDic = responseDic["data"] as? Dictionary<String, AnyObject> {
                    
                    print(coinsDic)
                    
                    // clear top100Data before adding to it
                    self.top100Data = [CoinData]()
                    
                    for coinDic in coinsDic.values {
                        print("\(coinDic)")
                        
                        // create coinData object
                        let rank = coinDic["rank"] as! Int
                        let idInt = coinDic["id"] as! Int
                        let id = "\(idInt)"
                        let name = coinDic["name"] as! String
                        let symbol = coinDic["symbol"] as! String
                        
                        var priceUSD = ""
                        var percentChange24H = ""
                        let amount = ""
                        let value = ""
                    
                        let quotes = coinDic["quotes"] as! Dictionary<String, AnyObject>
                        let USD = quotes["USD"] as! Dictionary<String, AnyObject>
                        
                        let price = USD["price"] as! Double
                        priceUSD = "\(price)"
                        
                        var change = 0.0
                        if let changeDouble = USD["percent_change_24h"] as? Double {
                            change = changeDouble
                        }
                        percentChange24H = "\(change)"
                        
                        let coinData = CoinData(name: name, symbol: symbol, id: id, priceUSD: priceUSD, percentChange24H: percentChange24H, amount: amount, value: value, valueDouble: 0.0, rank: rank)
                        
                        self.top100Data.append(coinData)
                    }
                    
                    // Sort top100Data by rank
                    self.top100Data.sort { $0.rank < $1.rank }
                }
            }
            completed()
        }
    }
    

    @objc private func refreshCoinData(sender: Any) {
   
        // update the coin data
        updateCoinData()
     
    }
    
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCoinsData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinCell", for: indexPath) as! CoinCell
        
        let coinData = myCoinsData[indexPath.row]
        
        let name = coinData.name
        let symbol = coinData.symbol
        
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
        let value = valueString
        
        
        // Amount
        // get NSNumber from the string
        let amountDouble = Double(coinData.amount)
        let amountNumber = NSNumber(value: amountDouble!)
        
        // format to display as 0.145
        let amountFormatter = NumberFormatter()
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.numberStyle = .decimal
        
        let amountString = amountFormatter.string(from: amountNumber)
        let amount = amountString
        
        
        // Price
        // get NSNumber from the string
        let priceDouble = Double(coinData.priceUSD)
        let priceNumber = NSNumber(value: priceDouble!)
        
        // use amountFormatter
        let priceString = amountFormatter.string(from: priceNumber)
        let price = "$\(priceString!)"
        
        // set color of %change label
        var change = ""
        let changeDouble = Double(coinData.percentChange24H)
        if (changeDouble! < 0.0) {
            cell.changeLbl.textColor = darkRed
            change = "\(coinData.percentChange24H)%"
        } else {
            cell.changeLbl.textColor = darkGreen
            change = "+\(coinData.percentChange24H)%"
        }
        
        cell.nameLbl.text = name
        cell.valueLbl.text = value
        cell.amountLbl.text = "\(amount!) \(symbol)"
        cell.priceLbl.text = price
        cell.changeLbl.text = change
        
        // The image to dowload
        let imgURL = URL(string:"\(MEDIUM_IMG_BASE_URL)\(coinData.id).png")!
        
        // Use Alamofire to download the image
        Alamofire.request(imgURL).responseData { (response) in
            
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    cell.coinLogo.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coinData: CoinData
        coinData = self.myCoinsData[indexPath.row]
        self.selectedCoin = coinData
        
        performSegue(withIdentifier: "goToCoinDetailVC", sender: self)
        
    }
    
    
    
    @IBAction func addCoin(_ sender: Any) {
        
        performSegue(withIdentifier: "goToAddCoinVC", sender: self)
        
    }
    
    
    @IBAction func cryptoLoveBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "goToCryptoLoveVC", sender: self)
    }
    
    
    @IBAction func top100BtnPressed(_ sender: Any) {
        
        // get the coin data if we have an internet connection
        if (self.reachable()){
            
            getTop100 {
                // navigate to top100 page
                self.performSegue(withIdentifier: "goToTop100VC", sender: self)
            }
            
        } else {
            // not online
            // show alert
            showAlertWith(title: "No Connection", message: "Please connect your device to WiFi to use When Moon??? app")
        }
       
    }
    
    
    
    @IBAction func unwindFromCoinDetailVC(_ sender: UIStoryboardSegue) {
        
        if sender.source is CoinDetailVC {
            
            // reload the data because the myCoins and myCoinsTotals may have changed
            updateCoinData()
        }
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        // We set the back button text blank to have a simple arrow
        // This will show in the next view controller being pushed
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem 
        
        if segue.identifier == "goToAddCoinVC" {
            
            if let vc = segue.destination as? AddCoinVC {
               vc.allCoinsList = self.allCoinsList
            }
        }
        
        if segue.identifier == "goToCoinDetailVC" {
            
            if let vc = segue.destination as? CoinDetailVC {
                vc.coinData = self.selectedCoin
            }
        }
        
        if segue.identifier == "goToTop100VC" {
            
            if let vc = segue.destination as? Top100VC {
                vc.top100Data = self.top100Data
            }
        }
    }
    

}
