//
//  CalculateBrain.swift
//  Calculater
//
//  Created by Liuliet.Lee on 10/1/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import Foundation

class LLCalculatorBrain {
    
    private let pi = M_PI
    
    enum Error: ErrorType {
        case DivideByZero, WrongEquation
    }
    
    /// Input a string equation, output a string result
    func calculateThisEquation(equation: String) -> String {
        if equation == "" {
            return "Error: 2"
        }
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
                        case "sin", "cos", "tan", "pi":
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
                    
                case "(", "sin", "cos", "tan":
                    array.removeFirst()
                    
                    if op == "sin" || op == "cos" || op == "tan" {
                        array.removeFirst()
                    }

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
                            } else {
                                arr += [a]
                            }
                        }
                    }
                    
                    if numOfBracket != 0 { throw Error.WrongEquation }
                    
                    do {
                        let inBracket = try calculateEquationForTheFirstTime(arr)
                       
                        var valueInBracket = try calculateEquationForTheSecondTime(inBracket)
                        
                        if op == "sin" || op == "cos" || op == "tan" {
                            valueInBracket = try calculateValue(valueInBracket, secondNumber: 0, op: op)
                        }
                        
                        array = [String(valueInBracket)] + array
                    } catch Error.DivideByZero {
                        throw Error.DivideByZero
                    } catch Error.WrongEquation {
                        throw Error.WrongEquation
                    }
                    
                    continue
                    
                case "pi":
                    let num = M_PI
                    
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
                
                case "pi":
                    let num = M_PI
                    
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
            
        case "^":
            return pow(firstNumber, secondNumber)
        
        case "sin":
            return sin(firstNumber)
            
        case "cos":
            return cos(firstNumber)
            
        case "tan":
            return tan(firstNumber)
            
        default:
            throw Error.WrongEquation
        }
    }
}