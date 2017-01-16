//
//  Extensions.swift
//  CurrencyConverter
//
//  Created by Sumit Panigrahi on 2017-01-13.
//  Copyright © 2017 Sumit Panigrahi. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func getStringForKey(keyValue: String, defaultValue: String) -> String {
        if let retValue: String = self[keyValue as! Key] as? String {
            return retValue as String
        }
        return defaultValue
    }
    
    func getStringifiedValueForKey(keyValue: String, defaultValue: String) -> String {
        if let retValue = self[keyValue as! Key] as? NSString {
            return retValue as String
        }
        
        if let retValue = self[keyValue as! Key] as? NSNumber {
            return "\(retValue)"
        }
        return defaultValue
    }
}

extension NSDictionary {
    class func createDictionary(jsonData: NSData!) -> NSDictionary {
        do {
            if let data = jsonData, let dictionary = try JSONSerialization.jsonObject(with: data as Data, options: []) as? NSDictionary {
                return dictionary
            }
        } catch {
            print(error)
        }
        
        return NSDictionary()
    }
    
    func getIntForKey(keyValue: String) -> Int {
        let result : Int = NSNotFound
        
        if self[keyValue] is NSNull {
            return result
        } else if self[keyValue] != nil {
            if let retValue: Int = self[keyValue] as? Int {
                return retValue
            } else {
                return result
            }
        } else {
            return result
        }
    }
    
    func getBoolForKey(keyValue: String) -> Bool {
        let result : Bool = false
        if self[keyValue] is NSNull {
            return result
        } else if self[keyValue] != nil {
            if let retValue: Bool = self[keyValue] as? Bool {
                return retValue
            }
        }
        return result
    }
    
    func getDoubleForKey(keyValue: String) -> Double {
        let result = 0.0
        if self[keyValue] is NSNull {
            return result
        } else if self[keyValue] != nil {
            if let retValue: Double = self[keyValue] as? Double {
                return retValue
            } else {
                return result
            }
        }
        
        return result
    }
    
    func getNSDateForKey(keyValue: String) -> NSDate {
        let stamp = TimeInterval(getIntForKey(keyValue: keyValue))
        return NSDate(timeIntervalSince1970: stamp)
    }
    
    func getArrayForKey(keyValue: String) -> NSArray {
        let result = NSArray()
        if self[keyValue] is NSNull {
            return result
        } else if let retValue: NSArray = self[keyValue] as? NSArray {
            return retValue
        }
        
        return result
    }
    
    func getStringForKey(keyValue: String) -> String {
        var result : String = ""
        if self[keyValue] is NSNull {
            return result
        } else {
            if self[keyValue] != nil {
                if let retValue: String = self[keyValue] as? String {
                    result = retValue.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
            }
        }
        return result
    }
    
    func getURLForKey(keyValue: String) -> NSURL {
        let urlString = getStringForKey(keyValue: keyValue)
        
        if !urlString.isEmpty {
            return URL.init(string: urlString.removingPercentEncoding!)! as NSURL
        }
        
        return URL.init(string: "")! as NSURL
    }
    
}
