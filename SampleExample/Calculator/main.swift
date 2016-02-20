//
//  main.swift
//  Calculater
//
//  Created by Liuliet.Lee on 10/1/2016.
//  Copyright © 2016 Liuliet.Lee. All rights reserved.
//

import Foundation

var calculateBrain = LLCalculatorBrain()

print("Calculater")
print("Created by Liuliet.Lee on 10/1/2016\n")

var equation = ""

while(equation != "0") {
    print("\nPlease input your equation (type 0 to exit):")
    equation = readLine(stripNewline: true)!
    
    let result = calculateBrain.calculateThisEquation(equation)
    
    print("The result is: ", result)
}
