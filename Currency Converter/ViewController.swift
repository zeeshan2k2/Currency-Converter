//
//  ViewController.swift
//  Currency Converter
//
//  Created by Zeeshan Waheed on 14/03/2024.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {


    
    // IB Outlets (variables for all buttons)
    
    @IBOutlet var priceLabel: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    @IBOutlet var pickerView: UIPickerView!
    
    
    // properties
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        fetchJSON()
        
        textField.addTarget(self, action: #selector(updateViews), for: .editingChanged)
    }
    
    @objc func updateViews(input: Double) {
        guard let amountText = textField.text, let theAmountText = Double(amountText) else { return }
        if textField.text != "" {
            let total = theAmountText * activeCurrency
            priceLabel.text = String(format: "%.2f", total)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
    }
    
//  method
    
    func fetchJSON() {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle any errors if present
            if error != nil {
                print(error!)
                return
            }
            
            // safetly unwrap the data
            guard let safeData = data else { return }
            
            // decode the JSON Data
            do {
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
                // to check if we're getting the json data
                print(results.rates)
            } catch {
                print(error)
            }
            
        }.resume()
        
    }
    
}

