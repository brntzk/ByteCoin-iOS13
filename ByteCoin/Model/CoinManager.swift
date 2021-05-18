//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","TRY"]
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "api key here"
    
    
    
    
    func getCoinPrice(forCurrency: String) {
        let urlString = "\(baseURL)/\(forCurrency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let bitcoinPrice = parseJSON(safeData){
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: forCurrency)
                    }
                }
//                let dataAsString = String(data: data!, encoding: .utf8)
//                print(dataAsString)
                
            }
            
            task.resume()
        }
        
        func parseJSON (_ data: Data) -> Double? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: data)
                let lastPrice = decodedData.rate
                print(lastPrice)
                return lastPrice
                
            } catch {
                print(error)
                return nil
            }
        }
    }
}
//        https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=A4E60405-C091-43BD-8777-5C651CF92D13
//        rate
//weather[0].description
//weather[0].main
//weather[0].id
//main.temp
//name


//rate
