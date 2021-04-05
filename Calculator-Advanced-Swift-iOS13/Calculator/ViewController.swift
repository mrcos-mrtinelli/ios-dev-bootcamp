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
        
        if let calcMethod = sender.currentTitle {
            switch calcMethod {
            case "+/-":
                displayValue *= -1
                
            case "%":
               displayValue /= 100
                
            default:
                displayValue = 0
            }
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

