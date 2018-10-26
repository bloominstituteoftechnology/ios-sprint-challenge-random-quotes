//
//  QuoteControlller.swift
//  RandomQuotes
//
//  Created by Linh Bouniol on 10/26/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class QuoteController {
    
    static let baseURL = URL(string: "https://andruxnet-random-famous-quotes.p.mashape.com/")!
    static let apiKey = "f4Gbv51qWQmshRRneu7T312vs1Qwp164MuIjsnVfxaH9SgAOSP"
    
    func fetchQuote(completion: @escaping (Quote?, Error?) -> Void) {
        
        let url = QuoteController.baseURL
        
        var request = URLRequest(url: url)
        request.setValue(QuoteController.apiKey, forHTTPHeaderField: "X-Mashape-Key")
        
        // don't need httpMethod, it is automatically "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching quote: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let quotes = try JSONDecoder().decode([Quote].self, from: data)
                DispatchQueue.main.async {
                    completion(quotes.first, nil)
                }
            } catch {
                NSLog("Unable to decode quote: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
        
    }
}
