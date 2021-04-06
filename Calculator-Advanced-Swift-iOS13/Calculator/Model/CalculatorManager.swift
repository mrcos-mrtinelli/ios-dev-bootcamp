//
//  CalculatorManager.swift
//  Calculator
// 
//  by mrcos-mrtinelli
//

import Foundation

class CalculatorManager {
    
    func calculate(symbol: String, value: Double) -> Double {
        
        switch symbol {
        case "+/-":
            return value * -1
            
        case "%":
           return value / 100
            
        default:
            return 0.0
        }
    }
}
