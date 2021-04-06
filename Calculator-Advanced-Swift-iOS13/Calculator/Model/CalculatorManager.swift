//
//  CalculatorManager.swift
//  Calculator
// 
//  by mrcos-mrtinelli
//

import Foundation

struct CalculatorManager {
    
    private var number: Double?
    private var intermediateCalculation: (n1: Double, symbol: String)?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func calculate(symbol: String) -> Double? {
        
        guard let number = self.number else { fatalError("no number found") }
        
        switch symbol {
        case "+/-":
            return number * -1
            
        case "%":
           return number / 100
            
        case "=":
            return performCalculation(n2: number)
            
        case "AC":
            return 0
            
        default:
            intermediateCalculation = (n1: number, symbol: symbol)
        }
        
        return nil
    }
    
    private func performCalculation(n2: Double) -> Double? {
        
        if let n1 = intermediateCalculation?.n1,
           let operation = intermediateCalculation?.symbol {
            
            switch operation {
            case "+":
                return n1 + n2
            
            case "-":
                return n1 - n2
                
            case "÷":
                return n1 / n2
                
            case "×":
                return n1 * n2
                
            default:
                print(operation)
            }
            
        }
        
        return nil
        
    }
}
