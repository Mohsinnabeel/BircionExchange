//
//  BitcoinExchangeViewController.swift
//  BitcoinExchange
//
//  Created by Mohsin Nabeel on 15/10/2019.
//  Copyright © 2019 Mohsin Nabeel. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class BitcoinExchangeViewController: UIViewController , UIPickerViewDelegate , UIPickerViewDataSource {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
   
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PKR","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currenecySymbolsArray = ["$", "R$", "$", "Â¥", "â‚¬", "Â£", "$", "Rp", "â‚ª", "â‚¹", "Â¥", "$", "kr", "$", "Rs", "zÅ‚", "lei", "â‚½", "kr", "$", "$", "R"]
    

    var finalURL = ""
    var symbolForSelectedCurrency = ""
    
    //Outlets
    
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var bitcoinValueTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        
        
        
        
//        let textColor = UIColor.white.cgColor
//        pickerView.setValue(textColor, forKey: "textColor")

        
    }
    

    
    
    //Delegate Methods are implemented here...
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        finalURL = baseURL + currencyArray[row]
        
        symbolForSelectedCurrency = currenecySymbolsArray[row]
        getBitcoinData(url: finalURL)
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return currencyArray[row]
//    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let string = currencyArray[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }


    
    
    
    
    //Networking Functions
    
    func getBitcoinData(url : String)
    {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let bitcoinJSON : JSON = JSON(response.result.value as Any)
                self.updateBitcoinExchangeValue(json : bitcoinJSON)
                
            } else {
                print ("Error : \(String(describing: response.result.error))")
                self.bitcoinValueTextView.text = "Connection Error"
            }
        }
    }
    
    
    func updateBitcoinExchangeValue(json : JSON)
    {
        if let bitcoinValue = json["ask"].double
        {
            self.bitcoinValueTextView.text = symbolForSelectedCurrency + String(bitcoinValue)
        } else {
            
            self.bitcoinValueTextView.text = "Data Unavalable"
        }
    }
    
    
}
