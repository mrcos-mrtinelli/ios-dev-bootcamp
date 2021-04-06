//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    // private to current scope
    private var calculator = CalculatorManager()
    private var isDoneTyping: Bool = true
    
    private var displayValue: Double {
        get {
            // force unwrapping because the display will always contain text
            guard let number = Double(displayLabel.text!) else { fatalError("Unable to covert display to double" ) }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        
        calculator.setNumber(displayValue)
        
        guard let button = sender.currentTitle else { fatalError("button not found") }
        
        if let result = calculator.calculate(symbol: button) {
            displayValue = result
        }
        
        isDoneTyping.toggle()
    
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        if let numberTapped = sender.currentTitle {
            
            if isDoneTyping {
                displayLabel.text = numberTapped
                isDoneTyping.toggle()
            } else {
                
                if numberTapped == "." {
                    
                    guard let currentValue = Double(displayLabel.text!) else { fatalError("Unable to convert num to double" ) }
                    
                    let isInt = floor(currentValue) == currentValue
                    
                    if !isInt {
                        return
                    }
                    
                }
                
                displayLabel.text! += numberTapped
            }
        }
    
    }

}

