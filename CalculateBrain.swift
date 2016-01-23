//
//  CalculateBrain.swift
//  Calculater
//
//  Created by Liuliet.Lee on 10/1/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import Foundation

class LLCalculatorBrain {
    
    enum Error: ErrorType {
        case DivideByZero, WrongEquation
    }
    
    /// Input a string equation, output a string result
    func calculateThisEquation(equation: String) -> String {
        return try! calculateEquation(equation)
    }
    
    private func calculateEquation(equation: String) throws -> String {
        let tempArray = Array(equation.characters)
        let calArray = organizeArray(tempArray)
        var firstTimeArray = [String]()
        var finalResult = Double()

        do {
            try firstTimeArray = calculateEquationForTheFirstTime(calArray)
            try finalResult = calculateEquationForTheSecondTime(firstTimeArray)
        } catch Error.DivideByZero {
            return "Error: 1"
        } catch Error.WrongEquation {
            return "Error: 2"
        }
                
        let result = Int(finalResult)
        if Double(result) == finalResult {
            return String(result)
        }
        
        return String(finalResult)
    }
    
    /// Convert the String to an [String]
    private func organizeArray(array: [Character]) -> [String] {
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
                    if temp != "" {
                        returnValue += [temp]
                        temp = ""
                    }
                    returnValue += [String(arr)]
                }
            }
        }
        
        if temp != "" {
            returnValue += [temp]
        }
        
        return returnValue
    }
    
    /// This function will solve ( ) * / ^, leave + and -
    private func calculateEquationForTheFirstTime(var array: [String]) throws -> [String] {
        var firstNumber = Double?()
        var secondNumber = Double?()
        var operation = String()
        var returnArray = [String]()
        
        while array.count > 0 {
            let op = array[0]
            
            if let num = Double(op) {
                if firstNumber == nil {
                    firstNumber = num
                } else {
                    secondNumber = num
                    
                    do {
                        try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    operation = ""
                    secondNumber = nil
                }
            } else {
                switch op {
                case "+", "-":
                    if firstNumber != nil {
                        if let firstNum = firstNumber {
                            returnArray += [String(firstNum)]
                        }
                        firstNumber = nil
                    }
                    returnArray += [op]
                    
                case "*", "/":
                    if operation != "" { throw Error.WrongEquation }
                    
                    operation = op
                    array.removeFirst()

                    var nextArray = [String]()
                    do {
                        try nextArray = calculateEquationForTheFirstTime(array)
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    if nextArray.count == 0 {
                        throw Error.WrongEquation
                    }
                    
                    if let theFirstItemOfNextArray = Double(nextArray[0]) {
                        
                        do {
                            try firstNumber = calculateValue(firstNumber!, secondNumber: theFirstItemOfNextArray, op: operation)
                        } catch Error.DivideByZero {
                            throw Error.DivideByZero
                        } catch Error.WrongEquation {
                            throw Error.WrongEquation
                        }
                        
                        if let firstNum = firstNumber {
                            nextArray[0] = String(firstNum)
                        }
                        
                        returnArray += nextArray
                        return returnArray
                    }
                    
                case "^":
                    if operation != "" { throw Error.WrongEquation }

                    operation = op
                    
                case "(":
                    array.removeFirst()
                    var arr = [String]()
                    var numOfBracket = 1
                    
                    for a in array {
                        array.removeFirst()
                        if a != ")" {
                            if a == "(" {
                                numOfBracket++
                            }
                            arr += [a]
                        } else {
                            numOfBracket--
                            if numOfBracket == 0 {
                                break
                            }
                        }
                    }
                    
                    if numOfBracket != 0 { throw Error.WrongEquation }
                    
                    var inBracket = [String]()
                    
                    do {
                        try inBracket = calculateEquationForTheFirstTime(arr)
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    do {
                        try array = [String(calculateEquationForTheSecondTime(inBracket))] + array
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    continue

                default: throw Error.WrongEquation
                }
            }
            
            array.removeFirst()
        }
        
        if firstNumber != nil {
            if let firstNum = firstNumber {
                returnArray += [String(firstNum)]
            }
        }
        
        if operation != "" { throw Error.WrongEquation }
        
        return returnArray
    }
    
    /// This function will add all items that be left by this first time
    private func calculateEquationForTheSecondTime(var array: [String]) throws -> Double {
        var firstNumber = Double?()
        var secondNumber = Double?()
        var operation = String()
        
        while array.count > 0 {
            let op = array[0]
            
            if let num = Double(op) {
                if firstNumber == nil {
                    firstNumber = num
                } else {
                    secondNumber = num
                    
                    do {
                        try firstNumber = calculateValue(firstNumber!, secondNumber: secondNumber!, op: operation)
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    operation = ""
                    secondNumber = nil
                }
            } else {
                switch op {
                case "+", "-":
                    if firstNumber == nil {
                        firstNumber = 0
                    }
                    
                    if operation != "" { throw Error.WrongEquation }
                    
                    operation = op
                    
                default: throw Error.WrongEquation
                }
            }
            
            array.removeFirst()
        }
        
        if operation != "" { throw Error.WrongEquation }
        
        return firstNumber!
    }
    
    /// First number + - * ^ Second number
    private func calculateValue(firstNumber: Double, secondNumber: Double, op: String) throws -> Double {
        switch op {
        case "+": return firstNumber + secondNumber
        case "-": return firstNumber - secondNumber
        case "*": return firstNumber * secondNumber
        case "/":
            if secondNumber == 0 {
                throw Error.DivideByZero
            }
            return firstNumber / secondNumber
            
        case "^": return pow(firstNumber, secondNumber)
        default:
            throw Error.WrongEquation
        }
    }
}