//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Sumit Panigrahi on 2017-01-13.
//  Copyright © 2017 Sumit Panigrahi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var baseCurrencyButton: UIButton!
    
    @IBOutlet weak var ratesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButtonView = UIToolbar.init()
        doneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(ViewController.doneClicked))
        
        doneButtonView.items = [doneButton]
        amountTextField.inputAccessoryView = doneButtonView

        baseCurrencyButton.setTitle(StorageManager.sharedInstance.baseCurrency, for: .normal)
        baseCurrencyButton.isUserInteractionEnabled = false
        
        downloadCurrnecyConversionRates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func baseCurrencyButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.currencyPickerView.isHidden = false
            self.ratesTableView.alpha = 0
        }
    }
    
    // MARK:- UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StorageManager.sharedInstance.currencies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.ratesTableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        
        var amount = 1.0
        if amountTextField.text?.isEmpty == false {
            amount = Double(amountTextField.text!)!
        }
        let valueAndCode = "\(amount * StorageManager.sharedInstance.currencies[indexPath.row].value) \(StorageManager.sharedInstance.currencies[indexPath.row].code)"
        cell?.textLabel?.text = valueAndCode
        
        return cell!
    }
    
    // MARK:- UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Int(string) != nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ratesTableView.reloadData()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK:- UITextField Tool Bar Butto Click Event Handling Method
    func doneClicked() {
        self.view.endEditing(true)
        
        if amountTextField.text?.isEmpty == false {
            ratesTableView.reloadData()
        }

        amountTextField.resignFirstResponder()
    }
    
    // MARK:- UIPickerViewDataSource Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StorageManager.sharedInstance.currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return StorageManager.sharedInstance.currencies[row].code
    }
    
    // MARK:- UIPickerViewDelegate Methods
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let baseCurrency = StorageManager.sharedInstance.currencies[row].code
        StorageManager.sharedInstance.baseCurrency = baseCurrency
        baseCurrencyButton.setTitle(baseCurrency, for: .normal)
        
        downloadCurrnecyConversionRates()
        UIView.animate(withDuration: 0.5) {
            self.currencyPickerView.isHidden = true
            self.ratesTableView.alpha = 1
        }

    }
    
    // MARK:- Private Methods
    func downloadCurrnecyConversionRates() {
        APIClientManager.sharedInstance.downloadCurrencyConversionData() {
            (currencyConversionDict, error) in
            if let error = error {
                // Alert for error
                let alert : UIAlertController = UIAlertController(title: "Service Error", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                let alertOkButton : UIAlertAction = UIAlertAction(title: "dismiss", style: UIAlertActionStyle.default) {
                    (alertOk) -> Void in
                }
                alert.addAction(alertOkButton)
                self.present(alert, animated: true) {
                    () -> Void in
                }
                print(error.code)
            } else {
                if let currencyDict = currencyConversionDict {
                    if currencyDict.count > 0 {
                        self.baseCurrencyButton.isUserInteractionEnabled = true
                        // Valid Data
                        // Get the rates
                        if let ratesDictionary = currencyDict["rates"] as? NSDictionary {
                            if ratesDictionary.count > 0 {
                                let storedCurrencyCount = StorageManager.sharedInstance.currencies.count
                                if storedCurrencyCount <= ratesDictionary.count {
                                    // Update the value
                                    var latestCurrencies = [Currency]()
                                    for (key, value) in ratesDictionary {
                                        let currency = Currency.init(code: key as! String, value: value as! Double)
                                        latestCurrencies.append(currency)
                                    }
                                    StorageManager.sharedInstance.currencies = latestCurrencies
                                    
                                    self.ratesTableView.reloadData()
                                    self.currencyPickerView.reloadAllComponents()
                                    // Cancel if there was a request pending
                                    NSObject.cancelPreviousPerformRequests(withTarget: self)
                                    // Fetch it again after 30 minutes
                                    self.perform(#selector(ViewController.downloadCurrnecyConversionRates), with: nil, afterDelay: 1800)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

