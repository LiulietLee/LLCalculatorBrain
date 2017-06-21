//
//  CalculateBrain.swift
//  Calculater
//
//  Created by Liuliet.Lee on 10/1/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import Foundation
import Darwin

class LLCalculatorBrain {
    
    fileprivate let pi = Double.pi
    
    enum CalculationError: Error {
        case divideByZero
        case parenthesesDoNotMatch
        case negativeUnderSqrt
        case wrongEquation
    }
    
    /// Input a string equation, output a string result
    func calculateThisEquation(_ equation: String) -> String {
        if equation == "" {
            return "Error: 5"
        }
        return try! calculateEquation(equation)
    }
    
    fileprivate func calculateEquation(_ equation: String) throws -> String {
        do {
            let tempArray = Array(equation.characters)
            let calArray = organizeArray(tempArray)
            var firstTimeArray = [String]()
            var finalResult = Double()

            try firstTimeArray = calculateEquationForTheFirstTime(calArray)
            try finalResult = calculateEquationForTheSecondTime(firstTimeArray)
            
            let result = Int(finalResult)
            if Double(result) == finalResult {
                return String(result)
            }
            
            return String(finalResult)
            
        } catch CalculationError.divideByZero { return "Error: 1"
        } catch CalculationError.parenthesesDoNotMatch { return "Error: 2"
        } catch CalculationError.negativeUnderSqrt { return "Error: 3"
        } catch CalculationError.wrongEquation { return "Error: 4" }
    }
    
    /// Convert the String to an [String]
    fileprivate func organizeArray(_ array: [Character]) -> [String] {
        var temp = String()
        var returnValue = [String]()
        
        for arr in array {
            if let _ = Int(String(arr)) {
                temp += String(arr)
            } else {
                switch arr {
                case ".":
                    temp += String(arr)
                    
                case " ": continue
                    
                default:
                    switch arr {
                    case "+", "-", "*", "/", "^", "(", ")":
                        if temp != "" {
                            returnValue += [temp]
                            temp = ""
                        }
                        returnValue += [String(arr)]

                    default:
                        temp += String(arr)
                        switch temp {
                        case "sin", "cos", "tan", "pi", "sqrt":
                            returnValue += [temp]
                            temp = ""
                            
                        default: break
                        }
                    }
                }
            }
        }
        
        if temp != "" {
            returnValue += [temp]
        }
        
        return returnValue
    }
    
    /// This function will solve ( ) * / ^, leave + and -
    fileprivate func calculateEquationForTheFirstTime(_ array: [String]) throws -> [String] {
        var array = array
        do {
            var firstNumber: Double?
            var secondNumber: Double?
            var operation = String()
            var returnArray = [String]()
            
            while array.count > 0 {
                let op = array[0]
                
                if let num = Double(op) {
                    if firstNumber == nil {
                        firstNumber = num
                    } else {
                        secondNumber = num

                        try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                        
                        operation = ""
                        secondNumber = nil
                    }
                } else {
                    switch op {
                    case "+", "-":
                        if let firstNum = firstNumber {
                            returnArray += [String(firstNum)]
                        }
                        firstNumber = nil
                        returnArray += [op]
                        
                    case "*", "/":
                        if operation != "" { throw CalculationError.wrongEquation }
                        
                        operation = op
                        array.removeFirst()
                        
                        var nextArray = [String]()
                        
                        try nextArray = calculateEquationForTheFirstTime(array)
                        
                        if nextArray.count == 0 {
                            throw CalculationError.wrongEquation
                        }
                        
                        if let theFirstItemOfNextArray = Double(nextArray[0]) {
                            try firstNumber = calculateValue(firstNumber!, secondNumber: theFirstItemOfNextArray, op: operation)
                            
                            if let firstNum = firstNumber {
                                nextArray[0] = String(firstNum)
                            }
                            
                            returnArray += nextArray
                            return returnArray
                        }
                        
                    case "^":
                        if operation != "" { throw CalculationError.wrongEquation }

                        operation = op
                        
                    case "(", "sin", "cos", "tan", "sqrt":
                        array.removeFirst()
                        
                        if op == "sin" || op == "cos" || op == "tan" || op == "sqrt"{
                            array.removeFirst()
                        }

                        var arr = [String]()
                        var numOfBracket = 1
                        
                        for a in array {
                            array.removeFirst()
                            if a != ")" {
                                if a == "(" {
                                    numOfBracket += 1
                                }
                                arr += [a]
                            } else {
                                numOfBracket -= 1
                                if numOfBracket == 0 {
                                    break
                                } else {
                                    arr += [a]
                                }
                            }
                        }
                        
                        if numOfBracket != 0 { throw CalculationError.wrongEquation }
                        
                        let inBracket = try calculateEquationForTheFirstTime(arr)
                       
                        var valueInBracket = try calculateEquationForTheSecondTime(inBracket)
                        
                        if op == "sin" || op == "cos" || op == "tan" || op == "sqrt" {
                            valueInBracket = try calculateValue(valueInBracket, secondNumber: 0, op: op)
                        }
                        
                        array = [String(valueInBracket)] + array

                        continue
                        
                    case "pi":
                        let num = M_PI
                        
                        if firstNumber == nil {
                            firstNumber = num
                        } else {
                            
                            secondNumber = num
                            try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                            operation = ""
                            secondNumber = nil
                        }

                    default: throw CalculationError.wrongEquation
                    }
                }
                
                array.removeFirst()
            }
            
            if firstNumber != nil {
                if let firstNum = firstNumber {
                    returnArray += [String(firstNum)]
                }
            }
            
            if operation != "" { throw CalculationError.wrongEquation }
            
            return returnArray
        } catch CalculationError.divideByZero { throw CalculationError.divideByZero
        } catch CalculationError.parenthesesDoNotMatch { throw CalculationError.parenthesesDoNotMatch
        } catch CalculationError.negativeUnderSqrt { throw CalculationError.negativeUnderSqrt
        } catch CalculationError.wrongEquation { throw CalculationError.wrongEquation }
    }
    
    /// This function will add all items that be left by this first time
    fileprivate func calculateEquationForTheSecondTime(_ array: [String]) throws -> Double {
        var array = array
        do {
            var firstNumber: Double?
            var secondNumber: Double?
            var operation = String()
            
            while array.count > 0 {
                let op = array[0]
                
                if let num = Double(op) {
                    if firstNumber == nil {
                        firstNumber = num
                    } else {
                            secondNumber = num
                            try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                            operation = ""
                            secondNumber = nil
                    }
                } else {
                    switch op {
                    case "+", "-":
                        if firstNumber == nil {
                            firstNumber = 0
                        }
                        
                        if operation != "" { throw CalculationError.wrongEquation }
                        
                        operation = op
                    
                    case "pi":
                        let num = M_PI
                        
                        if firstNumber == nil {
                            firstNumber = num
                        } else {
                            secondNumber = num
                            
                            try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                            
                            operation = ""
                            secondNumber = nil
                        }
                        
                    default: throw CalculationError.wrongEquation
                    }
                }
                
                array.removeFirst()
            }
            
            if operation != "" { throw CalculationError.wrongEquation }
            return firstNumber!

        } catch CalculationError.divideByZero { throw CalculationError.divideByZero
        } catch CalculationError.parenthesesDoNotMatch { throw CalculationError.parenthesesDoNotMatch
        } catch CalculationError.negativeUnderSqrt { throw CalculationError.negativeUnderSqrt
        } catch CalculationError.wrongEquation { throw CalculationError.wrongEquation }
    }

    /// First number + - * ^ Second number
    fileprivate func calculateValue(_ firstNumber: Double, secondNumber: Double, op: String) throws -> Double {
        switch op {
        case "+": return firstNumber + secondNumber
        case "-": return firstNumber - secondNumber
        case "*": return firstNumber * secondNumber
        case "/":
            if secondNumber == 0 {
                throw CalculationError.divideByZero
            }
            return firstNumber / secondNumber
            
        case "^":
            return pow(firstNumber, secondNumber)
        
        case "sin":
            return processSin(firstNumber)
            
        case "cos":
            return processCos(firstNumber)
            
        case "tan":
            return processTan(firstNumber)
            
        case "sqrt":
            if firstNumber < 0 {
                throw CalculationError.negativeUnderSqrt
            }
            return sqrt(firstNumber)
            
        default:
            throw CalculationError.wrongEquation
        }
    }
    
    fileprivate func processSin(_ input: Double) -> Double {
        let r = sin(input)
        return round(r * 100000000) / 100000000
    }
    
    fileprivate func processCos(_ input: Double) -> Double {
        let r = cos(input)
        return round(r * 100000000) / 100000000
    }
    
    fileprivate func processTan(_ input: Double) -> Double {
        let r = tan(input)
        return round(r * 100000000) / 100000000
    }
}
