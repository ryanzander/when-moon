//
//  AddCoinVC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 1/24/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

class AddCoinVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allCoinsList = [CoinData]()
    var filteredCoins = [CoinData]()
    var selectedCoin: CoinData!
    var myCoins = [String]()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Coins"
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchBar.barTintColor = darkSky
        searchController.searchBar.tintColor = banana
        
        //  remove annoying space in tableview seperators
        tableView.separatorInset = .zero
        
        self.view.backgroundColor = darkSky
        
        // get list of myCoins from UserDefaults
        if let tempArray = defaults.array(forKey: "myCoins") as? [String] {
            for coin in tempArray {
                self.myCoins.append(coin)
            }
        } else {
            // no existing myCoins
        }
    }

    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchBarIsEmpty()) {
            return self.allCoinsList.count
        } else {
            return self.filteredCoins.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let coinData: CoinData
        if (searchBarIsEmpty()) {
            coinData = self.allCoinsList[indexPath.row]
        } else {
            coinData = self.filteredCoins[indexPath.row]
        }
        
        let coinSymbol = coinData.symbol
        let coinName = coinData.name
        let textString = "\(coinSymbol) – \(coinName)"
        
        cell.textLabel!.text = textString
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coinData: CoinData
        if (searchBarIsEmpty()) {
            coinData = self.allCoinsList[indexPath.row]
        } else {
            coinData = self.filteredCoins[indexPath.row]
        }
        
        self.selectedCoin = coinData
        
        // if the selectedCoin exists in myCoins, we won't double-add it
        for coin in myCoins {
            if coin == "\(self.selectedCoin.idNumber)" {
                
                showAlertWith(title: "Duplicate coin", message: "You already have \(selectedCoin.name) in your list of coins")
                
                return
            }
        }
        
        // with v2 api, we need to look up the full data for the selected coin
        self.getCoinData()
    }
    
    
    func getCoinData() {
        
        let coinID = selectedCoin.idNumber
        let coinURL = "\(TICKER_URL)\(coinID)/"
        guard let url = URL(string: coinURL) else { return }
        
        getCoinDataFor(url: url, completion:  { result in
            
            switch result {
            case .success(let coinData):
                // reset selectedCoin with the full data
                self.selectedCoin = coinData
                
                // back to main thread
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToCoinDetailVC", sender: self)
                }
                
            case .failure(let error):
                let message = error.localizedDescription
                self.showAlertWith(title: "Error", message: message)
            }
        })
    }
    
    
    func getCoinDataFor(url: URL, completion: @escaping (Result<CoinData, Error>) -> ()) {
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // success
            guard let data = data else { return }
            do {
                guard let responseDic = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                guard let coinDic = responseDic["data"] as? [String: Any] else { return }
                
                let coinData = CoinData.init(dic: coinDic)
                completion(.success(coinData))
                
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    
    // MARK: - Search Bar
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        filteredCoins = allCoinsList.filter({( coinData : CoinData) -> Bool in
            
            let inName = coinData.name.lowercased().contains(searchText.lowercased())
            let inSymbol = coinData.symbol.lowercased().contains(searchText.lowercased())
            
            if (inName || inSymbol) {
                return true
            } else {
                return false
            }
        })
        
        tableView.reloadData()
    }
    

    
    // MARK: - Navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    // We set the back button text blank to have a simple arrow
    // This will show in the next view controller being pushed
    let backItem = UIBarButtonItem()
    backItem.title = ""
    navigationItem.backBarButtonItem = backItem
 
    if segue.identifier == "goToCoinDetailVC" {
 
        if let vc = segue.destination as? CoinDetailVC {
            vc.coinData = self.selectedCoin
        }
    }
 }

    
    
}

extension AddCoinVC: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
  
}


