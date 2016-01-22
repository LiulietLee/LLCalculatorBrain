# LLCalculatorBrain
This is a little stuff that be used to figure out string equation.

## Installation
Just move LLCalculatorBrain.swift to your project.

## Usage
You can see example by downloading Example.zip

    let calculatorBrain = LLCalculatorBrain()

    let equation1 = "1+1" // Or something else
    let result1 = calculatorBrain.calculateThisEquation(equation1) // result = "2"
    
    let equation2 = "1/0"
    let result2 = calculatorBrain.calculateThisEquation(equation2) // result = "Error: 1"
    
    let equation3 = "kadhjfl akjf oiae"
    let result3 = calculatorBrain.calculateThisEquation(equation3) // result = "Error: 2"
