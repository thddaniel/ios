//
//  ViewController.swift
//  Calculator
//
//  Created by tanghao on 21/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var display: UILabel!

    var userTyping = false
//    var instoreNumberArray = Array<Double>()
    var brain = CalculatorBrain()
    
    
    @IBAction func numberButton(sender: UIButton) {
        let number = sender.currentTitle!
        
        if userTyping{
            
            display.text = display.text! + number
            
        }else{
            display.text = number
            userTyping = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userTyping{
            enterButton()
        }
        if let symbol = sender.currentTitle{
//            switch symbol {
//            case "+": performOperation{$0+$1}
//            case "−": performOperation{$1-$0}
//            case "×": performOperation{$0*$1}
//            case "÷": performOperation{$1/$0}
//            case "√": performOperation{sqrt($0)}
//            default: break
//            
//           }
            
            if let result = brain.performOperation(symbol){
                displayValue = result
            }else{
                displayValue = 0
            }
        }
    }
    
//    func performOperation(operation: (Double,Double)->Double){
//        if instoreNumberArray.count >= 2 {
//            displayValue = operation(instoreNumberArray.removeLast(),instoreNumberArray.removeLast()) //set
//            enterButton()
//        }
//        
//    }
//    
//    @nonobjc func performOperation(operation: Double->Double){
//        if instoreNumberArray.count >= 1 {
//            displayValue = operation(instoreNumberArray.removeLast()) //set
//            enterButton()
//        }
//        
//    }

    
    @IBAction func enterButton() {
        userTyping = false
//        instoreNumberArray.append(displayValue) //get
//        print("instoreNumberArray: \(instoreNumberArray)")
        if let result = brain.pushOperand(displayValue){
            displayValue = result
        }else{
            displayValue = 0
        }
        
    }
    
    var displayValue:Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)" //magic variable
            userTyping = false
        }
        
    }
}

