//
//  ViewController.swift
//  Calculator
//
//  Created by hn on 14/05/16.
//  Copyright © 2016 hn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
   
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        
        
        if userIsInTheMiddleOfTyping {
           let textCrurrentlyInDisplay = display.text!
           display.text = textCrurrentlyInDisplay + digit
        } else {
           display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
        
        //print("touched  \(digit) digit")
    }
    
    private var displayValue: Double{
      
        get{
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue);
        }
    
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()

    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            
           brain.setOperand(displayValue)
            
        
           userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        displayValue = brain.result
    }
}

