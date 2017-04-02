# LLCalculatorBrain
This is a model that is used to figure out string formula.

## Installation
Just move LLCalculatorBrain.swift to your project.

## Usage
You can see an example in /SampleExample
```
let calculatorBrain = LLCalculatorBrain()

let equation = "tan(2*3^(3+2-3.123)/12.2)+sin(pi)+cos(2)*sqrt(144)" // Or something like this
let result = calculatorBrain.calculateThisEquation(equation) // result = -1.54053662
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
