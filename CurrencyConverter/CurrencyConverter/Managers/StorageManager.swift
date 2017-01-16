//
//  StorageManager.swift
//  CurrencyConverter
//
//  Created by Sumit Panigrahi on 2017-01-13.
//  Copyright © 2017 Sumit Panigrahi. All rights reserved.
//

import Foundation

class StorageManager: NSObject
{
    var baseCurrency : String = "USD"
    var currencies : [Currency] = [Currency]()
    
    // MARK: Shared Instance for the singleton object
    static let sharedInstance : StorageManager = {
        let instance = StorageManager()
        return instance
    }()
    
    override init() {
    }
}
