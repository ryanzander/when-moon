//
//  NetworkService.swift
//  WhenMoon
//
//  Created by Ryan Zander on 4/7/19.
//  Copyright © 2019 Ryan Zander. All rights reserved.
//

/*
import Foundation

class NetworkService {
    
    public static let shared = NetworkService()
    private init() {}
    
    func getAllCoins(completion: @escaping (Result<[CoinData], Error>) -> Void)  {
        
        guard let url = URL(string: COIN_LIST_URL) else {
            completion(Result.failure())
            return
        }
        
        // complicated networking code here
        print("Fetching \(url.absoluteString)...")
        completion(.success(5))
        
        
        
    }
        
     //    func getWeather(completion: @escaping (Weather?, Error?) -> ()) {
      
        
        // clear allCoinsList before adding to it
        var allCoinsList = [CoinData]()
        
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
    
    
    
    
}
*/
