//
//  Top100VC.swift
//  WhenMoon
//
//  Created by Ryan Zander on 5/13/18.
//  Copyright © 2018 Ryan Zander. All rights reserved.
//

import UIKit

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
    
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return top100Data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell = tableView.dequeueReusableCell(withIdentifier: "Top100Cell", for: indexPath) as! Top100Cell
        
        let coinData = self.top100Data[indexPath.row]
        cell.coinData = coinData
        return cell
    }
    
    
    
    @objc private func refreshCoinData(sender: Any) {
        
        getTop100(completion: { result in
            
            switch result {
            case .success(let coins):
                
                self.top100Data = coins
                
                // back to main thread
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
                
            case .failure(let error):
                let message = error.localizedDescription
                self.showAlertWith(title: "Error", message: message)
            }
        })
    }
    
   
    func getTop100(completion: @escaping (Result<[CoinData], Error>) -> ()) {
        
        // with no parameters, LATEST_URL returns top 100 coins by default
        guard let url = URL(string: LATEST_URL) else { return }
        
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
   

}
