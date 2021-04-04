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
    
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
//        guard let buttonTapped = sender.currentTitle else { return }
        
        isDoneTyping.toggle()
    
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        
        if let numberTapped = sender.currentTitle {
            
            if isDoneTyping {
                displayLabel.text = numberTapped
                isDoneTyping.toggle()
            } else {
                displayLabel.text! += numberTapped
            }
        }
    
    }

}

