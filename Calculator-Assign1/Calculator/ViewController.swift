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
    
  
    
    
    
    override func viewDidLoad() {
        //
    }
   
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
    
    
   
    @IBAction func touchDecimalPoint(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        //first digit
        if !userIsInTheMiddleOfTyping  {
            display.text = "0" + digit
            //showDescription.text = " "
        }
        else {
            
            
           // (((display.text)?.rangeOfString(".")))
            
            
            
            let textCrurrentlyInDisplay = display.text!
            // “192.168.0.1” is not a legal floating point number!
            //if textCrurrentlyInDisplay.componentsSeparatedByString(".").count > 1
            if textCrurrentlyInDisplay.rangeOfString(".") == nil
            {
                display.text = textCrurrentlyInDisplay + digit
            }
            else {
                display.text = textCrurrentlyInDisplay
            }
            
            
            
            
        }
        
        userIsInTheMiddleOfTyping = true

        
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
        //display.text = brain.desc + displayValue.description
        display.text = displayValue.description
        if (brain.partialResult) {
            showDescription.text = brain.desc + brain.ThreePoints;
        } else {
            showDescription.text = brain.desc
        }
        
    }
    
    var propertyList : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        propertyList = brain.program
    }
    
    
    @IBAction func restore() {
        if propertyList != nil {
            brain.program = propertyList!
            displayValue = brain.result
        }
        
    }
    
    @IBOutlet weak var showDescription: UILabel!

    @IBAction func clear(sender: AnyObject) {
         brain.clear()
        showDescription.text = " "
        display.text = "0"
        
    }
    


}

