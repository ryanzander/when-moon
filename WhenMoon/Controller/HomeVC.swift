//
//  HomeVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/20/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class HomeVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalValueLbl: UILabel!
    @IBOutlet weak var totalChangeLbl: UILabel!
    
    var myCoins = [String]() // array of coin IDs
    var myCoinsTotals = [Dictionary<String, String>]()
    var myCoinsData = [CoinData]()
    var allCoinsData = [CoinData]()
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
        if let mySavedCoins = defaults.array(forKey: "myCoins") as? [String] {
            myCoins = mySavedCoins
        } else {
            myCoins = [String]()
        }
        
        if let mySavedCoinsTotals = defaults.array(forKey: "myCoinsTotals") as? [Dictionary<String, String>] {
            myCoinsTotals = mySavedCoinsTotals
            
        } else {
            myCoinsTotals = [Dictionary<String, String>]()
        }
        
        
        // now get the list of all coins
        getAllCoins() { result in
            
            switch result {
            case .success(let coins):
              
                // we have the list of all coins
                self.allCoinsData = coins
                
                // now we need the price data for each coin in myCoins
                self.getPriceData()
                
            case .failure(let error):
                let message = error.localizedDescription
                self.showAlertWith(title: "Error", message: message)
            }
        }
    }
    
    
    // we get a list of all coins
    func getAllCoins(completion: @escaping (Result<[CoinData], Error>) -> ()) {
        
        // components with parameters
        var components = URLComponents(string: LATEST_URL)!
        components.queryItems = [
            URLQueryItem(name: "start", value: "1"),
            URLQueryItem(name: "limit", value: "5000")
        ]
        guard let url = components.url else { return }
        
        // make request
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accepts")
        request.setValue(API_KEY, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
       
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // success
            guard let data = data else { return }
            do {
                guard let responseDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                guard let dataArray = responseDic["data"] as? [[String: Any]] else { return }
                
                let coins = dataArray.map( { (dic: [String: Any]) -> CoinData in
                    let coin = CoinData(dic: dic)
                    return coin
                })
                completion(.success(coins))
              
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    
    // we get current price data for all myCoins
    func getPriceData() {
        
        myCoinsData = allCoinsData.filter { myCoins.contains("\($0.idNumber)") }
        
        // update on main thread
        DispatchQueue.main.async {
            self.updateCoinValues()
        }
    }
    
    
    func updateCoinValues() {
        
        // display the total value and total percent change
        // use yesterday's total value to calculate the total percent change
        totalValue = 0.0
        totalValueYesterday = 0.0
        
        for coinData in myCoinsData {
            
            let idNumber = coinData.idNumber
            
            // first add the amount and value to myCoinsData
            for coinTotalDic in myCoinsTotals {
                if coinTotalDic["id"] == "\(idNumber)" {
                    if let amount = coinTotalDic["amount"] {
                        coinData.amount = amount
                        if let amountDouble = Double(amount) {
                            coinData.value = amountDouble * coinData.priceUSD
                        }
                    }
                }
            }
            
            // add value to the totalValue
            totalValue += coinData.value
            
            // get yesterdayValue
            let yesterdayValue = coinData.value / ( 1 + (coinData.percentChange24H/100))
            
            // add to total yesterday value
            totalValueYesterday += yesterdayValue
        }
        
        // calculate total percent change
        let totalPercentChange = ((totalValue/totalValueYesterday) - 1) * 100
        
        // update the total value label
        if let valueString = totalValue.dollarString() {
                self.totalValueLbl.text = valueString
        }
        
        // set color and text of %change label
        var percentString = ""
        if (totalPercentChange < 0.0) {
            self.totalChangeLbl.textColor = brightRed
            percentString = String(format: "%.2f", totalPercentChange)
            self.totalChangeLbl.text = "\(percentString)%"
        } else if (totalPercentChange >= 0.0){
            self.totalChangeLbl.textColor = brightGreen
            percentString = String(format: "%.2f", totalPercentChange)
            self.totalChangeLbl.text = "+\(percentString)%"
        } else {
            // if something went wrong
            self.totalChangeLbl.textColor = brightGreen
            self.totalChangeLbl.text = "%"
        }
            
        // Sort myCoinsData by highest value
        myCoinsData.sort { $0.value > $1.value }
        
        self.refreshControl.endRefreshing()
        self.tableView.reloadData()
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
        cell.coinData = coinData
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coinData = self.myCoinsData[indexPath.row]
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
        
        let arraySlice = allCoinsData.prefix(100)
        self.top100Data = Array(arraySlice)
        
        self.performSegue(withIdentifier: "goToTop100VC", sender: self)
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
               vc.allCoinsData = self.allCoinsData
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
