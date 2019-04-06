//
//  Top100VC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 5/13/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit
import Alamofire

class Top100VC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var top100Data = [CoinData]()

    override func viewDidLoad() {
        super.viewDidLoad()


        
        //  remove annoying space in tableview seperators
        tableView.separatorInset = .zero
        
        self.view.backgroundColor = darkSky
        
        // Configure Refresh Control
        tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshCoinData(sender:)), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return top100Data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top100Cell", for: indexPath) as! Top100Cell
        
        let coinData = self.top100Data[indexPath.row]
        
        let rank = indexPath.row + 1
        let coinRank = "\(rank)"
        let coinSymbol = coinData.symbol
        let coinName = coinData.name
        
        // format to display as 0.145
        let amountFormatter = NumberFormatter()
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.numberStyle = .decimal
        
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
        
        cell.symbolLbl.text = coinSymbol
        cell.nameLbl.text = coinName
        cell.rankLbl.text = coinRank
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
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }*/
    
    
    @objc private func refreshCoinData(sender: Any) {
   
        // get the coin data if we have an internet connection
        if (self.reachable()){
    
            // update the coin data
            getTop100 {
                self.refreshControl.endRefreshing()
            }
        
        }  else {
            
            let alert = UIAlertController(title: "No Connection", message: "Please connect your device to WiFi to use When Moon??? app", preferredStyle: .alert)
        
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                
               self.refreshControl.endRefreshing()
            })
           
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    
    func getTop100(completed: @escaping DownloadComplete) {
        
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
                        let change = USD["percent_change_24h"] as! Double
                        percentChange24H = "\(change)"
                        
                        let coinData = CoinData(name: name, symbol: symbol, id: id, priceUSD: priceUSD, percentChange24H: percentChange24H, amount: amount, value: value, valueDouble: 0.0, rank: rank)
                        
                        self.top100Data.append(coinData)
                    }
                    
                    // Sort top100Data by rank
                    self.top100Data.sort { $0.rank < $1.rank }
                    
                    print("Count = \(self.top100Data.count)")
                    
                    self.tableView.reloadData()
                }
            }
            completed()
        }
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
