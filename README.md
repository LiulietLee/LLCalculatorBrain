# LLCalculatorBrain
This is a little stuff that be used to figure out string equation.

## Installation
Just move LLCalculatorBrain.swift to your project.

## Usage
You can see a example in /SampleExample
```
let calculatorBrain = LLCalculatorBrain()

let equation = "tan(2*3^(3+2-3.123)/12.2)+sin(1)+cos(2)*sqrt(144) " // Or something like this
let result = calculatorBrain.calculateThisEquation(equation) // result = -0.69906564
```
There MUST BE a "(" behind sin, cos, tan and sqrt.

### Error Code
* Error 1: Divide by zero
* Error 2: Parentheses do not match
* Error 3: Negative under sqrt
* Error 4: Wrong Equation
* Error 5: Empty Equation

## TO DO
* More Error Catch
