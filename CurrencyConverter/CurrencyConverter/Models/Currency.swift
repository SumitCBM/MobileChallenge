//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Sumit Panigrahi on 2017-01-13.
//  Copyright © 2017 Sumit Panigrahi. All rights reserved.
//

import Foundation

class Currency {
    var code : String = "USD"
    var value : Double = 1.0
    
    init(code : String, value : Double) {
        if code.isEmpty == false {
            self.code = code
        }
        
        if value != 0 {
            self.value = value
        }
    }
}
