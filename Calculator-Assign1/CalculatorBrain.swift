//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by hn on 14/05/16.
//  Copyright © 2016 hn. All rights reserved.
//

import Foundation
/*
func multiply(op1: Double, op2:Double) -> Double{
    return op1 * op2
    
}

func division(op1: Double, op2:Double) -> Double{
    return op1 / op2
    
}

func addition(op1: Double, op2:Double) -> Double{
    return op1 + op2
    
}

func subtraction(op1: Double, op2:Double) -> Double{
    return op1 - op2
    
}
*/


class CalculatorBrain{
    
    private var accumulator = 0.0
    
    
    private var internalProgram = [AnyObject]()
    
    private var description = ""
    
    var ThreePoints : String {
        
        get { return "..."}
    }
    
    var EqualStr = "="
    
    private var isPartialResult = false
    
    func setOperand(operand : Double){
        internalProgram.append(operand)
        accumulator = operand
        
        description += operand.description
        
        //description += ThreePoints
        
        print(description)
        
    }
    
    
    var operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "log2": Operation.UnaryOperation(log2),
        "×": Operation.BinaryOperation({$0 * $1}),
        "÷": Operation.BinaryOperation({$0 / $1}),
        "−": Operation.BinaryOperation({$0 - $1}),
        "+": Operation.BinaryOperation({$0 + $1}),
        "=": Operation.Equals
        
    ]
    
    
    enum Operation {
      case Constant(Double)
      case UnaryOperation((Double) -> Double)
      case BinaryOperation((Double, Double) -> Double)
      case Equals
    
    
    }
    
    
    func performOperation(symbol : String) -> Double {
        
        internalProgram.append(symbol)
        
        
        let comps = description.componentsSeparatedByString(EqualStr)
        
        
        description =  comps[0] + symbol

        
        //description += symbol
        
        
        isPartialResult = false;
        
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                excecuteBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                isPartialResult = true;
            case .Equals:
                excecuteBinaryOperation()
            }
            
        }
        
        
        return accumulator
    }
    
    
    private func excecuteBinaryOperation() -> Double {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        return accumulator
        
    }
    
    
    private var pending: PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo{
        
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList{
        
        get {
            return internalProgram
        }
        set{
            clear()
            
            if let arrayOfObjs = newValue as? [AnyObject]{
                for op in arrayOfObjs {
                    
                    if let operand = op as? Double{
                        setOperand(operand)
                    }
                    else if let operand = op as? String{
                        
                        performOperation(operand)
                    }
                }
                
            }
            
            
            
        }
        
    }
    
    
    func clear(){
       internalProgram.removeAll()
       accumulator = 0.0
       pending = nil
       description = ""
       isPartialResult = false;
    }

    
    /*
    func performOperation(operation : String) ->
        Double {
            
            switch operation {
            case "π":
                accumulator = M_PI
            case "√":
                accumulator = sqrt(accumulator)
            default:
                break
            }
            return accumulator
    }*/
    
    var result: Double {
        
        get {
            return accumulator
        }
    }
    
    var desc: String {
        get {
            return description
        }
    }
    
    
    var partialResult: Bool {
        get {
            return isPartialResult;
        }
    }
    
}

