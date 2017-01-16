//
//  APIClientManager.swift
//  CurrencyConverter
//
//  Created by Sumit Panigrahi on 2017-01-13.
//  Copyright © 2017 Sumit Panigrahi. All rights reserved.
//

import Foundation
import Alamofire

class APIClientManager: NSObject
{
    // MARK: Shared Instance for the singleton object
    static let sharedInstance : APIClientManager = {
        let instance = APIClientManager()
        return instance
    }()
    
    override init() {
    }
    
    // MARK:- Download Currency Conversion Rates
    // Returns the JSON File as Dictionary
    func downloadCurrencyConversionData(completion:((NSDictionary?, NSError?) -> Void)!) {
        let feedURL = BaseURL + StorageManager.sharedInstance.baseCurrency
        Alamofire.request(feedURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            if let error : NSError = response.result.error  as? NSError {
                completion(nil, error)
            }
            
            if let data = response.data {
                DispatchQueue.main.async(execute: {
                    // Parse the JSON Data and fill it into Dictionary
                    let dataDictionary = NSDictionary.createDictionary(jsonData: data as NSData!)
                    completion(dataDictionary, nil)
                })
            } else if let response = response.response {
                print(response.statusCode)
            }
        }
    }
}
