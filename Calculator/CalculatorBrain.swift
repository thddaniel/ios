//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by tanghao on 24/12/2015.
//  Copyright © 2015 tanghao. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum Op: CustomStringConvertible
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String,(Double,Double)->Double)
        
        var description: String{
            get{
                switch self{
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]() //Dictionary
    
    init(){
        func learnOp(op:Op){
            knownOps[op.description] = op
        }
//        knownOps["√"] = Op.UnaryOperation("√", sqrt)
        learnOp(Op.UnaryOperation("√", sqrt))
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["−"] = Op.BinaryOperation("−"){$1-$0}
        knownOps["÷"] = Op.BinaryOperation("÷"){$1/$0}
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty{
            var remainOps = ops
            let op = remainOps.removeLast()
            switch op{
            case .Operand(let operand):
                return(operand, remainOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainOps)
                if let operand = operandEvaluation.result{
                    return(operation(operand), operandEvaluation.remainingOps)
                    }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainOps)
                if let operand1 = operandEvaluation1.result{
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps)
                    if let operand2 = operandEvaluation2.result{
                        return(operation(operand1,operand2), operandEvaluation2.remainingOps)
                    }
                }
            
            }
        }
        return(nil, ops)
    }
    
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        
        return evaluate()
    }
}